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


@property (atomic, readonly, strong) Class entityClass;

@property (atomic, readonly, assign) BOOL isAtomic;
@property (atomic, readonly, assign) BOOL isWritable;
@property (atomic, readonly, assign) BOOL isWeak;
@property (atomic, readonly, assign) BOOL isCopy;
@property (atomic, readonly, assign) BOOL isStrong;

@property (atomic, readonly, strong) Class valueClass;

@property (atomic, readonly, strong) NSSet *annotations;
- (BOOL)hasAnnotation:(Protocol *)annotation;
@property (atomic, readonly, assign) BOOL allowsNil;
@property (atomic, readonly, assign) BOOL isIndexed;
@property (atomic, readonly, assign) BOOL isUnique;
@property (atomic, readonly, assign) BOOL isPrimaryKey;

@property (atomic, readonly, assign) BOOL isNumber;
@property (atomic, readonly, assign) BOOL isBoolean;
@property (atomic, readonly, assign) BOOL isInteger;
@property (atomic, readonly, assign) BOOL isUnsigned;
@property (atomic, readonly, assign) BOOL isDecimal;

@property (atomic, readonly, copy) NSString *name;
@property (atomic, readonly, copy) NSString *ivar;


@end





@interface SQLProperty (/* Private */)


- (instancetype)initWithEntity:(Class)class property:(objc_property_t)property;
@property (atomic, readonly, assign) objc_property_t property;


@end


