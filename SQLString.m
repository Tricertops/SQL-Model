//
//  SQLString.m
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLString.h"
#import "SQLObject.h"





@implementation SQLString





- (instancetype)init {
    return [self initWithString:@"" arguments:nil];
}


- (instancetype)initWithString:(NSString *)string arguments:(NSArray *)arguments {
    self = [super init];
    if (self) {
        //TODO: Underlaying implementation
    }
    return self;
}


+ (instancetype)string:(NSString *)string {
    return [[self alloc] initWithString:string arguments:nil];
}


+ (instancetype)string:(NSString *)string arguments:(NSArray *)arguments {
    return [[self alloc] initWithString:string arguments:arguments];
}





+ (SQLString *)stringFromAnything:(id)anything {
    SQLString *sql = nil;
    if ([anything isKindOfClass:[SQLString class]]) {
        sql = anything;
    }
    else if ([anything isKindOfClass:[NSString class]]) {
        sql = [SQLString string:anything];
    }
    else if ([anything conformsToProtocol:@protocol(SQLObject)]) {
        sql = [(id<SQLObject>)anything SQL];
    }
    else {
        sql = [SQLString string:[anything description]];
    }
    return sql;
}


- (instancetype)prepend:(id)anything {
    SQLString *append = [SQLString stringFromAnything:anything];
    //TODO: Mutate
    return self;
}


- (instancetype)prepend:(NSString *)string arguments:(NSArray *)arguments {
    return [self prepend:[SQLString string:string arguments:arguments]];
}


- (instancetype)append:(id)anything {
    SQLString *append = [SQLString stringFromAnything:anything];
    //TODO: Mutate
    return self;
}


- (instancetype)append:(NSString *)string arguments:(NSArray *)arguments {
    return [self append:[SQLString string:string arguments:arguments]];
}





+ (instancetype)arguments:(NSArray *)arguments joinedWithString:(NSString *)string {
    SQLString *sql = [SQLString new];
    NSString *format = [NSString stringWithFormat:@"%@$", string ?: @""];
    BOOL first = YES;
    for (id arg in arguments) {
        [sql append:(first? @"$" : format) arguments:@[arg]];
        first = NO;
    }
    return sql;
}





@end


