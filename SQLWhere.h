//
//  SQLWhere.h
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLObject.h"
#import "SQLColumn.h"





@interface SQLWhere : SQLObject


+ (instancetype)string:(NSString *)string arguments:(NSArray *)arguments;

+ (instancetype)all:(SQLWhere *)condition, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype)any:(SQLWhere *)condition, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)not;

@property (readonly) SQLString *SQL;


@end





@interface SQLColumn (SQLWhere)


- (SQLWhere *)isNil;
- (SQLWhere *)isNotNil;
- (SQLWhere *)isEqualTo:(id)what;
- (SQLWhere *)isNotEqualTo:(id)what;
- (SQLWhere *)isLessThan:(id)what;
- (SQLWhere *)isLessThanOrEqualTo:(id)what;
- (SQLWhere *)isGreaterThan:(id)what;
- (SQLWhere *)isGreaterThanOrEqualTo:(id)what;
- (SQLWhere *)isLike:(id)what; //TODO: Only NSString?
- (SQLWhere *)matches:(id)what; //TODO: Only NSString?
- (SQLWhere *)isIn:(NSArray *)whats;
- (SQLWhere *)isBetween:(id)what and:(id)what;


@end


