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
    
    id nestedObject = [self valueForKey: cleanedOutFirstPath];
    if (![self hasKeyPathACollectionPatterns:firstPath]) {
        return [nestedObject valueForDSLKeyPath: restOfthePath];
    }
    
    if (!pathComponents.count) {
        return nestedObject;
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
    
    BOOL hasAStarInIt = !(NSNotFound == [keyPath rangeOfString:@"[*]"].location);
    
    return hasAStarInIt;
}

- (NSString *)cleanedCollectionPatternsPathForKey:(NSString *)key {
    
    NSRange range = [key rangeOfString:@"["];
    
    if (NSNotFound == range.location) {
        return key;
    }
    
    return [key substringToIndex: range.location];
}

@end
