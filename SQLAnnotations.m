//
//  SQLAnnotations.m
//  SQL Model
//
//  Created by Martin Kiss on 20.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

@import ObjectiveC;
#import "SQLAnnotations.h"





@implementation NSObject (SQLAnnotations)





- (BOOL)sql_isAnnotationProtocol {
    return ([self isKindOfClass:NSClassFromString(@"Protocol")] // Objective-C runtime class
            && [NSStringFromProtocol((Protocol *)self) hasPrefix:@"SQL"]);
}


- (NSSet *)sql_annotations {
    NSSet *annotations = objc_getAssociatedObject(self, _cmd);
    if ( ! annotations) {
        annotations = [self sql_buildAnnotations];
        objc_setAssociatedObject(self, _cmd, annotations, OBJC_ASSOCIATION_RETAIN);
    }
    return annotations;
}


- (NSSet *)sql_buildAnnotations {
    NSMutableSet *annotations = [[NSMutableSet alloc] init];
    
    if ([self sql_isAnnotationProtocol]) [annotations addObject:NSStringFromProtocol((Protocol *)self)]; // Includes self.
    else return [NSSet set]; // None.
    
    unsigned int count = 0;
    Protocol * __unsafe_unretained *adoptedList = protocol_copyProtocolList((Protocol *)self, &count);
    for (unsigned int index = 0; index < count; index++) {
        Protocol *adopted = adoptedList[index];
        [annotations unionSet:[adopted sql_annotations]]; // Recursively up.
    }
    return [annotations copy];
}





@end


