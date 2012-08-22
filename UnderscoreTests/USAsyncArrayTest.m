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

static UnderscoreReduceBlock const concatenate = ^NSString *(NSString *a, NSString *b) {
    return [a stringByAppendingString:b];
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

            STAssertEquals(counter, 1u, @"Executes on different queues");

            counter++;

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];

    STAssertEquals(counter, 2u, @"Executes on different queues");
}

- (void)testAsyncFirst;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .first(^(NSString *first) {
            STAssertEqualObjects(first, @"foo", @"Can perform first asynchronously");

            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncLast;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .last(^(NSString *last) {
            STAssertEqualObjects(last, @"baz", @"Can perform last asynchronously");

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
        .on(backgroundQueue)
        .indexOf(@"bar", ^(NSUInteger index) {
            STAssertEquals(index, 1u, @"Can perform indexOf asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncIndexOf;
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

- (void)testAsyncFlatten;
{
    NSArray *arrayOfArrays = @[
        @[ @1, @2, @3 ], @4, @[ @5, @[ @6 ] ], @[ @7 ]
    ];

    _.array(arrayOfArrays)
        .on(backgroundQueue)
        .flatten
        .unwrap(^void (NSArray *array) {
            STAssertEqualObjects(array,
                                 (@[ @1, @2, @3, @4, @5, @6, @7 ]),
                                 @"Can perform flatten asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncWithout;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .without(singleObject)
        .unwrap(^void (NSArray *array) {
            STAssertEqualObjects(array,
                                 (@[ @"bar", @"baz" ]),
                                 @"Can perform without asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncShuffle;
{
    NSMutableArray *numbers = [NSMutableArray array];
    for (NSUInteger i = 1; i < 100; i++) {
        [numbers addObject:@(i)];
    }

    _.array(numbers)
        .on(backgroundQueue)
        .shuffle
        .unwrap(^void (NSArray *array) {
            STAssertFalse([array isEqualToArray:numbers],
                          @"Can perform shuffle asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncReduce;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .reduce(@"the ", concatenate, ^(NSString *result) {
            STAssertEqualObjects(result,
                                 @"the foobarbaz",
                                 @"Can perform reduce asynchronously");
            [self notify:SenAsyncTestCaseStatusSucceeded];
        });

    [self waitForTimeout:1];
}

- (void)testAsyncReduceRight;
{
    _.array(threeObjects)
        .on(backgroundQueue)
        .reduceRight(@"the ", concatenate, ^(NSString *result) {
            STAssertEqualObjects(result,
                                 @"the bazbarfoo",
                                 @"Can perform reduceRight asynchronously");
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
            STAssertEquals(counter, 3u, @"Can perform each asynchronously");
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
