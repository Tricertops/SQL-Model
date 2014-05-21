//
//  SQLProperty.m
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLProperty.h"
#import "SQLAnnotations.h"
#import "SQLAssert.h"





@interface NSString (SQLProperty)

- (NSRange)sql_rangeBetweenString:(NSString *)opening andString:(NSString *)closing;
- (NSString *)sql_substringBetweenString:(NSString *)opening andString:(NSString *)closing;

@end





@implementation SQLProperty





- (instancetype)initWithEntity:(Class)entityClass property:(objc_property_t)property {
    self = [super init];
    if (self) {
        
        SQLAssert(entityClass) return nil;
        self->_entityClass = entityClass;
        
        SQLAssert(property) return nil;
        self->_property = property;
        self->_name = @(property_getName(property));
        
        NSDictionary *attributes = [self attributesOfProperty:property];
        
        self->_isAtomic = ([attributes objectForKey:@"N"] == nil);
        self->_isWritable = ([attributes objectForKey:@"R"] == nil);
        self->_isWeak = ([attributes objectForKey:@"W"] != nil);
        self->_isCopy = ([attributes objectForKey:@"C"] != nil);
        self->_isStrong = ([attributes objectForKey:@"&"] != nil);
        
        NSString *type = [attributes objectForKey:@"T"];
        SQLAssertMessage([type hasPrefix:@(@encode(id))], @"Works only for properties of object type.") return nil;
        
        NSSet *annotations = nil;
        self->_valueClass = [self classFromType:type annotations:&annotations];
        self->_annotations = annotations;
        
        BOOL isManaged = (self.annotations.count > 0);
        if ( ! isManaged) return nil;
        
        [self detectNumberWithoutAnnotation];
        [self consolidateNumericTypes];
        
        self->_ivar = [attributes objectForKey:@"V"];
    }
    return self;
}


- (NSDictionary *)attributesOfProperty:(objc_property_t)property {
    NSString *attributesString = @(property_getAttributes(property));
    NSArray *attributesArray = [attributesString componentsSeparatedByString: @","];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    for (NSString *attributeString in attributesArray) {
        NSString *key = [attributeString substringToIndex:1];
        NSString *value = [attributeString substringFromIndex:1]; // Can be empty, but never nil.
        [attributes setObject:value forKey:key];
    }
    return attributes;
}


- (Class)classFromType:(NSString *)type annotations:(NSSet **)annotationsPtr {
    type = [type sql_substringBetweenString:@"@\"" andString:@"\""]; // remove @"…"
    
    NSRange protocolsRange = [type sql_rangeBetweenString:@"<" andString:@">"]; // find <…>
    BOOL noProtocols = (protocolsRange.location == NSNotFound);
    NSInteger classEnd = (noProtocols || protocolsRange.location < 1
                          ? type.length
                          : protocolsRange.location - 1);
    NSString *classString = [type substringToIndex:classEnd];
    NSString *protocolsString = (noProtocols? nil : [type substringWithRange:protocolsRange]);
    
    if (protocolsString.length) {
        // Protocols are listed like: <First><Second><Third>
        NSArray *protocolNames = [protocolsString componentsSeparatedByString:@"><"];
        NSMutableSet *annotations = [[NSMutableSet alloc] init];
        
        for (NSString *protocolName in protocolNames) {
            Protocol *protocol = NSProtocolFromString(protocolName);
            [annotations unionSet:[(id)protocol sql_annotations]];
        }
        *annotationsPtr = annotations;
    }
    return NSClassFromString(classString);
}


- (BOOL)hasAnnotation:(Protocol *)annotation {
    SQLAssert([(id)annotation sql_isAnnotationProtocol]) return NO;
    NSString *name = NSStringFromProtocol(annotation);
    return [self.annotations containsObject:name];
}


- (void)addAnnotation:(Protocol *)annotation {
    self->_annotations = [self.annotations setByAddingObject:NSStringFromProtocol(annotation)];
}


- (void)removeAnnotation:(Protocol *)annotation {
    NSString *name = NSStringFromProtocol(annotation);
    if ( ! [self.annotations containsObject:name]) return;
    
    NSMutableSet *mutable = [self.annotations mutableCopy];
    [mutable removeObject:name];
    self->_annotations = [mutable copy];
}


