//
//  SQLTestBottle.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLEntity.h"





@interface SQLTestBottle : SQLEntity


@property NSString *nothing;
@property (atomic, readwrite, strong) NSUUID<SQLPrimary> *identifier;
@property (nonatomic, readonly, copy) NSString<SQL> *title;
@property NSString<SQLNotNil, SQLIndexed> *code;
@property (weak) id<SQLUnique> token;

@property NSNumber<SQL> *balance;
@property NSNumber<SQLUnsigned> *count;
@property NSNumber<SQLBoolean> *enabled;


@end





@interface SQLTestFlask : SQLTestBottle


@property (nonatomic, readonly, copy) NSString<SQLIndexed> *title;
@property (copy) NSString<SQL> *info;


@end


