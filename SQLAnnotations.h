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
SQLAnnotation(SQLPrimary, NSObject, SQLUnique, SQLNotNil) //!< Marks primary key. Implies uniqueness and the value cannot be nil (but cannot have a default value).


@interface NSObject (SQLAnnotations)

- (BOOL)sql_isAnnotationProtocol;
- (NSSet *)sql_annotations;

@end


