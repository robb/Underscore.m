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

static UnderscoreTestBlock allPass  = ^BOOL(id any) {return YES; };
static UnderscoreTestBlock nonePass = ^BOOL(id any) {return NO; };

#define _ Underscore

#define USAssertEqualObjects(functional, wrapper) \
        XCTAssertEqualObjects (functional, wrapper, @"Wrapper and Shortcut behave equally");

#define USAssertEqualPrimitives(functional, wrapper) \
        XCTAssertTrue(functional == wrapper, @"Wrapper and Shortcut behave equally");

@implementation USArrayTest

- (void)setUp
{
    emptyArray   = [NSArray array];
    singleObject = [NSArray arrayWithObject:@"foo"];
    threeObjects = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
}

- (void)testFirst
{
    XCTAssertNil(_.first(emptyArray), @"Returns nil for empty array");

    XCTAssertEqualObjects(_.first(singleObject),
                         @"foo",
                         @"Can extract only object");

    XCTAssertEqualObjects(_.first(threeObjects),
                         @"foo",
                         @"Can extract first object");

    USAssertEqualObjects(_.first(emptyArray),   _.array(emptyArray).first);
    USAssertEqualObjects(_.first(singleObject), _.array(singleObject).first);
    USAssertEqualObjects(_.first(threeObjects), _.array(threeObjects).first);
}

- (void)testLast
{
    XCTAssertNil(_.last(emptyArray), @"Returns nil for empty array");

    XCTAssertEqualObjects(_.last(singleObject),
                         @"foo",
                         @"Can extract only object");

    XCTAssertEqualObjects(_.last(threeObjects),
                         @"baz",
                         @"Can extract last object");

    USAssertEqualObjects(_.last(emptyArray),   _.array(emptyArray).last);
    USAssertEqualObjects(_.last(singleObject), _.array(singleObject).last);
    USAssertEqualObjects(_.last(threeObjects), _.array(threeObjects).last);
}

