//
//  SQLTestBottle.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLEntity.h"





@interface SQLTestBottle : SQLEntity


@property (atomic, readwrite, strong) NSUUID<SQLPrimary> *identifier;
@property (nonatomic, readonly, copy) NSString<SQL> *title;
@property NSString<SQLNotNil, SQLIndexed> *code;
@property (weak) id<SQLUnique> token;


@end





@interface SQLTestFlask : SQLTestBottle


@property (nonatomic, readonly, copy) NSString<SQLIndexed> *title;
@property (nonatomic, readonly, copy) NSString<SQLNotNil, SQLIndexed> *code;
@property (weak) id<SQLIndexed> token;


@end


