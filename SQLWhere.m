//
//  SQLWhere.m
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLWhere.h"





@implementation SQLWhere



- (instancetype)initWithSQLString:(SQLString *)string {
    self = [super init];
    if (self) {
        self->_SQL = string;
    }
    return self;
}


+ (instancetype)string:(NSString *)string arguments:(NSArray *)arguments {
    SQLString *sql = [SQLString string:string arguments:arguments];
    return [[self alloc] initWithSQLString:sql];
}


+ (instancetype)all:(id)condition, ... NS_REQUIRES_NIL_TERMINATION {
    SQLString *sql = [SQLString arguments:SQLVariadic(condition) joinedWithString:@" AND "];
    return [[self alloc] initWithSQLString:sql];
}


+ (instancetype)any:(id)condition, ... NS_REQUIRES_NIL_TERMINATION {
    SQLString *sql = [SQLString arguments:SQLVariadic(condition) joinedWithString:@" OR "];
    return [[self alloc] initWithSQLString:sql];
}


- (instancetype)not {
    return [SQLWhere string:@"NOT $" arguments:@[self]];
}



@end





@implementation SQLColumn (SQLWhere)





- (SQLWhere *)isNil {
    return [self isEqualTo:nil];
}


- (SQLWhere *)isNotNil {
    return [self isNotEqualTo:nil];
}


- (SQLWhere *)isEqualTo:(id)what {
    return [SQLWhere string:@"$ IS $" arguments:@[self, what ?: NSNull.null]];
}


- (SQLWhere *)isNotEqualTo:(id)what {
    return [SQLWhere string:@"$ IS NOT $" arguments:@[self, what ?: NSNull.null]];
}


- (SQLWhere *)isLessThan:(id)what {
    return [SQLWhere string:@"$ < $" arguments:@[self, what]];
}


- (SQLWhere *)isLessThanOrEqualTo:(id)what {
    return [SQLWhere string:@"$ <= $" arguments:@[self, what]];
}


- (SQLWhere *)isGreaterThan:(id)what {
    return [SQLWhere string:@"$ > $" arguments:@[self, what]];
}


- (SQLWhere *)isGreaterThanOrEqualTo:(id)what {
        return [SQLWhere string:@"$ >= $" arguments:@[self, what]];
}


- (SQLWhere *)isLike:(id)what {
    return [SQLWhere string:@"$ LIKE $" arguments:@[self, what]];
}


- (SQLWhere *)matches:(id)what {
    return [SQLWhere string:@"$ MATCHES $" arguments:@[self, what]];
}


- (SQLWhere *)isIn:(NSArray *)whats {
    return [SQLWhere string:@"$ IN $" arguments:@[self, whats]];
}


- (SQLWhere *)isBetween:(id)first and:(id)second {
    return [SQLWhere string:@"$ BETWEEN $ AND $" arguments:@[self, first, second]];
}





@end


