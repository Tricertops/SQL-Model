//
//  SQLProperty.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;
@import ObjectiveC;





@interface SQLProperty : NSObject


@property (readonly) Class entityClass;

@property (readonly) BOOL isAtomic;
@property (readonly) BOOL isWritable;
@property (readonly) BOOL isWeak;
@property (readonly) BOOL isCopy;
@property (readonly) BOOL isStrong;

@property (readonly) Class valueClass;

@property (readonly, copy) NSSet *annotations;
- (BOOL)hasAnnotation:(Protocol *)annotation;
@property (readonly) BOOL allowsNil;
@property (readonly) BOOL isIndexed;
@property (readonly) BOOL isUnique;
@property (readonly) BOOL isPrimaryKey;

@property (readonly) BOOL isNumber;
@property (readonly) BOOL isBoolean;
@property (readonly) BOOL isInteger;
@property (readonly) BOOL isUnsigned;
@property (readonly) BOOL isDecimal;

@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *ivar;


@end





@interface SQLProperty (/* Private */)


- (instancetype)initWithEntity:(Class)class property:(objc_property_t)property;
@property (readonly) objc_property_t property;


@end


