//
//  SQLProperty.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;
@import ObjectiveC.message;





@interface SQLProperty : NSObject


@property (atomic, readonly, strong) Class entityClass;

@property (atomic, readonly, assign) BOOL isAtomic;
@property (atomic, readonly, assign) BOOL isWritable;
@property (atomic, readonly, assign) BOOL isWeak;
@property (atomic, readonly, assign) BOOL isCopy;
@property (atomic, readonly, assign) BOOL isStrong;

@property (atomic, readonly, strong) Class valueClass;

@property (atomic, readonly, strong) NSArray *annotations;
- (BOOL)hasAnnotation:(Protocol *)annotation;
@property (atomic, readonly, assign) BOOL isManaged;
@property (atomic, readonly, assign) BOOL allowsNil;
@property (atomic, readonly, assign) BOOL isUnique;
@property (atomic, readonly, assign) BOOL isPrimaryKey;
@property (atomic, readonly, assign) BOOL isIndexed;

@property (atomic, readonly, copy) NSString *name;
@property (atomic, readonly, copy) NSString *ivar;


@end





@interface SQLProperty (/* Private */)


- (instancetype)initWithEntity:(Class)entityClass name:(NSString *)name;
@property (atomic, readonly, assign) objc_property_t property;


@end

