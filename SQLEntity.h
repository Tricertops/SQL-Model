//
//  SQLEntity.h
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import Foundation;
#import "SQLAnnotations.h"





@interface SQLEntity : NSObject


+ (NSString *)instanceName;


+ (NSDictionary *)sql_properties;


@end


