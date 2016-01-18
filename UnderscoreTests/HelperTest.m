//
//  HelperTest.m
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "HelperTest.h"

#import "Underscore.h"

@implementation HelperTest

- (void)testNegate
{
    UnderscoreTestBlock yesBlock = ^BOOL (id obj) { return YES; };
    XCTAssertFalse(Underscore.negate(yesBlock)(nil), @"Can negate block");
    UnderscoreTestBlock noBlock = ^BOOL (id obj) { return NO; };
    XCTAssertTrue(Underscore.negate(noBlock)(nil), @"Can negate block");
}

- (void)testIsEqual
{
    XCTAssertTrue(Underscore.isEqual(@"foo")(@"foo"), @"Performs equality check");
    XCTAssertFalse(Underscore.isEqual(@"foo")(@"bar"), @"Performs equality check");
}

- (void)testIsArray
{
    XCTAssertTrue(Underscore.isArray([NSArray array]), @"Returns true for NSArray");
    XCTAssertFalse(Underscore.isArray([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsBool
{
    XCTAssertTrue(Underscore.isBool([NSNumber numberWithBool:YES]), @"Returns true for NSNumber with BOOL: YES");
    XCTAssertTrue(Underscore.isBool([NSNumber numberWithBool:NO]),  @"Returns true for NSNumber with BOOL: NO");
    XCTAssertFalse(Underscore.isBool([NSNumber numberWithInteger:42]), @"Returns false for NSNumber");
    XCTAssertFalse(Underscore.isBool([[NSObject alloc] init]),         @"Returns false for NSObject");
    XCTAssertFalse(Underscore.isBool([NSNumber numberWithInt:1]), @"Returns false for NSNumber with int: 1, as its type is int, not BOOL");
    XCTAssertFalse(Underscore.isBool([NSNumber numberWithInt:0]), @"Returns false for NSNumber with int: 0, as its type is int, not BOOL");
}

- (void)testIsDictionary
{
    XCTAssertTrue(Underscore.isDictionary([NSDictionary dictionary]), @"Returns true for NSDictionary");
    XCTAssertFalse(Underscore.isDictionary([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsNull
{
    XCTAssertTrue(Underscore.isNull([NSNull null]), @"Returns true for NSNull");
    XCTAssertFalse(Underscore.isNull([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsNumber
{
    XCTAssertTrue(Underscore.isNumber([NSNumber numberWithInteger:12]), @"Returns true for NSNumber");
    XCTAssertFalse(Underscore.isNumber([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsString
{
    XCTAssertTrue(Underscore.isString(@"hooray!"), @"Returns true for NSString");
    XCTAssertFalse(Underscore.isString([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testCompare
{
    XCTAssertEqual(Underscore.compare(@"a", @"b"), NSOrderedAscending,  @"Can compare correctly");
    XCTAssertEqual(Underscore.compare(@"a", @"a"), NSOrderedSame,       @"Can compare correctly");
    XCTAssertEqual(Underscore.compare(@"b", @"a"), NSOrderedDescending, @"Can compare correctly");
    XCTAssertThrows(Underscore.compare(@{}, @{}),
                   @"Comparing objects that don't respond to compare: throws an exception");
}

- (void)testIsEmpty
{
    XCTAssertTrue(Underscore.isEmpty(@""), @"Returns true for empty strings");
    XCTAssertTrue(Underscore.isEmpty(@[]), @"Returns true for empty arrays");
    XCTAssertTrue(Underscore.isEmpty(@{}), @"Returns true for empty dictionaries");
    XCTAssertFalse(Underscore.isEmpty(@"1"), @"Returns false for non-empty strings");
    XCTAssertFalse(Underscore.isEmpty(@[ @2 ]), @"Returns false for non-empty arrays");
    XCTAssertFalse(Underscore.isEmpty(@{ @3: @4 }), @"Returns false for non-empty dictionaries");
}

@end
