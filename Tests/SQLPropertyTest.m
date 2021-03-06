//
//  SQLPropertyTest.m
//  SQL Model
//
//  Created by Martin Kiss on 21.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import XCTest;
#import "SQLTestBottle.h"
#import "SQLProperty.h"





@interface SQLPropertyTest : XCTestCase

@end



@implementation SQLPropertyTest





- (void)test_notAnnotatedProperty {
    XCTAssertNil([[SQLTestBottle sql_properties] objectForKey:@"nothing"]);
}


- (void)test_generalAnnotationsAndAttributes {
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


- (void)test_numericAnnotations {
    {
        // @property NSNumber<SQL> *balance;
        SQLProperty *balance = [[SQLTestBottle sql_properties] objectForKey:@"balance"];
        
        XCTAssertTrue(balance.isNumber);
        XCTAssertFalse(balance.isBoolean);
        XCTAssertFalse(balance.isInteger);
        XCTAssertFalse(balance.isUnsigned);
        XCTAssertTrue(balance.isDecimal, @"Default should be Decimal.");
    }{
        // @property NSNumber<SQLUnsigned> *count;
        SQLProperty *count = [[SQLTestBottle sql_properties] objectForKey:@"count"];
        
        XCTAssertTrue(count.isNumber);
        XCTAssertFalse(count.isBoolean);
        XCTAssertTrue(count.isInteger);
        XCTAssertTrue(count.isUnsigned);
        XCTAssertFalse(count.isDecimal);
    }{
        // @property NSNumber<SQLUnsigned> *count;
        SQLProperty *count = [[SQLTestBottle sql_properties] objectForKey:@"enabled"];
        
        XCTAssertTrue(count.isNumber);
        XCTAssertTrue(count.isBoolean);
        XCTAssertFalse(count.isInteger);
        XCTAssertFalse(count.isUnsigned);
        XCTAssertFalse(count.isDecimal);
    }{
        // @property NSNumber<SQLBoolean, SQLDecimal> *fuzzy;
        SQLProperty *fuzzy = [[SQLTestBottle sql_properties] objectForKey:@"fuzzy"];
        
        XCTAssertTrue(fuzzy.isNumber);
        XCTAssertFalse(fuzzy.isBoolean, @"Lower range is discarded.");
        XCTAssertFalse(fuzzy.isInteger);
        XCTAssertFalse(fuzzy.isUnsigned);
        XCTAssertTrue(fuzzy.isDecimal, @"Higher range is preserved.");
    }
}


- (void)test_subclassExtendsAnnotations {
    // @property (nonatomic, readonly, copy) NSString<SQLIndexed> *title;
    SQLProperty *title = [[SQLTestFlask sql_properties] objectForKey:@"title"];
    
    XCTAssertEqualObjects(title.entityClass, [SQLTestFlask class]);
    
    XCTAssertFalse(title.isAtomic);
    XCTAssertFalse(title.isWritable);
    XCTAssertFalse(title.isWeak);
    XCTAssertTrue(title.isCopy);
    XCTAssertFalse(title.isStrong);
    
    XCTAssertEqualObjects(title.valueClass, [NSString class]);
    
    XCTAssertTrue(title.allowsNil);
    XCTAssertFalse(title.isUnique);
    XCTAssertFalse(title.isPrimaryKey);
    XCTAssertTrue(title.isIndexed);
    
    XCTAssertEqualObjects(title.name, @"title");
    XCTAssertNil(title.ivar); //TODO: ivar is not inherited
}


- (void)test_inherited {
    NSDictionary *properties = [SQLTestFlask sql_properties];
    //TODO: properties not collected from superclasses
    XCTAssertNotNil(properties[@"identifier"]);
    XCTAssertNotNil(properties[@"title"]);
    XCTAssertNotNil(properties[@"code"]);
    XCTAssertNotNil(properties[@"token"]);
    XCTAssertNotNil(properties[@"info"]);
}






@end


