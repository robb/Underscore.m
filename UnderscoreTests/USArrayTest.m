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

#define _ Underscore

@implementation USArrayTest

- (void)setUp;
{
    emptyArray   = [NSArray array];
    singleObject = [NSArray arrayWithObject:@"foo"];
    threeObjects = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
}

- (void)testFirst;
{
    STAssertNil(_.first(emptyArray), @"Returns nil for empty array");

    STAssertEqualObjects(_.first(singleObject),
                         @"foo",
                         @"Can extract only object");

    STAssertEqualObjects(_.first(threeObjects),
                         @"foo",
                         @"Can extract first object");
}

- (void)testLast;
{
    STAssertNil(_.last(emptyArray), @"Returns nil for empty array");

    STAssertEqualObjects(_.last(singleObject),
                         @"foo",
                         @"Can extract only object");

    STAssertEqualObjects(_.last(threeObjects),
                         @"baz",
                         @"Can extract last object");
}

- (void)testHead;
{
    STAssertEqualObjects(_.head(emptyArray, 1),
                         emptyArray,
                         @"Returns an empty array for an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"foo", @"bar", nil];
    STAssertEqualObjects(_.head(threeObjects, 2),
                         subrange,
                         @"Returns multiple elements if available");

    STAssertEqualObjects(_.head(threeObjects, 4),
                         threeObjects,
                         @"Does not return more elements than available");
}

- (void)testTail;
{
    STAssertEqualObjects(_.tail(emptyArray, 1),
                         emptyArray,
                         @"Returns an empty array for an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    STAssertEqualObjects(_.tail(threeObjects, 2),
                         subrange,
                         @"Returns multiple elements if available");

    STAssertEqualObjects(_.tail(threeObjects, 4),
                         threeObjects,
                         @"Does not return more elements than available");
}

- (void)testFlatten;
{
    STAssertEqualObjects(_.flatten(emptyArray),
                         emptyArray,
                         @"Returns an empty array for an empty array");

    STAssertEqualObjects(_.flatten(threeObjects),
                         threeObjects,
                         @"Returns a copy for arrays not containing other arrays");

    NSArray *complicated = [NSArray arrayWithObjects:@"foo", threeObjects, nil];
    NSArray *flattened   = [NSArray arrayWithObjects:@"foo", @"foo", @"bar", @"baz", nil];
    STAssertEqualObjects(_.flatten(complicated),
                         flattened,
                         @"Returns a flattened array when needed");
}

- (void)testWithout;
{
    STAssertEqualObjects(_.without(threeObjects, emptyArray),
                         threeObjects,
                         @"Empty arrays have no effect");

    STAssertEqualObjects(_.without(threeObjects, threeObjects),
                         emptyArray,
                         @"Removing the same array returns an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    STAssertEqualObjects(_.without(threeObjects, singleObject),
                         subrange,
                         @"Removing one object returns the rest");
}

- (void)testShuffle;
{
    STAssertEqualObjects(_.shuffle(emptyArray),
                         emptyArray,
                         @"Shuffling an empty array results in an empty array");

    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 1; i < 100; i++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:i]];
    }

     STAssertFalse([_.shuffle(array) isEqualToArray:array],
                  @"Can shuffle an array");
}

- (void)testReduce;
{
    NSString *result1 = _.reduce(emptyArray, @"test", ^id (id memo, id any){
        return nil;
    });

    STAssertEqualObjects(result1,
                         @"test",
                         @"Reducing an empty array yields the input value");

    NSString *result2 = _.reduce(threeObjects, @"the ", ^id (NSString *memo, NSString *current) {
            return [memo stringByAppendingString:current];
        });

    STAssertEqualObjects(result2,
                         @"the foobarbaz",
                         @"Objects are reduced in the correct order");
}

- (void)testReduceRight;
{
    NSString *result1 = _.reduceRight(emptyArray, @"test", ^id (id memo, id any){
        return nil;
    });

    STAssertEqualObjects(result1,
                         @"test",
                         @"Reducing an empty array yields the input value");

    NSString *result2 = _.reduceRight(threeObjects, @"the ", ^id (NSString *memo, NSString *current) {
        return [memo stringByAppendingString:current];
    });

    STAssertEqualObjects(result2,
                         @"the bazbarfoo",
                         @"Objects are reduced in the correct order");
}

- (void)testEach;
{
    __block NSInteger testRun = 0;
    __block BOOL checkedFoo = NO, checkedBar = NO, checkedBaz = NO;

    _.array(threeObjects).each(^(NSString *string) {
        if ([string isEqualToString:@"foo"]) {
            STAssertFalse(checkedFoo, @"Did not check foo before");
            testRun++;

            checkedFoo = YES;
        }

        if ([string isEqualToString:@"bar"]) {
            STAssertFalse(checkedBar, @"Did not check bar before");
            testRun++;

            checkedBar = YES;
        }

        if ([string isEqualToString:@"baz"]) {
            STAssertFalse(checkedBaz, @"Did not check baz before");
            testRun++;

            checkedBaz = YES;
        }
    });

    STAssertEquals(testRun, 3, @"Ran 3 tests");
}

