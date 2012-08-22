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

static UnderscoreTestBlock const startsWithF = ^BOOL (NSString *string) {
    return [string characterAtIndex:0] == 'f';
};

#define _ Underscore

@implementation USAsyncArrayTest

- (void)setUp;
{
    emptyArray   = [NSArray array];
    singleObject = [NSArray arrayWithObject:@"foo"];
    threeObjects = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];

    backgroundQueue = [[NSOperationQueue alloc] init];
    backgroundQueue.name = @"Background Queue";
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
    __block NSUInteger counter = 0;

    _.array(singleObject)
        .on(backgroundQueue)
        .each(^(id obj) {
            STAssertEqualObjects(NSOperationQueue.currentQueue,
                                 backgroundQueue,
                                 @"Can switch queues");

            counter++;
        })
        .on(NSOperationQueue.mainQueue)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(NSOperationQueue.currentQueue,
                                 NSOperationQueue.mainQueue,
                                 @"Can switch queues");

            STAssertTrue(counter == 1, @"Executes on different queues");

            counter++;

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];

    STAssertTrue(counter == 2, @"Executes on different queues");
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

- (void)testAsyncEach;
{
    __block NSUInteger counter = 0;

    _.array(threeObjects)
        .on(NSOperationQueue.mainQueue)
        .each(^(NSString *string) {
            counter++;
        })
        .unwrap(^(NSArray *array) {
            STAssertTrue(counter == 3, @"Can perform each asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncMap;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .map(^NSString *(NSString *string) {
            return string.capitalizedString;
        })
        .on(NSOperationQueue.mainQueue)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array,
                                 (@[ @"Foo", @"Bar", @"Baz" ]),
                                 @"Can perform map asynchronously");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncPluck;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .pluck(@"length")
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array,
                                 (@[ @3, @3, @3]),
                                 @"Can perform pluck asynchronously");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncFind;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .find(startsWithF, ^(NSString *result) {
            STAssertEqualObjects(result,
                                 @"foo",
                                 @"Can perform find asynchronously");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncFilter;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .filter(startsWithF)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array,
                                 (@[@"foo"]),
                                 @"Can perform filter asynchronously");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncReject;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .reject(startsWithF)
        .unwrap(^(NSArray *array) {
            STAssertEqualObjects(array,
                                 (@[ @"bar", @"baz" ]),
                                 @"Can perform reject asynchronously");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncAll;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .all(_.isString, ^(BOOL result) {
            STAssertTrue(result, @"Can perform all asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncAny;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .any(_.isEqual(@"baz"), ^(BOOL result) {
            STAssertTrue(result, @"Can perform any asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

@end