- (void)testHead
{
    XCTAssertEqualObjects(_.head(emptyArray, 1),
                         emptyArray,
                         @"Returns an empty array for an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"foo", @"bar", nil];
    XCTAssertEqualObjects(_.head(threeObjects, 2),
                         subrange,
                         @"Returns multiple elements if available");

    XCTAssertEqualObjects(_.head(threeObjects, 4),
                         threeObjects,
                         @"Does not return more elements than available");

    USAssertEqualObjects(_.head(emptyArray, 1),   _.array(emptyArray).head(1).unwrap);
    USAssertEqualObjects(_.head(threeObjects, 2), _.array(threeObjects).head(2).unwrap);
    USAssertEqualObjects(_.head(threeObjects, 4), _.array(threeObjects).head(4).unwrap);
}

- (void)testTail
{
    XCTAssertEqualObjects(_.tail(emptyArray, 1),
                         emptyArray,
                         @"Returns an empty array for an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    XCTAssertEqualObjects(_.tail(threeObjects, 2),
                         subrange,
                         @"Returns multiple elements if available");

    XCTAssertEqualObjects(_.tail(threeObjects, 4),
                         threeObjects,
                         @"Does not return more elements than available");

    USAssertEqualObjects(_.tail(emptyArray, 1),   _.array(emptyArray).tail(1).unwrap);
    USAssertEqualObjects(_.tail(threeObjects, 2), _.array(threeObjects).tail(2).unwrap);
    USAssertEqualObjects(_.tail(threeObjects, 4), _.array(threeObjects).tail(4).unwrap);
}

- (void)testDrop
{
    XCTAssertEqualObjects(_.drop(emptyArray, 1),
                         emptyArray,
                         @"Returns an empty array for an empty array");
  
    NSArray *subrange = [NSArray arrayWithObjects:@"baz", nil];
    XCTAssertEqualObjects(_.drop(threeObjects, 2),
                         subrange,
                         @"Correctly drops multiple objects");
  
    XCTAssertEqualObjects(_.drop(threeObjects, 4),
                         emptyArray,
                         @"Returns an empty array when dropping more objects than the target array has");
  
    USAssertEqualObjects(_.drop(emptyArray, 1),   _.array(emptyArray).drop(1).unwrap);
    USAssertEqualObjects(_.drop(threeObjects, 2), _.array(threeObjects).drop(2).unwrap);
    USAssertEqualObjects(_.drop(threeObjects, 4), _.array(threeObjects).drop(4).unwrap);
}

- (void)testIndexOf
{
    XCTAssertTrue(_.indexOf(emptyArray, @1) == NSNotFound,
                 @"Returns NSNotFound when searching in an empty array");

    XCTAssertTrue(_.indexOf(threeObjects, @1) == NSNotFound,
                 @"Returns NSNotFound when the element cannot be found");

    XCTAssertTrue(_.indexOf(threeObjects, @"foo") == 0,
                 @"Returns the index of the element");

    NSArray *arrayWithDuplicates = @[ @"foo", @"bar", @"baz", @"bar" ];
    XCTAssertTrue(_.indexOf(arrayWithDuplicates, @"bar") == 1,
                 @"Returns the index of the first occurrence");
}

- (void)testFlatten
{
    XCTAssertEqualObjects(_.flatten(emptyArray),
                         emptyArray,
                         @"Returns an empty array for an empty array");

    XCTAssertEqualObjects(_.flatten(threeObjects),
                         threeObjects,
                         @"Returns a copy for arrays not containing other arrays");

    NSArray *complicated = [NSArray arrayWithObjects:@"foo", threeObjects, nil];
    NSArray *flattened   = [NSArray arrayWithObjects:@"foo", @"foo", @"bar", @"baz", nil];
    XCTAssertEqualObjects(_.flatten(complicated),
                         flattened,
                         @"Returns a flattened array when needed");

    USAssertEqualObjects(_.flatten(emptyArray),
                         _.array(emptyArray).flatten.unwrap);
    USAssertEqualObjects(_.flatten(threeObjects),
                         _.array(threeObjects).flatten.unwrap);
    USAssertEqualObjects(_.flatten(complicated),
                         _.array(complicated).flatten.unwrap);
}

- (void)testWithout
{
    XCTAssertEqualObjects(_.without(threeObjects, emptyArray),
                         threeObjects,
                         @"Empty arrays have no effect");

    XCTAssertEqualObjects(_.without(threeObjects, threeObjects),
                         emptyArray,
                         @"Removing the same array returns an empty array");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];
    XCTAssertEqualObjects(_.without(threeObjects, singleObject),
                         subrange,
                         @"Removing one object returns the rest");

    USAssertEqualObjects(_.without(threeObjects, emptyArray),
                         _.array(threeObjects).without(emptyArray).unwrap);
    USAssertEqualObjects(_.without(threeObjects, threeObjects),
                         _.array(threeObjects).without(threeObjects).unwrap);
    USAssertEqualObjects(_.without(threeObjects, singleObject),
                         _.array(threeObjects).without(singleObject).unwrap);
}

- (void)testShuffle
{
    XCTAssertEqualObjects(_.shuffle(emptyArray),
                         emptyArray,
                         @"Shuffling an empty array results in an empty array");

    USAssertEqualObjects(_.shuffle(emptyArray), _.array(emptyArray).shuffle.unwrap);

    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 1; i < 100; i++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:i]];
    }

     XCTAssertFalse([_.shuffle(array) isEqualToArray:array],
                  @"Can shuffle an array");

     XCTAssertFalse([_.array(emptyArray).shuffle.unwrap isEqualToArray:array],
                  @"Can shuffle an array");
}

