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
    XCTAssertEqualObjects([SQLTestBottle tableName], @"testBottles");
    XCTAssertEqualObjects([SQLTestFlask tableName], @"testFlasks");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"box"], @"boxes");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"clearGlass"], @"clearGlasses");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"badChild"], @"badChildren");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"goodPerson"], @"goodPeople");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"fish"], @"fish");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"woman"], @"women");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"barracks"], @"barracks");
}





@end


