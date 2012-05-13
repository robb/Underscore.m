//
//  NSDictionary+UnderscoreTest.m
//  Underscore
//
//  Created by Robert Böhnke on 5/3/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

#import "NSDictionary+UnderscoreTest.h"

@implementation NSDictionary_UnderscoreTest

- (void)testPrune;
{
    NSDictionary *withNull = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:1], @"id",
                                                                        @"robb", @"username",
                                                                        [NSNull null], @"clue",
                                                                        nil];

    NSDictionary *pruned = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:1], @"id",
                                                                      @"robb", @"username",
                                                                      nil];

    STAssertEqualObjects([withNull __prune], pruned, @"Could remove NSNulls", nil);
}

- (void)testReduce;
{
    NSDictionary *example = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"bar",
                                                                       @"baz", @"qux",
                                                                       nil];

    NSString *result = [example __reduce:^id(id memo, id key, id obj) {
        return [memo stringByAppendingString:obj];
    }
                             intialValue:@""];

    STAssertEqualObjects(result, @"foobaz", @"Could concatenate values");
}

- (void)testEach;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"ale",  @"a",
                                                                          @"beer", @"b",
                                                                          @"coke", @"c",
                                                                          nil];

    __block NSUInteger current = 0;

    __block BOOL checkedA = NO, checkedB = NO, checkedC = NO;

    [dictionary __each:^(id key, id obj) {
        if ([key isEqualToString:@"a"]) {
            STAssertFalse(checkedA, @"Did not check a before");
            STAssertEqualObjects(obj, @"ale", nil);
            current++;

            checkedA = YES;
        }

        if ([key isEqualToString:@"b"]) {
            STAssertFalse(checkedB, @"Did not check b before");
            STAssertEqualObjects(obj, @"beer", nil);
            current++;

            checkedB = YES;
        }

        if ([key isEqualToString:@"c"]) {
            STAssertFalse(checkedC, @"Did not check c before");
            STAssertEqualObjects(obj, @"coke", nil);
            current++;

            checkedC = YES;
        }
    }];

    STAssertTrue(current == 3, @"Could run 3 tests");
}

- (void)testMap;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"ale",  @"a",
                                                                          @"beer", @"b",
                                                                          @"coke", @"c",
                                                                          nil];

    NSDictionary *capitalized = [NSDictionary dictionaryWithObjectsAndKeys:@"ALE",  @"a",
                                                                           @"BEER", @"b",
                                                                           @"COKE", @"c",
                                                                           nil];

    NSDictionary *result = [dictionary __map:^id(id key, id obj) {
        return [obj uppercaseString];
    }];

    STAssertEqualObjects(result, capitalized, @"Could convert to uppercase");
}

- (void)testFind;
{
    NSDictionary *ramones = [NSDictionary dictionaryWithObjectsAndKeys:@"Tommy",   @"drums",
                                                                       @"Dee Dee", @"bass",
                                                                       @"Johnny",  @"guitar",
                                                                       @"Joey",    @"vocals",
                                                                       nil];

    NSString *result = [ramones __find:^BOOL(id key, id obj) {
        return [obj isEqualToString:@"Joey"];
    }];

    STAssertEqualObjects(result, @"vocals", @"Could look up key");
}

- (void)testFilter;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:1], @"a",
                                                                          [NSNumber numberWithUnsignedInteger:2], @"b",
                                                                          [NSNumber numberWithUnsignedInteger:3], @"c",
                                                                          [NSNumber numberWithUnsignedInteger:4], @"d",
                                                                          nil];

    NSDictionary *even = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:2], @"b",
                                                                    [NSNumber numberWithUnsignedInteger:4], @"d",
                                                                    nil];

    NSDictionary *result = [dictionary __filter:^BOOL(NSString *key, NSNumber *number) {
        return number.integerValue % 2 == 0;
    }];

    STAssertEqualObjects(result, even, @"Could filter even numbers");
}

- (void)testReject;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:1], @"a",
                                                                          [NSNumber numberWithUnsignedInteger:2], @"b",
                                                                          [NSNumber numberWithUnsignedInteger:3], @"c",
                                                                          [NSNumber numberWithUnsignedInteger:4], @"d",
                                                                          nil];

    NSDictionary *odd = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:1], @"a",
                                                                   [NSNumber numberWithUnsignedInteger:3], @"c",
                                                                   nil];

    NSDictionary *result = [dictionary __reject:^BOOL(NSString *key, NSNumber *number) {
        return number.integerValue % 2 == 0;
    }];

    STAssertEqualObjects(result, odd, @"Could reject even numbers");
}

@end
