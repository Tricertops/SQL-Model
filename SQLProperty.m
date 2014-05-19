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





@implementation SQLProperty





- (instancetype)initWithEntity:(Class)entityClass name:(NSString *)name {
    self = [super init];
    if (self) {
        
        SQLAssert(entityClass) return nil;
        self->_entityClass = entityClass;
        
        SQLAssert(name.length) return nil;
        self->_name = name;
        
        self->_property = class_getProperty(entityClass, name.UTF8String);
        SQLAssertMessage(self.property, @"Property with name %@ not found in entity %@.", name, entityClass) return nil;
        
        NSDictionary *attributes = [self attributesOfProperty:self.property];
        
        self->_isAtomic = ([attributes objectForKey:@"N"] == nil);
        self->_isWritable = ([attributes objectForKey:@"R"] != nil);
        self->_isWeak = ([attributes objectForKey:@"W"] != nil);
        self->_isCopy = ([attributes objectForKey:@"C"] != nil);
        self->_isStrong = ([attributes objectForKey:@"&"] != nil);
        
        NSString *type = [attributes objectForKey:@"T"];
        SQLAssertMessage([type hasPrefix:@(@encode(id))], @"Works only for properties of object type.") return nil;
        
        NSArray *protocols = nil;
        self->_valueClass = [self classFromType:type protocols:&protocols];
        self->_annotations = [self annotationsFromProtocols:protocols];
        
        self->_isManaged = (self.annotations.count > 0);
        self->_allowsNil = [self hasAnnotation:@protocol(SQLNotNil)];
        self->_isUnique = [self hasAnnotation:@protocol(SQLUnique)];
        self->_isPrimaryKey = [self hasAnnotation:@protocol(SQLPrimary)];
        self->_isIndexed = [self hasAnnotation:@protocol(SQLIndexed)];
        
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


- (NSArray *)annotationsFromProtocols:(NSArray *)inProtocols {
    NSMutableArray *protocols = [[NSMutableArray alloc] init];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    //TODO: Whitespace?
    
    while (protocols.count) {
        NSString *protocolName = protocols[0];
        [protocols removeObjectAtIndex:0];
        
        if ([protocolName hasPrefix:@"SQL"] && objc_getProtocol(protocolName.UTF8String)) {
            
            if ( ! [annotations containsObject:protocolName]) {
                [annotations addObject:protocolName];
            }
            
            NSArray *superProtocols = [self superProtocolsOfProtocol:protocolName];
            [protocols addObjectsFromArray:superProtocols];
        }
    }
    return [annotations copy];
}


- (NSArray *)superProtocolsOfProtocol:(NSString *)protocolName {
    NSMutableArray *protocols = [[NSMutableArray alloc] init];
    Protocol *protocol = objc_getProtocol(protocolName.UTF8String);
    unsigned int count = 0;
    Protocol * __unsafe_unretained *superProtocols = protocol_copyProtocolList(protocol, &count);
    for (unsigned int index = 0; index < count; index++) {
        [protocols addObject:@( protocol_getName(superProtocols[index]) )];
    }
    return [protocols copy];
}


- (BOOL)hasAnnotation:(Protocol *)annotation {
    NSString *annotationName = @(protocol_getName(annotation));
    return [self.annotations containsObject:annotationName];
}





@end


