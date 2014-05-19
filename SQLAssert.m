//
//  SQLAssert.m
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLAssert.h"





void _SQLCrash(const char *function, NSString *condition, NSString *format, ...)  {
    NSMutableString *reason = [NSMutableString stringWithFormat:@"Assertion failure in %s, unsatisfied: (%@)", function, condition];
    
    if (format) {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        [reason appendFormat:@", message: “%@”", message];
    }
    
    NSLog(@"%@", reason);
#ifdef DEBUG
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
#endif
}


