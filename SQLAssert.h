//
//  SQLAssert.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;



#define SQLAssert(CONDITION) \
    if ( ! (CONDITION) && (( _SQLCrash(__PRETTY_FUNCTION__, @#CONDITION, nil), YES)) )

#define SQLAssertMessage(CONDITION, MESSAGE, ...) \
    if ( ! (CONDITION) && (( _SQLCrash(__PRETTY_FUNCTION__, @#CONDITION, MESSAGE, ##__VA_ARGS__), YES)) )

#define SQLCrash(MESSAGE, ...) \
    _SQLCrash(__PRETTY_FUNCTION__, @"NO", MESSAGE, ##__VA_ARGS__)

extern void _SQLCrash(const char *function, NSString *condition, NSString *message, ...) NS_FORMAT_FUNCTION(3, 4);


