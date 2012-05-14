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

- (void)testEach;
{
    __block NSUInteger zero = 0;

    _dict(emptyDictionary).each(^(id key, id obj) {
        zero++;
    });

    STAssertTrue(zero == 0, @"An empty dictionary never triggers the block");

    __block NSUInteger runs = 0;
    __block BOOL checked1 = NO, checked2 = NO, checked3 = NO;

    _dict(simpleDictionary).each(^(NSString *key, NSString *obj) {
        if ([key isEqualToString:@"key1"]) {
            STAssertEqualObjects(obj, @"object1", @"Calls the block with the correct value");
            STAssertFalse(checked1, @"Calls the block only once");

            checked1 = YES;
        }

        if ([key isEqualToString:@"key2"]) {
            STAssertEqualObjects(obj, @"object2", @"Calls the block with the correct value");
            STAssertFalse(checked2, @"Calls the block only once");

            checked2 = YES;
        }

        if ([key isEqualToString:@"key3"]) {
            STAssertEqualObjects(obj, @"object3", @"Calls the block with the correct value");
            STAssertFalse(checked3, @"Calls the block only once");

            checked3 = YES;
        }

        runs++;
    });

    STAssertTrue(runs == 3, @"Triggers the block once for each key-value-pair");
}

- (void)testMap;
{
    __block NSUInteger zero = 0;

    _dict(emptyDictionary).map(^(id key, id obj) {
        zero++;
        return obj;
    });

    STAssertTrue(zero == 0, @"An empty dictionary never triggers the block");

    NSDictionary *result = _dict(simpleDictionary)
        .map(^(NSString *key, NSString *obj) {
            return [obj capitalizedString];
        })
        .unwrap;

    NSDictionary *capitalized = [NSDictionary dictionaryWithObjectsAndKeys:@"Object1", @"key1",
                                                                           @"Object2", @"key2",
                                                                           @"Object3", @"key3",
                                                                           nil];

    STAssertEqualObjects(result,
                         capitalized,
                         @"Can map objects");
}

- (void)testPick;
{
    STAssertEqualObjects(_dict(emptyDictionary).pick(threeObjects).unwrap,
                         emptyDictionary,
                         @"Picking from empty dictionary results in empty dictionary");

    STAssertEqualObjects(_dict(simpleDictionary).pick(emptyArray).unwrap,
                         emptyDictionary,
                         @"Picking with empty array results in empty dictionary");

    STAssertEqualObjects(_dict(simpleDictionary).pick(threeObjects).unwrap,
                         emptyDictionary,
                         @"Picking with array that not contains common keys results in empty dictionary");

    STAssertEqualObjects(_dict(simpleDictionary).pick([NSArray arrayWithObject:@"key1"]).unwrap,
                         [NSDictionary dictionaryWithObject:@"object1" forKey:@"key1"],
                         @"Can pick keys");
}

- (void)testExtend;
{
    STAssertEqualObjects(_dict(emptyDictionary).extend(emptyDictionary).unwrap,
                         emptyDictionary,
                         @"Extending empty dictionary with empty dictionary results in empty dictionary");

    STAssertEqualObjects(_dict(emptyDictionary).extend(simpleDictionary).unwrap,
                         simpleDictionary,
                         @"Extending empty dictionary with non-empty dictionary copies over all key-values pairs");

    STAssertEqualObjects(_dict(simpleDictionary).extend(emptyDictionary).unwrap,
                         simpleDictionary,
                         @"Extending non-empty dictionary with empty dictionary leaves all key-values pairs unchanged");

    NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"object1",    @"key1",
                                                                           [NSNull null], @"key2",
                                                                           nil];

    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"object2", @"key2",
                                                                           @"object3", @"key3",
                                                                           nil];

    STAssertEqualObjects(_dict(dictionary1).extend(dictionary2).unwrap,
                         simpleDictionary,
                         @"Extending non-empty dictionary with non-empty dictionary overwrites keys where necessary");
}

- (void)testDefaults;
{
    STAssertEqualObjects(_dict(emptyDictionary).defaults(emptyDictionary).unwrap,
                         emptyDictionary,
                         @"Applying defaults from an empty dictionary to an empty dictionary results in an empty dictionary");

    STAssertEqualObjects(_dict(emptyDictionary).defaults(simpleDictionary).unwrap,
                         simpleDictionary,
                         @"Applying defaults from a non-empty dictionary to an empty dictionary copies over all key-values pairs");

    STAssertEqualObjects(_dict(simpleDictionary).defaults(emptyDictionary).unwrap,
                         simpleDictionary,
                         @"Applying defaults from an empty dictionary to a non-empty dictionary copies over all key-values pairs");

    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"key3",
                                                                        @"object4",    @"key4",
                                                                        nil];

    NSDictionary *fourKeys = [NSDictionary dictionaryWithObjectsAndKeys:@"object1", @"key1",
                                                                        @"object2", @"key2",
                                                                        @"object3", @"key3",
                                                                        @"object4", @"key4",
                                                                        nil];

    STAssertEqualObjects(_dict(simpleDictionary).defaults(defaults).unwrap,
                         fourKeys,
                         @"Applying defaults from a non-empty dictionary to a non-empty dictionary copies over all key-values pairs not existant in the latter");
}

@end
