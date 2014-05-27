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
    // -s
    XCTAssertEqualObjects([SQLTestBottle tableName], @"testBottles");
    XCTAssertEqualObjects([SQLTestFlask tableName], @"testFlasks");
    
    // -es
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"box"], @"boxes");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"clearGlass"], @"clearGlasses");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"witch"], @"witches");
    
    // -ies
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"boy"], @"boys");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"day"], @"days");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"berry"], @"berries");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"baby"], @"babies");
    
    // -ves
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"knife"], @"knives");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"half"], @"halves");
    
    // <irregular>
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"badChild"], @"badChildren");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"goodPerson"], @"goodPeople");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"fish"], @"fish");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"woman"], @"women");
    XCTAssertEqualObjects([SQLEntity sql_tableNameFromInstanceName:@"barracks"], @"barracks");
}





@end


