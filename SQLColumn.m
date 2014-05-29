//
//  SQLColumn.m
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLColumn.h"





@implementation SQLColumn

- (instancetype)init {
    return [self initWithName:nil];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self->_name = [name copy];
    }
    return self;
}

+ (instancetype)column:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (SQLString *)SQL {
    return [SQLString string:self.name];
}

@end


