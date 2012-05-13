//
//  USArrayTest.m
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USArrayTest.h"

#import "USArray.h"

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

@end
