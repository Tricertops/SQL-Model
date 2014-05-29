//
//  SQLString.m
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLString.h"
#import "SQLObject.h"





@interface SQLString ()


@property NSMutableAttributedString *internal;


@end


NSString *const SQLStringArgumentAttributeKey = @"SQLStringArgumentAttributeKey";





@implementation SQLString





- (instancetype)init {
    return [self initWithString:nil arguments:nil];
}


- (instancetype)initWithString:(NSString *)string arguments:(NSArray *)arguments {
    self = [super init];
    if (self) {
        self.internal = [[NSMutableAttributedString alloc] initWithString:string];
        
        NSUInteger count = [self enumerateArgumentsUsingBlock:^SQLString *(NSUInteger index, NSRange range, id missing) {
            SQLAssertMessage(arguments.count > index, @"Too many '$' placeholders") return nil;
            id argument = [arguments objectAtIndex:index];
            
            if ([argument isKindOfClass:[SQLString class]]) {
                //TODO: wrap in parenthesis
                return (SQLString *)argument;
            }
            else {
                [self.internal addAttribute:SQLStringArgumentAttributeKey value:argument range:range];
            }
            return nil;
        }];
        SQLAssertMessage(count == arguments.count, @"Too few '$' placeholders");
    }
    return self;
}


+ (instancetype)string:(NSString *)string {
    return [[self alloc] initWithString:string arguments:nil];
}


+ (instancetype)string:(NSString *)string arguments:(NSArray *)arguments {
    return [[self alloc] initWithString:string arguments:arguments];
}





- (NSUInteger)enumerateArgumentsUsingBlock:(SQLString *(^)(NSUInteger index, NSRange range, id argument))block {
    NSRange searchRange = NSMakeRange(0, self.internal.length);
    NSUInteger index = 0;
    
    while (INFINITY) {
        NSRange placeholderRange = [self.internal.string rangeOfString:@"$" options:kNilOptions range:searchRange];
        if (placeholderRange.location == NSNotFound) break;
        
        NSRange argumentRange = NSMakeRange(NSNotFound, 0);
        id argument = [self.internal attribute:SQLStringArgumentAttributeKey atIndex:placeholderRange.location effectiveRange:&argumentRange];
        
        SQLAssert(argumentRange.location == placeholderRange.location);
        SQLAssert(argumentRange.length == placeholderRange.length);
        
        SQLString *replacement = block(index, placeholderRange, argument);
        if (replacement) {
            [self.internal replaceCharactersInRange:placeholderRange withAttributedString:replacement.internal];
            placeholderRange.length = replacement.length;
        }
        
        searchRange.location = NSMaxRange(placeholderRange);
        searchRange.length = self.internal.length - searchRange.location;
        
        index ++;
        SQLAssertMessage(index < 1000, @"Infinite cycle ... or too many arguments?");
    }
    
    return index; // count
}


- (NSUInteger)length {
    return self.internal.length;
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
    SQLString *prepend = [SQLString stringFromAnything:anything];
    [self.internal insertAttributedString:prepend.internal atIndex:0];
    return self;
}


- (instancetype)prepend:(NSString *)string arguments:(NSArray *)arguments {
    return [self prepend:[SQLString string:string arguments:arguments]];
}


- (instancetype)append:(id)anything {
    SQLString *append = [SQLString stringFromAnything:anything];
    [self.internal appendAttributedString:append.internal];
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


