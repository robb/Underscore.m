//
//  USArrayTest.m
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USArrayTest.h"

#import "Underscore.h"

static NSArray *emptyArray;
static NSArray *singleObject;
static NSArray *threeObjects;

@implementation USArrayTest

- (void)setUp;
{
    emptyArray   = [NSArray array];
    singleObject = [NSArray arrayWithObject:@"foo"];
    threeObjects = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
}

- (void)testFirst;
{
    STAssertNil(_array(emptyArray).first(), @"Returns nil for empty array");

    STAssertEqualObjects(_array(singleObject).first(),
                         @"foo",
                         @"Can extract only object");

    STAssertEqualObjects(_array(threeObjects).first(),
                         @"foo",
                         @"Can extract first object");
}

- (void)testLast;
{
    STAssertNil(_array(emptyArray).last(), @"Returns nil for empty array");

    STAssertEqualObjects(_array(singleObject).last(),
                         @"foo",
                         @"Can extract only object");

    STAssertEqualObjects(_array(threeObjects).last(),
                         @"baz",
                         @"Can extract last object");
}

- (void)testHead;
{
    STAssertEqualObjects(_array(emptyArray).head(1).unwrap,
                         emptyArray,
                         @"Returns an empty array for an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"foo", @"bar", nil];
    STAssertEqualObjects(_array(threeObjects).head(2).unwrap,
                         subrange,
                         @"Returns multiple elements if available");

    STAssertEqualObjects(_array(threeObjects).head(4).unwrap,
                         threeObjects,
                         @"Does not return more elements than available");
}

- (void)testTail;
{
    STAssertEqualObjects(_array(emptyArray).tail(1).unwrap,
                         emptyArray,
                         @"Returns an empty array for an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    STAssertEqualObjects(_array(threeObjects).tail(2).unwrap,
                         subrange,
                         @"Returns multiple elements if available");

    STAssertEqualObjects(_array(threeObjects).tail(4).unwrap,
                         threeObjects,
                         @"Does not return more elements than available");
}

- (void)testFlatten;
{
    STAssertEqualObjects(_array(emptyArray).flatten().unwrap,
                         emptyArray,
                         @"Returns an empty array for an empty array");

    STAssertEqualObjects(_array(threeObjects).flatten().unwrap,
                         threeObjects,
                         @"Returns a copy for arrays not containing other arrays");

    NSArray *complicated = [NSArray arrayWithObjects:@"foo", threeObjects, nil];
    NSArray *flattened   = [NSArray arrayWithObjects:@"foo", @"foo", @"bar", @"baz", nil];
    STAssertEqualObjects(_array(complicated).flatten().unwrap,
                         flattened,
                         @"Returns a flattened array when needed");
}

@end