- (void)testMap;
{
    STAssertEqualObjects(_.array(emptyArray).map(^id (id any){return @"test";}).unwrap,
                         emptyArray,
                         @"Can handle empty arrays");

    STAssertEqualObjects(_.array(threeObjects).map(^id (id any){return nil;}).unwrap,
                         emptyArray,
                         @"Returning nil in the map block removes the object pair");

    NSArray *capitalized = [NSArray arrayWithObjects:@"Foo", @"Bar", @"Baz", nil];
    NSArray *result      = _.array(threeObjects)
        .map(^NSString *(NSString *string) {
            return [string capitalizedString];
        })
        .unwrap;

    STAssertEqualObjects(capitalized,
                         result,
                         @"Can map objects");
}

- (void)testPluck;
{
    STAssertEqualObjects(_.pluck(emptyArray, @"description"),
                         emptyArray,
                         @"Can handle empty arrays");

    NSArray *lengths = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
                                                 [NSNumber numberWithInt:3],
                                                 [NSNumber numberWithInt:3],
                                                 nil];

    STAssertEqualObjects(_.pluck(threeObjects, @"length"),
                         lengths,
                         @"Can extract values for the key path");
}

- (void)testFind;
{
    STAssertNil(_.find(emptyArray, ^BOOL(id any){return YES;}),
                @"Can handle empty arrays");

    STAssertNil(_.find(threeObjects, ^BOOL(id any){return NO;}),
                @"Returns nil if no object matches");

    NSString *result = _.find(threeObjects, ^BOOL(NSString *string){
        return [string characterAtIndex:2] == 'z';
    });

    STAssertEqualObjects(result,
                         @"baz",
                         @"Can find objects");
}

- (void)testFilter;
{
    STAssertEqualObjects(_.filter(emptyArray, ^BOOL(id any){return YES;}),
                         emptyArray,
                         @"Can handle empty arrays");

    STAssertEqualObjects(_.filter(threeObjects, ^BOOL(id any){return NO;}),
                         emptyArray,
                         @"Can remove all objects");

    STAssertEqualObjects(_.filter(threeObjects, ^BOOL(id any){return YES;}),
                         threeObjects,
                         @"Can keep all objects");

    NSArray *result = _.filter(threeObjects, ^BOOL (NSString *string) {
        return [string characterAtIndex:0] == 'b';
    });

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    STAssertEqualObjects(result,
                         subrange,
                         @"Can remove matching elements");
}

- (void)testReject;
{
    STAssertEqualObjects(_.reject(emptyArray, ^BOOL(id any){return YES;}),
                         emptyArray,
                         @"Can handle empty arrays");

    STAssertEqualObjects(_.reject(threeObjects, ^BOOL(id any){return NO;}),
                         threeObjects,
                         @"Can remove all objects");

    STAssertEqualObjects(_.reject(threeObjects, ^BOOL(id any){return YES;}),
                         emptyArray,
                         @"Can keep all objects");

    NSArray *result = _.reject(threeObjects, ^BOOL (NSString *string) {
        return [string characterAtIndex:0] == 'b';
    });

    STAssertEqualObjects(result,
                         singleObject,
                         @"Can remove matching elements");
}

- (void)testAll;
{
    STAssertFalse(_.all(emptyArray, _.isNull),
                  @"Empty array never passes");

    UnderscoreTestBlock isString = ^BOOL (id obj){
        return [obj isKindOfClass:[NSString class]];
    };

    STAssertTrue(_.all(threeObjects, isString),
                 @"All elements pass");

    UnderscoreTestBlock startsWithB = ^BOOL (NSString *string){
        return [string characterAtIndex:0] == 'b';
    };

    STAssertFalse(_.all(threeObjects, startsWithB),
                  @"Not all elements pass");

    UnderscoreTestBlock isNumber = ^BOOL (id obj){
        return [obj isKindOfClass:[NSNumber class]];
    };

    STAssertFalse(_.all(threeObjects, isNumber),
                  @"No element passes");
}

- (void)testAny;
{
    STAssertFalse(_.any(emptyArray, _.isNull),
                  @"Empty array never passes");

    STAssertTrue(_.any(threeObjects, _.isString),
                 @"All elements pass");

    UnderscoreTestBlock startsWithB = ^BOOL (NSString *string){
        return [string characterAtIndex:0] == 'b';
    };

    STAssertTrue(_.any(threeObjects, startsWithB),
                 @"One element passes");

    STAssertFalse(_.any(threeObjects, _.isNumber),
                  @"No element passes");
}

@end