- (void)testReduce
{
    UnderscoreReduceBlock block1 = ^id (id memo, id any) {
        return nil;
    };

    UnderscoreReduceBlock block2 = ^id (NSString *memo, NSString *current) {
        return [memo stringByAppendingString:current];
    };

    XCTAssertEqualObjects(_.reduce(emptyArray, @"test", block1),
                         @"test",
                         @"Reducing an empty array yields the input value");

    XCTAssertEqualObjects(_.reduce(threeObjects, @"the ", block2),
                         @"the foobarbaz",
                         @"Objects are reduced in the correct order");

    USAssertEqualObjects(_.reduce(emptyArray, @"test", block1),
                         _.array(emptyArray).reduce(@"test", block1));
    USAssertEqualObjects(_.reduce(threeObjects, @"the ", block2),
                         _.array(threeObjects).reduce(@"the ", block2));
}

- (void)testReduceRight
{
    UnderscoreReduceBlock block1 = ^id (id memo, id any) {
        return nil;
    };

    UnderscoreReduceBlock block2 = ^id (NSString *memo, NSString *current) {
        return [memo stringByAppendingString:current];
    };

    XCTAssertEqualObjects(_.reduceRight(emptyArray, @"test", block1),
                         @"test",
                         @"Reducing an empty array yields the input value");

    XCTAssertEqualObjects(_.reduceRight(threeObjects, @"the ", block2),
                         @"the bazbarfoo",
                         @"Objects are reduced in the correct order");

    USAssertEqualObjects(_.reduceRight(emptyArray, @"test", block1),
                         _.array(emptyArray).reduceRight(@"test", block1));
    USAssertEqualObjects(_.reduceRight(threeObjects, @"the ", block2),
                         _.array(threeObjects).reduceRight(@"the ", block2));
}

- (void)testEachFunctional
{
    __block NSInteger testRun = 0;
    __block BOOL checkedFoo = NO, checkedBar = NO, checkedBaz = NO;

    _.arrayEach(threeObjects, ^(NSString *string) {
        if ([string isEqualToString:@"foo"]) {
            XCTAssertFalse(checkedFoo, @"Did not check foo before");
            testRun++;

            checkedFoo = YES;
        }

        if ([string isEqualToString:@"bar"]) {
            XCTAssertFalse(checkedBar, @"Did not check bar before");
            testRun++;

            checkedBar = YES;
        }

        if ([string isEqualToString:@"baz"]) {
            XCTAssertFalse(checkedBaz, @"Did not check baz before");
            testRun++;

            checkedBaz = YES;
        }
    });

    XCTAssertEqual(testRun, 3, @"Ran 3 tests");
}

- (void)testEachWrapping
{
    __block NSInteger testRun = 0;
    __block BOOL checkedFoo = NO, checkedBar = NO, checkedBaz = NO;

    _.array(threeObjects).each(^(NSString *string) {
        if ([string isEqualToString:@"foo"]) {
            XCTAssertFalse(checkedFoo, @"Did not check foo before");
            testRun++;

            checkedFoo = YES;
        }

        if ([string isEqualToString:@"bar"]) {
            XCTAssertFalse(checkedBar, @"Did not check bar before");
            testRun++;

            checkedBar = YES;
        }

        if ([string isEqualToString:@"baz"]) {
            XCTAssertFalse(checkedBaz, @"Did not check baz before");
            testRun++;

            checkedBaz = YES;
        }
    });

    XCTAssertEqual(testRun, 3, @"Ran 3 tests");
}

