//
//  USAsyncArrayTest.m
//  Underscore
//
//  Created by Robert Böhnke on 8/21/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USAsyncArrayTest.h"

#import "Underscore.h"

static NSArray *emptyArray;
static NSArray *singleObject;
static NSArray *threeObjects;

static NSOperationQueue *backgroundQueue;

#define _ Underscore

@implementation USAsyncArrayTest

- (void)setUp;
{
    emptyArray   = [NSArray array];
    singleObject = [NSArray arrayWithObject:@"foo"];
    threeObjects = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];

    backgroundQueue = [[NSOperationQueue alloc] init];
}

- (void)testAsyncUnwrap;
{
    _.array(singleObject)
        .on(NSOperationQueue.mainQueue)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array, singleObject, @"Can unwrap arrays");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testSwitchingQueues;
{
    _.array(singleObject)
        .on(backgroundQueue)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(NSOperationQueue.currentQueue,
                                 backgroundQueue,
                                 @"Can switch queues");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncHead;
{
    _.array(threeObjects)
        .on(NSOperationQueue.mainQueue)
        .head(1)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array, (@[ @"foo" ]), @"Can perform head asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncTail;
{
    _.array(threeObjects)
        .on(NSOperationQueue.mainQueue)
        .tail(1)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array, (@[ @"baz" ]), @"Can perform head asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

@end
