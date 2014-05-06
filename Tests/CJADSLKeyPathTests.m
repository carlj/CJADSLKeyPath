//
//  CJADSLKeyPathTests.m
//  CJADSLKeyPathTests
//
//  Created by Carl Jahn on 05.05.14.
//  Copyright (c) 2014 Carl Jahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+DSLKeyPath.h"
@interface CJADSLKeyPathTests : XCTestCase

@end

@implementation CJADSLKeyPathTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleObject {
    
    NSDictionary *object = @{
                             @"test" : @"foo"
                             };
    
    id value = [object valueForDSLKeyPath:@"test"];
    XCTAssertEqualObjects(value, @"foo", @"value isnt the same");
}

- (void)testNestedObject {
    
    NSDictionary *object = @{
                             @"test" : @"foo",
                             @"nested" : @{
                                     @"name" : @"bar"
                                     }
                             };
    
    id value = [object valueForDSLKeyPath:@"nested.name"];
    XCTAssertEqualObjects(value, @"bar", @"value isnt the same");
}

- (void)testNestedArrays {
    
    NSDictionary *object = @{
                             @"test" : @"foo",
                             @"nested" : @{
                                     @"name" : @"bar",
                                     @"items" : @[
                                             @{ @"value1" : @"1"},
                                             @{ @"value1" : @"2"},
                                             @{ @"value1" : @"3"},
                                             @{ @"value1" : @"4"},
                                             ]
                                     }
                             };
    
    id value = [object valueForDSLKeyPath:@"nested.items"];
    XCTAssertNotNil(value, @"value is nil");
    
    XCTAssertTrue([value isKindOfClass:[NSArray class]], @"value istn a array");
    
    NSArray *item = (NSArray *)value;
    XCTAssertEqual(item.count, 4, @"value hasnt 4 items");
}

- (void)testCollectionSelector {
    
    NSDictionary *object = @{
                             @"test" : @"foo",
                             @"nested" : @{
                                     @"name" : @"bar",
                                     @"items" : @[
                                             @{ @"value1" : @"0" , @"value2" : @"foo"},
                                             @{ @"value1" : @"1" , @"value2" : @"foo"},
                                             @{ @"value1" : @"2" , @"value2" : @"foo"},
                                             @{ @"value1" : @"3" , @"value2" : @"foo"},
                                             ]
                                     }
                             };
    
    id value = [object valueForDSLKeyPath:@"nested.items[*].value1"];
    XCTAssertNotNil(value, @"value is nil");
    
    XCTAssertTrue([value isKindOfClass:[NSArray class]], @"value istn a NSArray");
    
    NSArray *items = (NSArray *)value;
    XCTAssertEqual(items.count, 4, @"value hasnt 4 items");
    
    
    for (NSUInteger index = 0; index < items.count; index++) {
        id itemValue = items[index];
        
        
        XCTAssertTrue([itemValue isKindOfClass:[NSString class]], @"itemValue istn a NSString");
        NSString *itemValueString = [NSString stringWithFormat:@"%d", index];
        XCTAssertEqualObjects(itemValue, itemValueString, @"values arent the same");
        
        
    }
}

- (void)testAdvancedCollectionSelector1 {
    
    NSDictionary *object = @{
                             @"root" : @[
                                     
                                     @{
                                         @"test" : @"foo",
                                         @"nested" : @{
                                                 @"name" : @"bar",
                                                 @"items" : @[
                                                         @{ @"value1" : @"0" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"1" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"2" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"3" , @"value2" : @"foo"},
                                                         ]
                                                 }
                                         },
                                     @{
                                         @"test" : @"foo",
                                         @"nested" : @{
                                                 @"name" : @"bar",
                                                 @"items" : @[
                                                         @{ @"value1" : @"4" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"5" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"6" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"7" , @"value2" : @"foo"},
                                                         ]
                                                 }
                                         }
                                     
                                     
                                     ]
                             
                             };
    
    id value = [object valueForDSLKeyPath:@"root[*].nested.items[*]"];
    XCTAssertNotNil(value, @"value is nil");
    
    XCTAssertTrue([value isKindOfClass:[NSArray class]], @"value istn a NSArray");
    
    NSArray *items = (NSArray *)value;
    XCTAssertEqual(items.count, 8, @"value hasnt 4 items");
    
    
    for (NSUInteger index = 0; index < items.count; index++) {
        id itemValue = items[index];
        
        
        XCTAssertTrue([itemValue isKindOfClass:[NSDictionary class]], @"itemValue istn a NSDictionary");
        NSString *itemValueString = [NSString stringWithFormat:@"%d", index];
        XCTAssertEqualObjects(itemValue[@"value1"], itemValueString, @"values arent the same");
        
        
    }
}

- (void)testAdvancedCollectionSelector2 {
    
    NSDictionary *object = @{
                             @"root" : @[
                                     
                                     @{
                                         @"test" : @"foo",
                                         @"nested" : @{
                                                 @"name" : @"bar",
                                                 @"items" : @[
                                                         @{ @"value1" : @"0" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"1" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"2" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"3" , @"value2" : @"foo"},
                                                         ]
                                                 }
                                         },
                                     @{
                                         @"test" : @"foo",
                                         @"nested" : @{
                                                 @"name" : @"bar",
                                                 @"items" : @[
                                                         @{ @"value1" : @"4" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"5" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"6" , @"value2" : @"foo"},
                                                         @{ @"value1" : @"7" , @"value2" : @"foo"},
                                                         ]
                                                 }
                                         }
                                     
                                     
                                     ]
                             
                             };
    
    id value = [object valueForDSLKeyPath:@"root[*].nested.items[*].value1"];
    XCTAssertNotNil(value, @"value is nil");
    
    XCTAssertTrue([value isKindOfClass:[NSArray class]], @"value istn a NSArray");
    
    NSArray *items = (NSArray *)value;
    XCTAssertEqual(items.count, 8, @"value hasnt 4 items");
    
    
    for (NSUInteger index = 0; index < items.count; index++) {
        id itemValue = items[index];
        
        
        XCTAssertTrue([itemValue isKindOfClass:[NSString class]], @"itemValue istn a NSString");
        NSString *itemValueString = [NSString stringWithFormat:@"%d", index];
        XCTAssertEqualObjects(itemValue, itemValueString, @"values arent the same");
        
        
    }
}

@end
