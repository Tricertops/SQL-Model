//
//  SQLProperty.m
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLProperty.h"
#import "SQLAnnotations.h"





@implementation SQLProperty





- (instancetype)initWithEntity:(Class)entityClass name:(NSString *)name {
    self = [super init];
    if (self) {
        self->_entityClass = entityClass;
        self->_name = name;
        
        self->_property = class_getProperty(entityClass, name.UTF8String);
        
        NSString *attributesString = @(property_getAttributes(self->_property));
        NSArray *attributesArray = [attributesString componentsSeparatedByString: @","];
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        for (NSString *attributeString in attributesArray) {
            NSString *key = [attributeString substringToIndex:1];
            NSString *value = [attributeString substringFromIndex:1]; // Can be empty, but never nil.
            [attributes setObject:value forKey:key];
        }
        
        self->_isAtomic = ([attributes objectForKey:@"N"] == nil);
        self->_isWritable = ([attributes objectForKey:@"R"] != nil);
        self->_isWeak = ([attributes objectForKey:@"W"] != nil);
        self->_isCopy = ([attributes objectForKey:@"C"] != nil);
        self->_isStrong = ([attributes objectForKey:@"&"] != nil);
        
        NSString *type = [attributes objectForKey:@"T"];
        if ([type hasPrefix:@(@encode(id))]) {
            //TODO: Collect superclasses?
            NSArray *protocols = nil;
            self->_valueClass = [self classFromType:type protocols:&protocols];
            self->_annotations = [self annotationsFromProtocols:protocols];
        }
        
        self->_isManaged = (self.annotations.count > 0);
        self->_allowsNil = [self hasAnnotation:@protocol(SQLNotNil)];
        self->_isUnique = [self hasAnnotation:@protocol(SQLUnique)];
        self->_isPrimaryKey = [self hasAnnotation:@protocol(SQLPrimary)];
        self->_isIndexed = [self hasAnnotation:@protocol(SQLIndexed)];
        
        self->_ivar = [attributes objectForKey:@"V"];
    }
    return self;
}


- (Class)classFromType:(NSString *)type protocols:(NSArray **)protocols {
    NSString *classString = [type substringWithRange:NSMakeRange(2, type.length - 3)]; // remove @"…"
    
    NSRange protocolsBeginning = [classString rangeOfString:@"<"];
    if (protocolsBeginning.location != NSNotFound) {
        NSRange protocolsRange = NSMakeRange(protocolsBeginning.location + 1, classString.length - 2); // remove <…>
        if (protocols) {
            NSString *protocolsString = [classString substringWithRange:protocolsRange];
            *protocols = [protocolsString componentsSeparatedByString:@","];
        }
        classString = [classString substringToIndex:protocolsBeginning.location];
    }
    return NSClassFromString(classString);
}


- (NSArray *)annotationsFromProtocols:(NSArray *)protocols {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    NSCharacterSet * const whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    for (NSString *protocol in protocols) {
        NSString *annotation = [protocol stringByTrimmingCharactersInSet:whitespace];
        if ([annotation hasPrefix:@"SQL"]) {
            [annotations addObject:annotation];
        }
    }
    return [annotations copy];
}


- (BOOL)hasAnnotation:(Protocol *)annotation {
    NSString *annotationName = @(protocol_getName(annotation));
    return [self.annotations containsObject:annotationName];
}





@end


