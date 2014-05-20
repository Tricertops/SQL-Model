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

SQLAnnotation(SQLNotNil, NSObject)
SQLAnnotation(SQLIndexed, NSObject)
SQLAnnotation(SQLUnique, NSObject, SQLIndexed)
SQLAnnotation(SQLPrimary, NSObject, SQLUnique, SQLNotNil)


@interface NSObject (SQLAnnotations)

- (BOOL)sql_isAnnotationProtocol;
- (NSSet *)sql_annotations;

@end


