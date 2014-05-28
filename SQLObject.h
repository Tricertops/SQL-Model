//
//  SQLObject.h
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;

#import "SQLString.h"





@protocol SQLObject <NSObject>

- (SQLString *)SQL;

@end





@interface SQLObject : NSObject <SQLObject>

@end





#define SQLVariadic(FIRST)\
(NSMutableArray *)({\
    va_list list;\
    va_start(list, FIRST);\
    NSMutableArray *objects = [[NSMutableArray alloc] init];\
    id object = FIRST;\
    while (object) {\
        [objects addObject:object];\
        object = va_arg(list, id);\
    }\
    va_end(list);\
    objects;\
})


