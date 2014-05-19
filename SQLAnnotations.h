//
//  SQLAnnotations.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;





@protocol SQLAnnotation @end

#define SQLAnnotation(name, class) \
@protocol name <SQLAnnotation> @end \
@interface class (name) <name> @end \

SQLAnnotation(SQL, NSObject)
SQLAnnotation(SQLNotNil, NSObject)
SQLAnnotation(SQLUnique, NSObject)
SQLAnnotation(SQLPrimary, NSObject)
SQLAnnotation(SQLIndexed, NSObject)


