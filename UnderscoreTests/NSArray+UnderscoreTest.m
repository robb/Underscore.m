//
//  NSArray+UnderscoreTest.m
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "NSArray+UnderscoreTest.h"

#import "NSArray+Underscore.h"

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
    NSArray *range = [NSArray __from:0 to:8 step:2];
    
    NSArray *expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],
                                                  [NSNumber numberWithInteger:2],
                                                  [NSNumber numberWithInteger:4],
                                                  [NSNumber numberWithInteger:6],
                                                  nil];
    
    STAssertEqualObjects(expected, range, @"Could generate asending range");
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


@end
