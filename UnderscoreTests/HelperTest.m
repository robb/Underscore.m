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
    UnderscoreTestBlock yesBlock = ^BOOL (id obj) {
        return YES;
    };

    STAssertFalse(Underscore.negate(yesBlock)(nil), @"Can negate block");

    UnderscoreTestBlock noBlock = ^BOOL (id obj) {
        return NO;
    };

    STAssertTrue(Underscore.negate(noBlock)(nil), @"Can negate block");
}

- (void)testIsEqual
{
    STAssertTrue(Underscore.isEqual(@"foo")(@"foo"), @"Performs equality check");
    STAssertFalse(Underscore.isEqual(@"foo")(@"bar"), @"Performs equality check");
}

- (void)testIsArray
{
    STAssertTrue(Underscore.isArray([NSArray array]), @"Returns true for NSArray");

    STAssertFalse(Underscore.isArray([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsDictionary
{
    STAssertTrue(Underscore.isDictionary([NSDictionary dictionary]), @"Returns true for NSDictionary");

    STAssertFalse(Underscore.isDictionary([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsNull
{
    STAssertTrue(Underscore.isNull([NSNull null]), @"Returns true for NSNull");

    STAssertFalse(Underscore.isNull([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsNumber
{
    STAssertTrue(Underscore.isNumber([NSNumber numberWithInteger:12]), @"Returns true for NSNumber");

    STAssertFalse(Underscore.isNumber([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testIsString
{
    STAssertTrue(Underscore.isString(@"hooray!"), @"Returns true for NSString");

    STAssertFalse(Underscore.isString([[NSObject alloc] init]), @"Returns false for NSObject");
}

- (void)testCompare
{
    STAssertEquals(Underscore.compare(@"a", @"b"), NSOrderedAscending,  @"Can compare correctly");
    STAssertEquals(Underscore.compare(@"a", @"a"), NSOrderedSame,       @"Can compare correctly");
    STAssertEquals(Underscore.compare(@"b", @"a"), NSOrderedDescending, @"Can compare correctly");

    STAssertThrows(Underscore.compare(@{}, @{}),
                   @"Comparing objects that don't respond to compare: throws an exception");
}

- (void)testIsEmpty
{
    STAssertTrue(Underscore.isEmpty(@""), @"Returns true for empty strings");
    STAssertTrue(Underscore.isEmpty(@[]), @"Returns true for empty arrays");
    STAssertTrue(Underscore.isEmpty(@{}), @"Returns true for empty dictionaries");

    STAssertFalse(Underscore.isEmpty(@"1"), @"Returns false for non-empty strings");
    STAssertFalse(Underscore.isEmpty(@[ @2 ]), @"Returns false for non-empty arrays");
    STAssertFalse(Underscore.isEmpty(@{ @3: @4 }), @"Returns false for non-empty dictionaries");
}

@end
