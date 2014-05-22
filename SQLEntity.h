//
//  SQLEntity.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;
#import "SQLAnnotations.h"





@interface SQLEntity : NSObject


+ (NSString *)instanceName;
+ (NSString *)tableName;


+ (NSString *)sql_instanceNameFromClassName:(NSString *)className;
+ (NSString *)sql_tableNameFromInstanceName:(NSString *)className;
+ (NSDictionary *)sql_properties;
+ (id)sql_associatedObjectForKey:(void *)key withCreation:(id(^)(void))block;


@end


