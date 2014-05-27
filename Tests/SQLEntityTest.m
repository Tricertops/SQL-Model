//
//  SQLEntityTest.m
//  SQL Model Tests
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import XCTest;
#import "SQLTestBottle.h"



@interface SQLEntityTest : XCTestCase

@end





@implementation SQLEntityTest





- (void)test_automagicInstanceName {
    XCTAssertEqualObjects([SQLTestBottle instanceName], @"testBottle");
    XCTAssertEqualObjects([SQLTestFlask instanceName], @"testFlask");
    XCTAssertEqualObjects([SQLEntity sql_instanceNameFromClassName:@"ABCDevil"], @"devil");
}


- (void)test_automagicTableName {
    NSString *(^plural)(NSString *) = ^(NSString *singular) {
        return [SQLEntity sql_tableNameFromInstanceName:singular];
    };
    
    // -s
    XCTAssertEqualObjects([SQLTestBottle tableName], @"testBottles");
    XCTAssertEqualObjects([SQLTestFlask tableName], @"testFlasks");
    
    // -es
    XCTAssertEqualObjects(plural(@"box"), @"boxes");
    XCTAssertEqualObjects(plural(@"clearGlass"), @"clearGlasses");
    XCTAssertEqualObjects(plural(@"witch"), @"witches");
    
    // -ies
    XCTAssertEqualObjects(plural(@"boy"), @"boys");
    XCTAssertEqualObjects(plural(@"day"), @"days");
    XCTAssertEqualObjects(plural(@"berry"), @"berries");
    XCTAssertEqualObjects(plural(@"baby"), @"babies");
    
    // -ves
    XCTAssertEqualObjects(plural(@"knife"), @"knives");
    XCTAssertEqualObjects(plural(@"half"), @"halves");
    
    // <irregular>
    XCTAssertEqualObjects(plural(@"badChild"), @"badChildren");
    XCTAssertEqualObjects(plural(@"goodPerson"), @"goodPeople");
    XCTAssertEqualObjects(plural(@"fish"), @"fish");
    XCTAssertEqualObjects(plural(@"woman"), @"women");
    XCTAssertEqualObjects(plural(@"barracks"), @"barracks");
}





@end


