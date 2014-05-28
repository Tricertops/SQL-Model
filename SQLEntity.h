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

- (instancetype)initWithPrimaryKey:(id)primaryKey;
@property (readonly) id primaryKey;

+ (instancetype)insert:(id)primaryKey;
+ (instancetype)select:(id)primaryKey;
//TODO: +select:sorted:range:
//TODO: SQLPredicate: class cluster, literal, nil, like, match, regexp, between, in, not, per column
//TODO: SQLOrdering: class cluster, single, multiple, from string, with expression
//TODO: SQLRange: typedef NSRange SQLRange, SQLRangeMake(offset, limit), SQLRangeNext(range)
- (BOOL)insert;
- (BOOL)fetch;
- (BOOL)doesExist;
- (BOOL)revert;
- (BOOL)save;
- (BOOL)replace:(id)primaryKey;
- (BOOL)delete;
//TODO: SQLError



+ (NSString *)sql_instanceNameFromClassName:(NSString *)className;
+ (NSString *)sql_tableNameFromInstanceName:(NSString *)className;
+ (NSDictionary *)sql_properties;
+ (id)sql_associatedObjectForKey:(void *)key withCreation:(id(^)(void))block;


@end


