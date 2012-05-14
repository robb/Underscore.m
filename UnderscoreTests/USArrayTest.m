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
    STAssertNil(_array(emptyArray).first, @"Returns nil for empty array");

    STAssertEqualObjects(_array(singleObject).first,
                         @"foo",
                         @"Can extract only object");

    STAssertEqualObjects(_array(threeObjects).first,
                         @"foo",
                         @"Can extract first object");
}

- (void)testLast;
{
    STAssertNil(_array(emptyArray).last, @"Returns nil for empty array");

    STAssertEqualObjects(_array(singleObject).last,
                         @"foo",
                         @"Can extract only object");

    STAssertEqualObjects(_array(threeObjects).last,
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
    STAssertEqualObjects(_array(emptyArray).flatten.unwrap,
                         emptyArray,
                         @"Returns an empty array for an empty array");

    STAssertEqualObjects(_array(threeObjects).flatten.unwrap,
                         threeObjects,
                         @"Returns a copy for arrays not containing other arrays");

    NSArray *complicated = [NSArray arrayWithObjects:@"foo", threeObjects, nil];
    NSArray *flattened   = [NSArray arrayWithObjects:@"foo", @"foo", @"bar", @"baz", nil];
    STAssertEqualObjects(_array(complicated).flatten.unwrap,
                         flattened,
                         @"Returns a flattened array when needed");
}

- (void)testWithout;
{
    STAssertEqualObjects(_array(threeObjects).without(emptyArray).unwrap,
                         threeObjects,
                         @"Empty arrays have no effect");

    STAssertEqualObjects(_array(threeObjects).without(threeObjects).unwrap,
                         emptyArray,
                         @"Removing the same array returns an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    STAssertEqualObjects(_array(threeObjects).without(singleObject).unwrap,
                         subrange,
                         @"Removing one object returns the rest");
}

- (void)testShuffle;
{
    STAssertEqualObjects(_array(emptyArray).shuffle.unwrap,
                         emptyArray,
                         @"Shuffling an empty array results in an empty array");

    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 1; i < 100; i++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:i]];
    }

     STAssertFalse([_array(array).shuffle.unwrap isEqualToArray:array],
                  @"Can shuffle an array");
}

- (void)testReduce;
{
    NSString *result1 = _array(emptyArray).reduce(@"test", ^id (id memo, id any){
        return nil;
    });

    STAssertEqualObjects(result1,
                         @"test",
                         @"Reducing an empty array yields the input value");

    NSString *result2 = _array(threeObjects)
        .reduce(@"the ", ^id (NSString *memo, NSString *current) {
            return [memo stringByAppendingString:current];
        });

    STAssertEqualObjects(result2,
                         @"the foobarbaz",
                         @"Objects are reduced in the correct order");
}

- (void)testReduceRight;
{
    NSString *result1 = _array(emptyArray).reduceRight(@"test", ^id (id memo, id any){
        return nil;
    });

    STAssertEqualObjects(result1,
                         @"test",
                         @"Reducing an empty array yields the input value");

    NSString *result2 = _array(threeObjects)
        .reduceRight(@"the ", ^id (NSString *memo, NSString *current) {
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

    _array(threeObjects).each(^(NSString *string) {
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
    STAssertEqualObjects(_array(emptyArray).map(^id (id any){return @"test";}).unwrap,
                         emptyArray,
                         @"Can handle empty arrays");

    NSArray *capitalized = [NSArray arrayWithObjects:@"Foo", @"Bar", @"Baz", nil];
    NSArray *result      = _array(threeObjects)
        .map(^NSString *(NSString *string) {
            return [string capitalizedString];
        })
        .unwrap;

    STAssertEqualObjects(capitalized,
                         result,
                         @"Can map objects");
}

- (void)testFind;
{
    STAssertNil(_array(emptyArray).find(^BOOL(id any){return YES;}),
                @"Can handle empty arrays");

    STAssertNil(_array(threeObjects).find(^BOOL(id any){return NO;}),
                @"Returns nil if no object matches");

    NSString *result = _array(threeObjects).find(^BOOL(NSString *string){
        return [string characterAtIndex:2] == 'z';
    });

    STAssertEqualObjects(result,
                         @"baz",
                         @"Can find objects");
}

- (void)testFilter;
{
    STAssertEqualObjects(_array(emptyArray).filter(^BOOL(id any){return YES;}).unwrap,
                         emptyArray,
                         @"Can handle empty arrays");

    STAssertEqualObjects(_array(threeObjects).filter(^BOOL(id any){return NO;}).unwrap,
                         emptyArray,
                         @"Can remove all objects");

    STAssertEqualObjects(_array(threeObjects).filter(^BOOL(id any){return YES;}).unwrap,
                         threeObjects,
                         @"Can keep all objects");

    NSArray *result = _array(threeObjects)
        .filter(^BOOL (NSString *string) {
            return [string characterAtIndex:0] == 'b';
        })
        .unwrap;

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    STAssertEqualObjects(result,
                         subrange,
                         @"Can remove matching elements");
}

- (void)testReject;
{
    STAssertEqualObjects(_array(emptyArray).reject(^BOOL(id any){return YES;}).unwrap,
                         emptyArray,
                         @"Can handle empty arrays");

    STAssertEqualObjects(_array(threeObjects).reject(^BOOL(id any){return NO;}).unwrap,
                         threeObjects,
                         @"Can remove all objects");

    STAssertEqualObjects(_array(threeObjects).reject(^BOOL(id any){return YES;}).unwrap,
                         emptyArray,
                         @"Can keep all objects");

    NSArray *result = _array(threeObjects)
        .reject(^BOOL (NSString *string) {
            return [string characterAtIndex:0] == 'b';
        })
        .unwrap;

    STAssertEqualObjects(result,
                         singleObject,
                         @"Can remove matching elements");
}

- (void)testAll;
{
    STAssertTrue(_array(emptyArray).all(^BOOL (id any){return NO;}),
                 @"Empty array always passes");

    UnderscoreTestBlock isString = ^BOOL (id obj){
        return [obj isKindOfClass:[NSString class]];
    };

    STAssertTrue(_array(threeObjects).all(isString),
                 @"All elements pass");

    UnderscoreTestBlock startsWithB = ^BOOL (NSString *string){
        return [string characterAtIndex:0] == 'b';
    };

    STAssertFalse(_array(threeObjects).all(startsWithB),
                  @"Not all elements pass");

    UnderscoreTestBlock isNumber = ^BOOL (id obj){
        return [obj isKindOfClass:[NSNumber class]];
    };

    STAssertFalse(_array(threeObjects).all(isNumber),
                 @"No element passes");
}

- (void)testAny;
{
    STAssertTrue(_array(emptyArray).any(^BOOL (id any){return NO;}),
                 @"Empty array always passes");

    UnderscoreTestBlock isString = ^BOOL (id obj){
        return [obj isKindOfClass:[NSString class]];
    };

    STAssertTrue(_array(threeObjects).any(isString),
                 @"All elements pass");

    UnderscoreTestBlock startsWithB = ^BOOL (NSString *string){
        return [string characterAtIndex:0] == 'b';
    };

    STAssertTrue(_array(threeObjects).any(startsWithB),
                 @"One element passes");

    UnderscoreTestBlock isNumber = ^BOOL (id obj){
        return [obj isKindOfClass:[NSNumber class]];
    };

    STAssertFalse(_array(threeObjects).any(isNumber),
                  @"No element passes");
}

@end
