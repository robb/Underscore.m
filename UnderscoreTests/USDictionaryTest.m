//
//  USDictionaryTest.m
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USDictionaryTest.h"

#import "Underscore.h"

static NSArray *emptyArray;
static NSArray *singleObject;
static NSArray *threeObjects;

static NSDictionary *emptyDictionary;
static NSDictionary *simpleDictionary;

@implementation USDictionaryTest

- (void)setUp;
{
    emptyArray   = [NSArray array];
    singleObject = [NSArray arrayWithObject:@"foo"];
    threeObjects = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];

    emptyDictionary  = [NSDictionary dictionary];
    simpleDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"object1", @"key1",
                                                                  @"object2", @"key2",
                                                                  @"object3", @"key3",
                                                                  nil];
}

- (void)testKeys;
{
    STAssertEqualObjects(_dict(emptyDictionary).keys.unwrap,
                         emptyArray,
                         @"An empty dictionary returns an empty keys array");

    NSArray *result = _dict(simpleDictionary).keys.unwrap;

    STAssertTrue([result containsObject:@"key1"], @"Can extract key 'key1'");
    STAssertTrue([result containsObject:@"key2"], @"Can extract key 'key2'");
    STAssertTrue([result containsObject:@"key3"], @"Can extract key 'key3'");
}

- (void)testValues;
{
    STAssertEqualObjects(_dict(emptyDictionary).values.unwrap,
                         emptyArray,
                         @"An empty dictionary returns an empty values array");

    NSArray *result = _dict(simpleDictionary).values.unwrap;

    STAssertTrue([result containsObject:@"object1"], @"Can extract object 'object1'");
    STAssertTrue([result containsObject:@"object2"], @"Can extract object 'object2'");
    STAssertTrue([result containsObject:@"object3"], @"Can extract object 'object3'");
}

@end
