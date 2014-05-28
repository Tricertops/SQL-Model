//
//  SQLColumn.h
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLObject.h"





@interface SQLColumn : SQLObject

#define SQLCol(col)  ([SQLColumn column:@#col])
- (instancetype)initWithName:(NSString *)name;
+ (instancetype)column:(NSString *)name;
@property (readonly, copy) NSString *name;

@end


