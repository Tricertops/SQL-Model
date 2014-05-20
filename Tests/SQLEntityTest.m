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
        SQLProperty *identifier = [[SQLTestBottle sql_properties] objectForKey:@"title"];
        
        XCTAssertEqualObjects(identifier.entityClass, [SQLTestBottle class]);
        
        XCTAssertFalse(identifier.isAtomic);
        XCTAssertFalse(identifier.isWritable);
        XCTAssertFalse(identifier.isWeak);
        XCTAssertTrue(identifier.isCopy);
        XCTAssertFalse(identifier.isStrong);
        
        XCTAssertEqualObjects(identifier.valueClass, [NSString class]);
        
        XCTAssertTrue(identifier.allowsNil);
        XCTAssertFalse(identifier.isUnique);
        XCTAssertFalse(identifier.isPrimaryKey);
        XCTAssertFalse(identifier.isIndexed);
        
        XCTAssertEqualObjects(identifier.name, @"title");
        XCTAssertEqualObjects(identifier.ivar, @"_title");
    }{
        // @property NSString<SQLNotNil, SQLIndexed> *code;
        SQLProperty *identifier = [[SQLTestBottle sql_properties] objectForKey:@"code"];
        
        XCTAssertEqualObjects(identifier.entityClass, [SQLTestBottle class]);
        
        XCTAssertTrue(identifier.isAtomic);
        XCTAssertTrue(identifier.isWritable);
        XCTAssertFalse(identifier.isWeak);
        XCTAssertFalse(identifier.isCopy);
        XCTAssertTrue(identifier.isStrong);
        
        XCTAssertEqualObjects(identifier.valueClass, [NSString class]);
        
        XCTAssertFalse(identifier.allowsNil);
        XCTAssertFalse(identifier.isUnique);
        XCTAssertFalse(identifier.isPrimaryKey);
        XCTAssertTrue(identifier.isIndexed);
        
        XCTAssertEqualObjects(identifier.name, @"code");
        XCTAssertEqualObjects(identifier.ivar, @"_code");
    }{
        // @property (weak) id<SQLUnique> token;
        SQLProperty *identifier = [[SQLTestBottle sql_properties] objectForKey:@"token"];
        
        XCTAssertEqualObjects(identifier.entityClass, [SQLTestBottle class]);
        
        XCTAssertTrue(identifier.isAtomic);
        XCTAssertTrue(identifier.isWritable);
        XCTAssertTrue(identifier.isWeak);
        XCTAssertFalse(identifier.isCopy);
        XCTAssertFalse(identifier.isStrong);
        
        XCTAssertNil(identifier.valueClass);
        
        XCTAssertTrue(identifier.allowsNil);
        XCTAssertTrue(identifier.isUnique);
        XCTAssertFalse(identifier.isPrimaryKey);
        XCTAssertTrue(identifier.isIndexed);
        
        XCTAssertEqualObjects(identifier.name, @"token");
        XCTAssertEqualObjects(identifier.ivar, @"_token");
    }
}



@end