- (BOOL)detectNumberWithoutAnnotation {
    if ( ! [self.valueClass isSubclassOfClass:[NSNumber class]]) return NO;
    if (self.isNumber) return NO; // Already is number.
    [self addAnnotation:@protocol(SQLDecimal)];
    //TODO: Report to client
    return YES;
}


- (BOOL)consolidateNumericTypes {
    BOOL isDecimal = self.isDecimal;
    BOOL isInteger = self.isInteger;
    BOOL isBoolean = self.isBoolean;
    if (isDecimal && (isInteger || isBoolean)) {
        [self removeAnnotation:@protocol(SQLInteger)];
        [self removeAnnotation:@protocol(SQLUnsigned)];
        [self removeAnnotation:@protocol(SQLBoolean)];
        //TODO: Report to client
        return YES;
    }
    if (isInteger && isBoolean) {
        [self removeAnnotation:@protocol(SQLBoolean)];
        //TODO: Report to client
        return YES;
    }
    return NO;
}





- (NSString *)description {
    NSMutableString *d = [[NSMutableString alloc] init];
    [d appendString:@"@property ("];
    [d appendFormat:@"%@, ", (self.isAtomic? @"atomic" : @"nonatomic")];
    [d appendFormat:@"%@, ", (self.isWritable? @"readwrite" : @"readonly")];
    [d appendFormat:@"%@) ", (self.isWeak? @"weak"
                              : (self.isCopy? @"copy"
                                 : (self.isStrong? @"strong"
                                    : @"unsafe_unretained")))];
    [d appendString:(NSStringFromClass(self.valueClass) ?: @"id")];
    [d appendFormat:@"<%@> ", [[self.annotations allObjects] componentsJoinedByString:@","]];
    if ( ! self.valueClass) [d appendString:@"*"];
    [d appendFormat:@"%@;  ", self.name];
    if (self.ivar.length) {
        [d appendFormat:@"@synthesize %@ = %@;", self.name, self.ivar];
    }
    else {
        [d appendFormat:@"@dynamic %@;", self.name];
    }
    return [d copy];
}


- (BOOL)allowsNil {
    return ! [self hasAnnotation:@protocol(SQLNotNil)];
}


- (BOOL)isIndexed {
    return [self hasAnnotation:@protocol(SQLIndexed)];
}


- (BOOL)isUnique {
    return [self hasAnnotation:@protocol(SQLUnique)];
}


- (BOOL)isPrimaryKey {
    return [self hasAnnotation:@protocol(SQLPrimary)];
}


- (BOOL)isNumber {
    return self.isBoolean || self.isInteger || self.isDecimal;
}


- (BOOL)isBoolean {
    return [self hasAnnotation:@protocol(SQLBoolean)];
}


- (BOOL)isInteger {
    return [self hasAnnotation:@protocol(SQLInteger)];
}


- (BOOL)isUnsigned {
    return [self hasAnnotation:@protocol(SQLUnsigned)];
}


- (BOOL)isDecimal {
    return [self hasAnnotation:@protocol(SQLDecimal)];
}








@end





@implementation NSString (SQLProperty)



- (NSRange)sql_rangeBetweenString:(NSString *)opening andString:(NSString *)closing {
    NSRange openingRange = [self rangeOfString:opening ?: @""];
    if (openingRange.location == NSNotFound) {
        return openingRange;
    }
    NSUInteger openingMax = NSMaxRange(openingRange);
    NSRange closingRange = [self rangeOfString:closing ?: @""
                                       options:NSBackwardsSearch
                                         range:NSMakeRange(openingMax, self.length - openingMax)];
    if (closingRange.location == NSNotFound) {
        closingRange = NSMakeRange(self.length, 0);
    }
    return NSMakeRange(openingMax, closingRange.location - openingMax);
}


- (NSString *)sql_substringBetweenString:(NSString *)opening andString:(NSString *)closing {
    NSRange range = [self sql_rangeBetweenString:opening andString:closing];
    if (range.location == NSNotFound)
        return nil;
    else
        return [self substringWithRange:range];
}



@end


