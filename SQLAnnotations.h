//
//  SQLAnnotations.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;





@protocol SQL @end
@interface NSObject (SQL) <SQL> @end

#define SQLAnnotation(name, class, supers...) \
@protocol name <SQL, ##supers> @end \
@interface class (name) <name> @end \

//! General Property Annotations

SQLAnnotation(SQLNotNil, NSObject) //!< Cannot contain nil value. You must provide default value in some way. //TODO: In what way?
SQLAnnotation(SQLIndexed, NSObject) //!< Index table is created for annotated property.
SQLAnnotation(SQLUnique, NSObject, SQLIndexed) //!< Value of annotated property must be unique in the entity. Implies indexing.
SQLAnnotation(SQLPrimary, NSObject, SQLUnique, SQLNotNil) //!< Marks primary key. Implies uniqueness and the value cannot be nil (but cannot have a default value). So far only one primary key is supported. //TODO: Support multiple primary keys.

//! Numeric Property Annotations

SQLAnnotation(SQLBoolean, NSNumber) //!< Number backed by Boolean SQL type.
SQLAnnotation(SQLInteger, NSNumber) //!< Number backed by Integer SQL type. Signed Long by default, but can be changed by other annotations. //TODO: Annotations for length.
SQLAnnotation(SQLUnsigned, NSNumber, SQLInteger) //!< Integer to be unsigned. Signed is the default.
SQLAnnotation(SQLDecimal, NSNumber) //!< Number backed by suitable Decimal SQL type. This is the default for NSNumbers.



@interface NSObject (SQLAnnotations)

- (BOOL)sql_isAnnotationProtocol;
- (NSSet *)sql_annotations;

@end