- (void)testMap
{
    UnderscoreArrayMapBlock returnTest = ^id (id any){ return @"test"; };
    UnderscoreArrayMapBlock returnNil  = ^id (id any){ return nil; };
    UnderscoreArrayMapBlock capitalize = ^NSString *(NSString *string) {
        return [string capitalizedString];
    };

    XCTAssertEqualObjects(_.arrayMap(emptyArray, returnTest),
                         emptyArray,
                         @"Can handle empty arrays");

    XCTAssertEqualObjects(_.arrayMap(threeObjects, returnNil),
                         emptyArray,
                         @"Returning nil in the map block removes the object pair");

    NSArray *capitalized = [NSArray arrayWithObjects:@"Foo", @"Bar", @"Baz", nil];
    NSArray *result      = _.arrayMap(threeObjects, capitalize);

    XCTAssertEqualObjects(capitalized,
                         result,
                         @"Can map objects");

    USAssertEqualObjects(_.arrayMap(emptyArray, returnTest),
                         _.array(emptyArray).map(returnTest).unwrap);
    USAssertEqualObjects(_.arrayMap(threeObjects, returnNil),
                         _.array(threeObjects).map(returnNil).unwrap);
    USAssertEqualObjects(_.arrayMap(threeObjects, capitalize),
                         _.array(threeObjects).map(capitalize).unwrap);
}

- (void)testIndexedMap
{
    UnderscoreIndexedArrayMapBlock returnTest = ^id (id any, NSUInteger idx) {
        return [NSString stringWithFormat:@"%ld %@", idx, @"test"];
    };
    UnderscoreIndexedArrayMapBlock returnNil  = ^id (id any, NSUInteger idx) {
        return nil;
    };
    UnderscoreIndexedArrayMapBlock capitalize = ^NSString *(NSString *string, NSUInteger idx) {
        return [NSString stringWithFormat:@"%ld %@", idx, [string capitalizedString]];
    };

    XCTAssertEqualObjects(_.arrayIndexedMap(emptyArray, returnTest),
                         emptyArray,
                         @"Can handle empty arrays");

    XCTAssertEqualObjects(_.arrayIndexedMap(threeObjects, returnNil),
                         emptyArray,
                         @"Returning nil in the map block removes the object pair");

    NSArray *capitalized = [NSArray arrayWithObjects:@"0 Foo", @"1 Bar", @"2 Baz", nil];
    NSArray *result      = _.arrayIndexedMap(threeObjects, capitalize);

    XCTAssertEqualObjects(capitalized,
                         result,
                         @"Can map objects");

    USAssertEqualObjects(_.arrayIndexedMap(emptyArray, returnTest),
                         _.array(emptyArray).indexedMap(returnTest).unwrap);
    USAssertEqualObjects(_.arrayIndexedMap(threeObjects, returnNil),
                         _.array(threeObjects).indexedMap(returnNil).unwrap);
    USAssertEqualObjects(_.arrayIndexedMap(threeObjects, capitalize),
                         _.array(threeObjects).indexedMap(capitalize).unwrap);
}

