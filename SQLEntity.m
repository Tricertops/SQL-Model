//
//  SQLEntity.m
//  SQL Model
//
//  Created by Martin Kiss on 19.5.14.
//  Copyright (c) 2014 Triceratops. All rights reserved.
//

#import "SQLEntity.h"
#import "SQLProperty.h"





@implementation SQLEntity





+ (NSString *)tableName {
    return [self sql_associatedObjectForKey:_cmd withCreation:^id{
        return [self sql_tableNameFromInstanceName:[self instanceName]];
    }];
}


+ (NSString *)instanceName {
    return [self sql_associatedObjectForKey:_cmd withCreation:^id{
        return [self sql_instanceNameFromClassName:NSStringFromClass(self)];
    }];
}





- (instancetype)initWithPrimaryKey:(id)primaryKey {
    self = [super init];
    if (self) {
        SQLProperty *primaryProperty = [self.class sql_primaryProperty];
        [self setValue:primaryKey forKey:primaryProperty.name];
    }
    return self;
}


- (id)primaryKey {
    SQLProperty *primaryProperty = [self.class sql_primaryProperty];
    return [self valueForKey:primaryProperty.name];
}





+ (NSString *)sql_instanceNameFromClassName:(NSString *)class {
    NSScanner *scanner = [NSScanner scannerWithString:class];
    scanner.caseSensitive = YES;
    scanner.charactersToBeSkipped = nil;
    NSString *prefix = nil;
    [scanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&prefix];
    if ( ! prefix.length) return scanner.string; // Maybe begins with lowercase
    
    NSString *firstLetter = [prefix substringFromIndex:prefix.length - 1];
    NSString *remainder = [scanner.string substringFromIndex:scanner.scanLocation];
    return [NSString stringWithFormat:@"%@%@", [firstLetter lowercaseString], remainder];
}


+ (NSString *)sql_tableNameFromInstanceName:(NSString *)instance {
    //! This method uses English rules to derive plural form of the input noun to be used as a table name.
    
    // These pairs must begin with the same letter!
    NSDictionary *exceptions = @{
                                 @"fish": @"",
                                 @"sheep": @"",
                                 @"barracks": @"",
                                 @"foot": @"feet",
                                 @"tooth": @"teeth",
                                 @"goose": @"geese",
                                 @"child": @"children",
                                 @"man": @"men", // also works for derivates, like ‘woman’ or ‘fireman’
                                 @"person": @"people",
                                 @"mouse": @"mice",
                                 };
    for (NSString *suffix in exceptions) {
        NSRange range = [instance rangeOfString:suffix options:(NSBackwardsSearch | NSAnchoredSearch | NSCaseInsensitiveSearch)];
        if (range.location != NSNotFound) {
            NSString *replacement = [exceptions objectForKey:suffix];
            if ( ! replacement.length) return instance; // without plural form
            
            NSUInteger replaceIndex = range.location + 1;
            NSRange replacemrntRange = NSMakeRange(replaceIndex, instance.length - replaceIndex);
            return [instance stringByReplacingCharactersInRange:replacemrntRange withString:[replacement substringFromIndex:1]];
        }
    }
    
    if ([instance hasSuffix:@"y"]) {
        BOOL yWithVowel = ([instance hasSuffix:@"ay"]
                           || [instance hasSuffix:@"ey"]
                           || [instance hasSuffix:@"iy"]
                           || [instance hasSuffix:@"oy"]
                           || [instance hasSuffix:@"uy"]);
        if ( ! yWithVowel) {
            // y with consonant
            NSRange yRange = NSMakeRange(instance.length - 1, 1);
            return [instance stringByReplacingCharactersInRange:yRange withString:@"ies"];
        }
    }
    
    if ([instance hasSuffix:@"ch"] // Exception: If the -ch is pronounced as a ‘k’, we should add -s rather than -es.
        || [instance hasSuffix:@"s"]
        || [instance hasSuffix:@"sh"]
        || [instance hasSuffix:@"x"]
        || [instance hasSuffix:@"z"]) {
        // Exception: There are nouns ending with -o that should always use -es.
        return [instance stringByAppendingString:@"es"];
    }
    
    if ([instance hasSuffix:@"f"]) {
        // Exception: Nouns ending with two vowels plus -f usually appends just an -s.
        NSRange fRange = NSMakeRange(instance.length - 1, 1);
        return [instance stringByReplacingCharactersInRange:fRange withString:@"ves"];
    }
    
    if ([instance hasSuffix:@"fe"]) {
        NSRange feRange = NSMakeRange(instance.length - 2, 2);
        return [instance stringByReplacingCharactersInRange:feRange withString:@"ves"];
    }
    
    return [instance stringByAppendingString:@"s"];
}


+ (NSDictionary *)sql_properties {
    return [self sql_associatedObjectForKey:_cmd withCreation:^id{
        BOOL hasEntitySuperclass = [self.superclass isSubclassOfClass:[SQLEntity class]];
        NSDictionary *superclassProperties = (hasEntitySuperclass? [self.superclass sql_properties] : nil);
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:superclassProperties];
        unsigned int count = 0;
        objc_property_t *underlaying = class_copyPropertyList(self, &count);
        for (unsigned int index = 0; index < count; index++) {
            SQLProperty *property = [[SQLProperty alloc] initWithEntity:self property:underlaying[index]];
            if ( ! property)  continue;
            
            [properties setObject:property forKey:property.name]; // Overrides superclass properties.
        }
        return properties;
    }];
}


+ (SQLProperty *)sql_primaryProperty {
    return [self.class sql_associatedObjectForKey:_cmd withCreation:^id{
        for (SQLProperty *property in [self.class sql_properties]) {
            if (property.isPrimaryKey) return property;
        }
        return nil;
    }];
}


+ (id)sql_associatedObjectForKey:(void *)key withCreation:(id(^)(void))block {
    id object = objc_getAssociatedObject(self, key);
    if ( ! object) {
        object = block();
        objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
    }
    return object;
}





@end


