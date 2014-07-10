//
//  NSObject+DSLKeyPath.m
//  ValueDSL
//
//  Created by Carl Jahn on 02.05.14.
//  Copyright (c) 2014 Carl Jahn. All rights reserved.
//

#import "NSObject+DSLKeyPath.h"

@implementation NSObject (DSLKeyPath)

- (id)valueForDSLKeyPath:(NSString *)keyPath {
    
    BOOL hasPathACollectionPatterns = [self hasKeyPathACollectionPatterns:keyPath];
    
    if (!hasPathACollectionPatterns) {

        return [self valueForKeyPath:keyPath];
    }

    NSMutableArray *pathComponents = [[keyPath componentsSeparatedByString:@"."] mutableCopy];

    NSString *firstPath = pathComponents.firstObject;
    NSString *cleanedOutFirstPath = [self cleanedCollectionPatternsPathForKey: firstPath ];
    
    [pathComponents removeObjectIdenticalTo: firstPath];
    NSString *restOfthePath = [pathComponents componentsJoinedByString:@"."];
    
    if ([cleanedOutFirstPath isEqualToString:@"*"]) {
        return self;
    }
    
    id nestedObject = [self valueForKey: cleanedOutFirstPath];
    if (![self hasKeyPathACollectionPatterns:firstPath]) {
        return [nestedObject valueForDSLKeyPath: restOfthePath];
    }
    
    if (!pathComponents.count) {
        return nestedObject;
    }
    
    
    NSString *collectionPattern = [self collectionPatternsPathForKey: firstPath ];
    if (![collectionPattern isEqualToString:@"*"]) {
        
        NSInteger index = [collectionPattern integerValue];
        
        NSArray *arrayObject = (NSArray *)nestedObject;
        if (index >= 0 && index < arrayObject.count) {
            
            id nestedItem = arrayObject[index];
            return [nestedItem valueForDSLKeyPath: restOfthePath];
        }

    }
    
    NSMutableArray *result = [NSMutableArray array];

    for (id nestedItem in nestedObject) {
        
        id nestedResult = [nestedItem valueForDSLKeyPath: restOfthePath];
        if ([nestedResult isKindOfClass: [NSArray class] ]) {
            [result addObjectsFromArray: nestedResult];

        } else {
            [result addObject: nestedResult];
        }
        
    }
    
    return result;
}

#pragma mark - Helper Methods
- (BOOL)hasKeyPathACollectionPatterns:(NSString *)keyPath {
    
    BOOL hasCollectionPattern = !(NSNotFound == [keyPath rangeOfString:@"["].location);
    BOOL hasStar = !(NSNotFound == [keyPath rangeOfString:@"*"].location);

    return hasCollectionPattern || hasStar;
}

- (NSString *)collectionPatternsPathForKey:(NSString *)key {

    
    NSRange rangeStart = [key rangeOfString:@"["];
    NSRange rangeEnd = [key rangeOfString:@"]"];
    

    if (NSNotFound == rangeStart.location || NSNotFound == rangeEnd.location) {
        return key;
    }


    NSRange subStringRange = NSMakeRange(rangeStart.location + 1, rangeEnd.location - rangeStart.location - 1);
    
    return [key substringWithRange:subStringRange];
}

- (NSString *)cleanedCollectionPatternsPathForKey:(NSString *)key {
    
    NSRange range = [key rangeOfString:@"["];
    
    if (NSNotFound == range.location) {
        return key;
    }
    
    return [key substringToIndex: range.location];
}

@end