- (void)testZipWith
{
    UnderscoreArrayZipWithBlock addNumbers = ^id (NSNumber *one, NSNumber *two) {
        return @(one.intValue + two.intValue);
    };
    UnderscoreArrayZipWithBlock multiplyStrings = ^id (NSString *string, NSNumber *times) {
        return [@"" stringByPaddingToLength:times.intValue * string.length withString:string startingAtIndex:0];
    };
    UnderscoreArrayZipWithBlock addStrings = ^id (NSString *one, NSString *two) {
        return [one stringByAppendingString:two];
    };
  
    XCTAssertEqualObjects(_.arrayZipWith(emptyArray, emptyArray, addNumbers),
                         emptyArray,
                         @"Can handle empty arrays");
    XCTAssertEqualObjects(_.arrayZipWith(emptyArray, threeObjects, addStrings),
                         emptyArray,
                         @"Can handle empty arrays");
    XCTAssertEqualObjects(_.arrayZipWith(threeObjects, emptyArray, addStrings),
                         emptyArray,
                         @"Can handle empty arrays");
    NSArray *appendedStrings = @[ @"foofoo" ];
    XCTAssertEqualObjects(_.arrayZipWith(singleObject, threeObjects, addStrings),
                         appendedStrings,
                         @"Works when array sizes mis-match.");
    XCTAssertEqualObjects(_.arrayZipWith(threeObjects, singleObject, addStrings),
                         appendedStrings,
                         @"Works when array sizes mis-match.");
    NSArray *numbers = @[ @(1), @(2), @(3) ];
    NSArray *expected = @[ @(2), @(4), @(6) ];
    XCTAssertEqualObjects(_.arrayZipWith(numbers, numbers, addNumbers),
                         expected,
                         @"Correctly zips two arrays.");
  
    NSArray *expectedStrings = @[ @"foo", @"barbar", @"bazbazbaz" ];
    XCTAssertEqualObjects(_.arrayZipWith(threeObjects, numbers, multiplyStrings),
                         expectedStrings,
                         @"Correctly zips two arrays of diferent types.");
  
    USAssertEqualObjects(_.arrayZipWith(emptyArray, emptyArray, addNumbers),
                         _.array(emptyArray).zipWith(emptyArray, addNumbers).unwrap);
    USAssertEqualObjects(_.arrayZipWith(emptyArray, threeObjects, addStrings),
                         _.array(emptyArray).zipWith(threeObjects, addStrings).unwrap);
    USAssertEqualObjects(_.arrayZipWith(threeObjects, emptyArray, addStrings),
                         _.array(threeObjects).zipWith(emptyArray, addStrings).unwrap);
    USAssertEqualObjects(_.arrayZipWith(singleObject, threeObjects, addStrings),
                         _.array(singleObject).zipWith(threeObjects, addStrings).unwrap);
    USAssertEqualObjects(_.arrayZipWith(threeObjects, singleObject, addStrings),
                         _.array(threeObjects).zipWith(singleObject, addStrings).unwrap);
    USAssertEqualObjects(_.arrayZipWith(singleObject, threeObjects, addNumbers),
                         _.array(singleObject).zipWith(threeObjects, addNumbers).unwrap);
    USAssertEqualObjects(_.arrayZipWith(threeObjects, singleObject, addNumbers),
                         _.array(threeObjects).zipWith(singleObject, addNumbers).unwrap);
    USAssertEqualObjects(_.arrayZipWith(numbers, numbers, addNumbers),
                         _.array(numbers).zipWith(numbers, addNumbers).unwrap);
    USAssertEqualObjects(_.arrayZipWith(threeObjects, numbers, multiplyStrings),
                         _.array(threeObjects).zipWith(numbers, multiplyStrings).unwrap);
}

- (void)testPluck
{
    XCTAssertEqualObjects(_.pluck(emptyArray, @"description"),
                         emptyArray,
                         @"Can handle empty arrays");

    NSArray *lengths = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
                                                 [NSNumber numberWithInt:3],
                                                 [NSNumber numberWithInt:3],
                                                 nil];

    XCTAssertEqualObjects(_.pluck(threeObjects, @"length"),
                         lengths,
                         @"Can extract values for the key path");

    USAssertEqualObjects(_.pluck(emptyArray, @"description"),
                          _.array(emptyArray).pluck(@"description").unwrap);
    USAssertEqualObjects(_.pluck(threeObjects, @"length"),
                          _.array(threeObjects).pluck(@"length").unwrap);
}


