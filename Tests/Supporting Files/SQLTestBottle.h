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
@property (atomic, readwrite, strong) NSString<SQLNotNil, SQLIndexed> *title;
@property (atomic, readwrite, strong) NSString<SQL> *code;
@property (atomic, readwrite, strong) NSData<SQLUnique> *token;



@end


