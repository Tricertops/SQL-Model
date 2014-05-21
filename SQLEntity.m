//
//  SQLEntity.m
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLEntity.h"
#import "SQLProperty.h"





@implementation SQLEntity





+ (NSDictionary *)sql_properties {
    NSDictionary *properties = objc_getAssociatedObject(self, _cmd);
    if ( ! properties) {
        properties = [self sql_buildProperties];
        objc_setAssociatedObject(self, _cmd, properties, OBJC_ASSOCIATION_RETAIN);
    }
    return properties;
}


+ (NSDictionary *)sql_buildProperties {
    //TODO: Superclasses
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    objc_property_t *underlaying = class_copyPropertyList(self, &count);
    for (unsigned int index = 0; index < count; index++) {
        SQLProperty *property = [[SQLProperty alloc] initWithEntity:self property:underlaying[index]];
        if ( ! property)  continue;
        
        [properties setObject:property forKey:property.name];
    }
    return properties;
}





@end