- (void)testUniq
{
    XCTAssertEqualObjects(_.uniq(emptyArray),
                         emptyArray,
                         @"Can handle empty arrays");

    NSArray *sameObjects = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
                                                     [NSNumber numberWithInt:3],
                                                     [NSNumber numberWithInt:3],
                                                     nil];

    XCTAssertEqual(_.uniq(threeObjects).count,
                   (NSUInteger)3,
                   @"Can extract 3 unique values");

    XCTAssertEqual(_.uniq(sameObjects).count,
                   (NSUInteger)1,
                   @"Can extract 1 unique value");

    NSArray *ordered = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                                 [NSNumber numberWithInt:2],
                                                 [NSNumber numberWithInt:2],
                                                 [NSNumber numberWithInt:3],
                                                 [NSNumber numberWithInt:3],
                                                 [NSNumber numberWithInt:4],
                                                 nil];

    NSArray *oneToFour = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                                   [NSNumber numberWithInt:2],
                                                   [NSNumber numberWithInt:3],
                                                   [NSNumber numberWithInt:4],
                                                   nil];

    XCTAssertEqualObjects(_.uniq(ordered),
                         oneToFour,
                         @"Preserves order");

    USAssertEqualObjects(_.uniq(emptyArray),
                         _.array(emptyArray).uniq.unwrap);

    USAssertEqualObjects(_.uniq(threeObjects),
                         _.array(threeObjects).uniq.unwrap);
    USAssertEqualObjects(_.uniq(sameObjects),
                         _.array(sameObjects).uniq.unwrap);
}


- (void)testFind
{
    UnderscoreTestBlock endsOnZ  = ^BOOL(NSString *string) {
        return [string characterAtIndex:2] == 'z';
    };

    XCTAssertNil(_.find(emptyArray, allPass),
                @"Can handle empty arrays");

    XCTAssertNil(_.find(threeObjects, nonePass),
                @"Returns nil if no object matches");

    XCTAssertEqualObjects(_.find(threeObjects, endsOnZ),
                         @"baz",
                         @"Can find objects");

    USAssertEqualObjects(_.find(emptyArray, allPass),
                         _.array(emptyArray).find(allPass));
    USAssertEqualObjects(_.find(threeObjects, nonePass),
                         _.array(threeObjects).find(nonePass));
    USAssertEqualObjects(_.find(threeObjects, endsOnZ),
                         _.array(threeObjects).find(endsOnZ));
}

- (void)testFilter
{
    UnderscoreTestBlock startsWithB = ^BOOL(NSString *string) {
        return [string characterAtIndex:0] == 'b';
    };

    XCTAssertEqualObjects(_.filter(emptyArray, allPass),
                         emptyArray,
                         @"Can handle empty arrays");

    XCTAssertEqualObjects(_.filter(threeObjects, nonePass),
                         emptyArray,
                         @"Can remove all objects");

    XCTAssertEqualObjects(_.filter(threeObjects, allPass),
                         threeObjects,
                         @"Can keep all objects");

    NSArray *subrange = [NSArray arrayWithObjects:@"bar", @"baz", nil];

    XCTAssertEqualObjects(_.filter(threeObjects, startsWithB),
                         subrange,
                         @"Can remove matching elements");

    USAssertEqualObjects(_.filter(emptyArray, allPass),
                         _.array(emptyArray).filter(allPass).unwrap);
    USAssertEqualObjects(_.filter(threeObjects, nonePass),
                         _.array(threeObjects).filter(nonePass).unwrap);
    USAssertEqualObjects(_.filter(threeObjects, allPass),
                         _.array(threeObjects).filter(allPass).unwrap);
    USAssertEqualObjects(_.filter(threeObjects, startsWithB),
                         _.array(threeObjects).filter(startsWithB).unwrap);
}

- (void)testReject
{
    UnderscoreTestBlock startsWithB = ^BOOL(NSString *string) {
        return [string characterAtIndex:0] == 'b';
    };

    XCTAssertEqualObjects(_.reject(emptyArray, allPass),
                         emptyArray,
                         @"Can handle empty arrays");

    XCTAssertEqualObjects(_.reject(threeObjects, nonePass),
                         threeObjects,
                         @"Can remove all objects");

    XCTAssertEqualObjects(_.reject(threeObjects, allPass),
                         emptyArray,
                         @"Can keep all objects");

    XCTAssertEqualObjects(_.reject(threeObjects, startsWithB),
                         singleObject,
                         @"Can remove matching elements");

    USAssertEqualObjects(_.reject(emptyArray, allPass),
                         _.array(emptyArray).reject(allPass).unwrap);
    USAssertEqualObjects(_.reject(threeObjects, nonePass),
                         _.array(threeObjects).reject(nonePass).unwrap);
    USAssertEqualObjects(_.reject(threeObjects, allPass),
                         _.array(threeObjects).reject(allPass).unwrap);
    USAssertEqualObjects(_.reject(threeObjects, startsWithB),
                         _.array(threeObjects).reject(startsWithB).unwrap);
}

