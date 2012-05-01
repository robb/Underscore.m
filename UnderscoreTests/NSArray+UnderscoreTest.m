//
//  NSArray+UnderscoreTest.m
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

#import "NSArray+UnderscoreTest.h"

@implementation NSArray_UnderscoreTest

- (void)testFromToAcending
{
    NSArray *range = [NSArray __from:0 to:8];

    NSArray *expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],
                                                  [NSNumber numberWithInteger:1],
                                                  [NSNumber numberWithInteger:2],
                                                  [NSNumber numberWithInteger:3],
                                                  [NSNumber numberWithInteger:4],
                                                  [NSNumber numberWithInteger:5],
                                                  [NSNumber numberWithInteger:6],
                                                  [NSNumber numberWithInteger:7],
                                                  nil];

    STAssertEqualObjects(expected, range, @"Could generate asending range");
}

- (void)testFromToDescending
{
    NSArray *range = [NSArray __from:2 to:-2];
    
    NSArray *expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:2],
                                                  [NSNumber numberWithInteger:1],
                                                  [NSNumber numberWithInteger:0],
                                                  [NSNumber numberWithInteger:-1],
                                                  nil];
    
    STAssertEqualObjects(expected, range, @"Could generate descending range");
}

- (void)testFromToStepAcending
{
    NSArray *range = [NSArray __from:1 to:8 step:2];
    
    NSArray *expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1],
                                                  [NSNumber numberWithInteger:3],
                                                  [NSNumber numberWithInteger:5],
                                                  [NSNumber numberWithInteger:7],
                                                  nil];
    
    STAssertEqualObjects(expected, range, @"Could generate ascending range");
}

- (void)testFromToStepDescending
{
    NSArray *range = [NSArray __from:2 to:-2 step:-2];
 
    NSArray *expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:2],
                                                  [NSNumber numberWithInteger:0],
                                                  nil];
 
    STAssertEqualObjects(expected, range, @"Could generate descending range");
}

- (void)testFirst
{
    STAssertNil([[NSArray array] __first], @"Returns nil for empty array");
}

- (void)testLast
{
    STAssertNil([[NSArray array] __last], @"Returns nil for empty array");
}

- (void)testHead
{
    NSArray *five  = [NSArray __from:0 to:5];
    NSArray *range = [[NSArray __from:0 to:9] __head:5];

    STAssertEqualObjects(five, range, @"Could extract the first 5 elements");
}

- (void)testTail
{
    NSArray *five  = [NSArray __from:4 to:9];
    NSArray *range = [[NSArray __from:0 to:9] __tail:5];

    STAssertEqualObjects(five, range, @"Could extract the last 5 elements");
}

- (void)testFlatten
{
    NSArray *ten = [NSArray __from:0 to:10];

    NSArray *complicated = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],
                                                     [NSArray  __from:1 to:4],
                                                     [NSNumber numberWithInteger:4],
                                                     [NSArray  arrayWithObject:[NSArray __from:5 to:9]],
                                                     [NSNumber numberWithInteger:9],
                                                     nil];

    STAssertEqualObjects(ten, [complicated __flatten], @"Could flatten the array");
}

- (void)testWithout
{
    NSArray *ten  = [NSArray __from:0 to:10];
    NSArray *even = [NSArray __from:0 to:10 step:2];
    NSArray *odd  = [NSArray __from:1 to:10 step:2];

    STAssertEqualObjects(even, [ten __without:odd], @"Could remove odd elements");
}

- (void)testShuffle
{
    NSArray *hundred  = [NSArray __from:0 to:100];
    NSArray *shuffled = [hundred __shuffle];

    STAssertFalse([hundred isEqualToArray:shuffled], @"Could shuffle the array");
}

- (void)testEach
{
    NSArray *ten = [NSArray __from:0 to:10];
    NSInteger __block current = 0;

    [ten __each:^(NSNumber *number) {
        STAssertTrue(current++ == [number integerValue], nil);
    }];

    STAssertTrue(current == 10, @"Could run 10 tests");
}

- (void)testMap
{
    NSArray *odd  = [NSArray __from:1 to:10 step:2];
    NSArray *even = [odd __map:^(NSNumber *number) {
        return [NSNumber numberWithInteger:number.integerValue + 1];
    }];

    STAssertEqualObjects(even, [NSArray __from:2 to:11 step:2], @"Could apply +1");
}

- (void)testFind
{
    NSArray  *names = [NSArray arrayWithObjects:@"Ullrich", @"Gernot", @"Toto", nil];
    NSString *result = [names __find:^BOOL(NSString *name) {
        return name.length == 4;
    }];

    STAssertEqualObjects(result, @"Toto", @"Could find Toto");
}

- (void)testFilter
{
    NSArray *ten  = [NSArray __from:0 to:10];
    NSArray *even = [NSArray __from:0 to:10 step:2];

    UnderscoreArrayTestBlock isEven = ^BOOL(NSNumber *number) {
        return number.integerValue % 2 == 0;
    };

    STAssertEqualObjects(even, [ten __filter:isEven], @"Could filter even numbers");
}

- (void)testReject
{
    NSArray *ten = [NSArray __from:0 to:10];
    NSArray *odd = [NSArray __from:1 to:11 step:2];

    UnderscoreArrayTestBlock isEven = ^BOOL(NSNumber *number) {
        return number.integerValue % 2 == 0;
    };

    STAssertEqualObjects(odd, [ten __reject:isEven], @"Could reject even numbers");
}

- (void)testAll
{
    NSArray *even = [NSArray __from:0 to:10 step:2];
    NSArray *odd  = [NSArray __from:1 to:10 step:2];

    UnderscoreArrayTestBlock isEven = ^BOOL(NSNumber *number) {
        return number.integerValue % 2 == 0;
    };

    STAssertTrue([even __all:isEven], @"All elements passed");
    STAssertFalse([odd __all:isEven], @"No element passed");
}

- (void)testAny
{
    NSArray *ten = [NSArray __from:0 to:10];

    UnderscoreArrayTestBlock isEight = ^BOOL(NSNumber *number) {
        return number.integerValue == 8;
    };

    STAssertTrue([ten __any:isEight], @"At least one elements passed");
}

@end
