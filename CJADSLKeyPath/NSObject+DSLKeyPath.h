//
//  NSObject+DSLKeyPath.h
//  ValueDSL
//
//  Created by Carl Jahn on 02.05.14.
//  Copyright (c) 2014 Carl Jahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DSLKeyPath)

- (id)valueForDSLKeyPath:(NSString *)keyPath;

@end