- (void)testAll
{
    XCTAssertFalse(_.all(emptyArray, _.isNull),
                  @"Empty array never passes");

    XCTAssertTrue(_.all(threeObjects, _.isString),
                 @"All elements pass");

    UnderscoreTestBlock startsWithB = ^BOOL (NSString *string){
        return [string characterAtIndex:0] == 'b';
    };

    XCTAssertFalse(_.all(threeObjects, startsWithB),
                  @"Not all elements pass");

    XCTAssertFalse(_.all(threeObjects, _.isNumber),
                  @"No element passes");

    USAssertEqualPrimitives(_.all(emptyArray, _.isNull),
                            _.array(emptyArray).all(_.isNull));
    USAssertEqualPrimitives(_.all(threeObjects, _.isString),
                            _.array(threeObjects).all(_.isString));
    USAssertEqualPrimitives(_.all(threeObjects, startsWithB),
                            _.array(threeObjects).all(startsWithB));
    USAssertEqualPrimitives(_.all(threeObjects, _.isNumber),
                            _.array(threeObjects).all(_.isNumber));
}

- (void)testAny
{
    XCTAssertFalse(_.any(emptyArray, _.isNull),
                  @"Empty array never passes");

    XCTAssertTrue(_.any(threeObjects, _.isString),
                 @"All elements pass");

    UnderscoreTestBlock startsWithB = ^BOOL (NSString *string){
        return [string characterAtIndex:0] == 'b';
    };

    XCTAssertTrue(_.any(threeObjects, startsWithB),
                 @"One element passes");

    XCTAssertFalse(_.any(threeObjects, _.isNumber),
                  @"No element passes");

    USAssertEqualPrimitives(_.any(emptyArray, _.isNull),
                            _.array(emptyArray).any(_.isNull));
    USAssertEqualPrimitives(_.any(threeObjects, _.isString),
                            _.array(threeObjects).any(_.isString));
    USAssertEqualPrimitives(_.any(threeObjects, startsWithB),
                            _.array(threeObjects).any(startsWithB));
    USAssertEqualPrimitives(_.any(threeObjects, _.isNumber),
                            _.array(threeObjects).any(_.isNumber));
}

- (void)testSort
{
    NSArray *notSorted = @[ @3, @1, @2 ];
    NSArray *sorted    = @[ @1, @2, @3 ];

    UnderscoreSortBlock numericalSort = ^(NSNumber *a, NSNumber *b) {
        return [a compare:b];
    };

    XCTAssertEqualObjects(_.sort(notSorted, numericalSort),
                         sorted,
                         @"Can sort elements");

    USAssertEqualObjects(_.sort(notSorted, numericalSort),
                         _.array(notSorted).sort(numericalSort).unwrap);
}

- (void)testGroupBy
{
    NSArray *numbers = @[ @1.3, @2.1, @2.4 ];
    NSDictionary *grouped = @{ @1 : @[ @1.3 ], @2 : @[ @2.1, @2.4 ] };
    
    UnderscoreGroupingBlock intGroup = ^id <NSCopying> (NSNumber *number) {
        return @((int)floor(number.doubleValue));
    };

    XCTAssertEqualObjects(_.groupBy(numbers, intGroup),
                         grouped,
                         @"Can group elements");
    
    USAssertEqualObjects(_.groupBy(numbers, intGroup),
                         _.array(numbers).groupBy(intGroup).unwrap);
}

@end
