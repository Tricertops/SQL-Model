//
//  SQLEntityTest.m
//  SQL Model Tests
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import XCTest;
#import "SQLTestBottle.h"
#import "SQLProperty.h"



@interface SQLEntityTest : XCTestCase

@end





@implementation SQLEntityTest



- (void)test_properties {
    {
        // @property (atomic, readwrite, strong) NSUUID<SQLPrimary> *identifier;
        SQLProperty *identifier = [[SQLTestBottle sql_properties] objectForKey:@"identifier"];
        
        XCTAssertEqualObjects(identifier.entityClass, [SQLTestBottle class]);
        
        XCTAssertTrue(identifier.isAtomic);
        XCTAssertTrue(identifier.isWritable);
        XCTAssertFalse(identifier.isWeak);
        XCTAssertFalse(identifier.isCopy);
        XCTAssertTrue(identifier.isStrong);
        
        XCTAssertEqualObjects(identifier.valueClass, [NSUUID class]);
        
        XCTAssertFalse(identifier.allowsNil);
        XCTAssertTrue(identifier.isUnique);
        XCTAssertTrue(identifier.isPrimaryKey);
        XCTAssertTrue(identifier.isIndexed);
        
        XCTAssertEqualObjects(identifier.name, @"identifier");
        XCTAssertEqualObjects(identifier.ivar, @"_identifier");
    }{
        // @property (nonatomic, readonly, copy) NSString<SQL> *title;
        SQLProperty *title = [[SQLTestBottle sql_properties] objectForKey:@"title"];
        
        XCTAssertEqualObjects(title.entityClass, [SQLTestBottle class]);
        
        XCTAssertFalse(title.isAtomic);
        XCTAssertFalse(title.isWritable);
        XCTAssertFalse(title.isWeak);
        XCTAssertTrue(title.isCopy);
        XCTAssertFalse(title.isStrong);
        
        XCTAssertEqualObjects(title.valueClass, [NSString class]);
        
        XCTAssertTrue(title.allowsNil);
        XCTAssertFalse(title.isUnique);
        XCTAssertFalse(title.isPrimaryKey);
        XCTAssertFalse(title.isIndexed);
        
        XCTAssertEqualObjects(title.name, @"title");
        XCTAssertEqualObjects(title.ivar, @"_title");
    }{
        // @property NSString<SQLNotNil, SQLIndexed> *code;
        SQLProperty *code = [[SQLTestBottle sql_properties] objectForKey:@"code"];
        
        XCTAssertEqualObjects(code.entityClass, [SQLTestBottle class]);
        
        XCTAssertTrue(code.isAtomic);
        XCTAssertTrue(code.isWritable);
        XCTAssertFalse(code.isWeak);
        XCTAssertFalse(code.isCopy);
        XCTAssertTrue(code.isStrong);
        
        XCTAssertEqualObjects(code.valueClass, [NSString class]);
        
        XCTAssertFalse(code.allowsNil);
        XCTAssertFalse(code.isUnique);
        XCTAssertFalse(code.isPrimaryKey);
        XCTAssertTrue(code.isIndexed);
        
        XCTAssertEqualObjects(code.name, @"code");
        XCTAssertEqualObjects(code.ivar, @"_code");
    }{
        // @property (weak) id<SQLUnique> token;
        SQLProperty *token = [[SQLTestBottle sql_properties] objectForKey:@"token"];
        
        XCTAssertEqualObjects(token.entityClass, [SQLTestBottle class]);
        
        XCTAssertTrue(token.isAtomic);
        XCTAssertTrue(token.isWritable);
        XCTAssertTrue(token.isWeak);
        XCTAssertFalse(token.isCopy);
        XCTAssertFalse(token.isStrong);
        
        XCTAssertNil(token.valueClass);
        
        XCTAssertTrue(token.allowsNil);
        XCTAssertTrue(token.isUnique);
        XCTAssertFalse(token.isPrimaryKey);
        XCTAssertTrue(token.isIndexed);
        
        XCTAssertEqualObjects(token.name, @"token");
        XCTAssertEqualObjects(token.ivar, @"_token");
    }
}



@end


