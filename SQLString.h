//
//  SQLString.h
//  SQL Model
//
//  Created by Martin Kiss on 28.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;





@interface SQLString : NSObject


#define SQLPlaceholer   $
- (instancetype)initWithString:(NSString *)string arguments:(NSArray *)arguments;
+ (instancetype)string:(NSString *)string;
+ (instancetype)string:(NSString *)string arguments:(NSArray *)arguments;

- (instancetype)prepend:(id)string;
- (instancetype)prepend:(NSString *)string arguments:(NSArray *)arguments;
- (instancetype)append:(id)string;
- (instancetype)append:(NSString *)string arguments:(NSArray *)arguments;

+ (instancetype)arguments:(NSArray *)arguments joinedWithString:(NSString *)string;


@property (readonly) NSUInteger length;


@end


