//
//  USArrayTest.m
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USArrayTest.h"

#import "USArray.h"

@implementation USArrayTest

- (void)testFirst;
{
    NSArray *emptyArray = [NSArray array];
    STAssertNil(_array(emptyArray).first(), @"Returns nil for empty array");

    NSArray *singleObject = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
    STAssertEqualObjects(_array(singleObject).first(),
                         [NSNumber numberWithInt:1],
                         @"Can extract only object");

    NSArray *multipleObjects = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
                                                         [NSNumber numberWithInt:3],
                                                         nil];
    STAssertEqualObjects(_array(multipleObjects).first(),
                         [NSNumber numberWithInt:2],
                         @"Can extract first object");
}

- (void)testLast;
{
    NSArray *emptyArray = [NSArray array];
    STAssertNil(_array(emptyArray).last(), @"Returns nil for empty array");

    NSArray *singleObject = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
    STAssertEqualObjects(_array(singleObject).last(),
                         [NSNumber numberWithInt:1],
                         @"Can extract only object");

    NSArray *multipleObjects = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:3],
                                nil];
    STAssertEqualObjects(_array(multipleObjects).last(),
                         [NSNumber numberWithInt:3],
                         @"Can extract last object");
}

@end
