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

#define _ Underscore

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
    STAssertEqualObjects(_.keys(emptyDictionary),
                         emptyArray,
                         @"An empty dictionary returns an empty keys array");

    NSArray *result = _.keys(simpleDictionary);

    STAssertTrue([result containsObject:@"key1"], @"Can extract key 'key1'");
    STAssertTrue([result containsObject:@"key2"], @"Can extract key 'key2'");
    STAssertTrue([result containsObject:@"key3"], @"Can extract key 'key3'");
}

- (void)testValues;
{
    STAssertEqualObjects(_.values(emptyDictionary),
                         emptyArray,
                         @"An empty dictionary returns an empty values array");

    NSArray *result = _.values(simpleDictionary);

    STAssertTrue([result containsObject:@"object1"], @"Can extract object 'object1'");
    STAssertTrue([result containsObject:@"object2"], @"Can extract object 'object2'");
    STAssertTrue([result containsObject:@"object3"], @"Can extract object 'object3'");
}

- (void)testEach;
{
    __block NSUInteger zero = 0;

    _.dict(emptyDictionary).each(^(id key, id obj) {
        zero++;
    });

    STAssertTrue(zero == 0, @"An empty dictionary never triggers the block");

    __block NSUInteger runs = 0;
    __block BOOL checked1 = NO, checked2 = NO, checked3 = NO;

    _.dict(simpleDictionary).each(^(NSString *key, NSString *obj) {
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

    _.dict(emptyDictionary).map(^(id key, id obj) {
        zero++;
        return obj;
    });

    STAssertTrue(zero == 0, @"An empty dictionary never triggers the block");

    STAssertEqualObjects(_.dict(simpleDictionary).map(^id (id key, id obj) {return nil;}).unwrap,
                         emptyDictionary,
                         @"Returning nil in the map block removes the key value pair");

    NSDictionary *result = _.dict(simpleDictionary)
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
    STAssertEqualObjects(_.pick(emptyDictionary, threeObjects),
                         emptyDictionary,
                         @"Picking from empty dictionary results in empty dictionary");

    STAssertEqualObjects(_.pick(simpleDictionary, emptyArray),
                         emptyDictionary,
                         @"Picking with empty array results in empty dictionary");

    STAssertEqualObjects(_.pick(simpleDictionary, threeObjects),
                         emptyDictionary,
                         @"Picking with array that not contains common keys results in empty dictionary");

    STAssertEqualObjects(_.pick(simpleDictionary, [NSArray arrayWithObject:@"key1"]),
                         [NSDictionary dictionaryWithObject:@"object1" forKey:@"key1"],
                         @"Can pick keys");
}

- (void)testExtend;
{
    STAssertEqualObjects(_.extend(emptyDictionary, emptyDictionary),
                         emptyDictionary,
                         @"Extending empty dictionary with empty dictionary results in empty dictionary");

    STAssertEqualObjects(_.extend(emptyDictionary, simpleDictionary),
                         simpleDictionary,
                         @"Extending empty dictionary with non-empty dictionary copies over all key-values pairs");

    STAssertEqualObjects(_.extend(simpleDictionary, emptyDictionary),
                         simpleDictionary,
                         @"Extending non-empty dictionary with empty dictionary leaves all key-values pairs unchanged");

    NSDictionary *dictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:@"object1",    @"key1",
                                                                           [NSNull null], @"key2",
                                                                           nil];

    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:@"object2", @"key2",
                                                                           @"object3", @"key3",
                                                                           nil];

    STAssertEqualObjects(_.extend(dictionary1, dictionary2),
                         simpleDictionary,
                         @"Extending non-empty dictionary with non-empty dictionary overwrites keys where necessary");
}

- (void)testDefaults;
{
    STAssertEqualObjects(_.defaults(emptyDictionary, emptyDictionary),
                         emptyDictionary,
                         @"Applying defaults from an empty dictionary to an empty dictionary results in an empty dictionary");

    STAssertEqualObjects(_.defaults(emptyDictionary, simpleDictionary),
                         simpleDictionary,
                         @"Applying defaults from a non-empty dictionary to an empty dictionary copies over all key-values pairs");

    STAssertEqualObjects(_.defaults(simpleDictionary, emptyDictionary),
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

    STAssertEqualObjects(_.defaults(simpleDictionary, defaults),
                         fourKeys,
                         @"Applying defaults from a non-empty dictionary to a non-empty dictionary copies over all key-values pairs not existant in the latter");
}

- (void)testFilterKeys;
{
    STAssertEqualObjects(_.filterKeys(emptyDictionary, ^(id key) {return YES;}),
                         emptyDictionary,
                         @"Filtering an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.filterKeys(simpleDictionary, ^(id key) {return YES;}),
                         simpleDictionary,
                         @"Filtering everything results in the original dictionary");

    STAssertEqualObjects(_.filterKeys(simpleDictionary, ^(id key) {return NO;}),
                         emptyDictionary,
                         @"Filtering nothing results in the original dictionary");

    NSDictionary *result = _.filterKeys(simpleDictionary, ^(NSString *key) {
        return [key isEqualToString:@"key2"];
    });

    STAssertEqualObjects(result,
                         [NSDictionary dictionaryWithObject:@"object2" forKey:@"key2"],
                         @"Can filter only specific keys");
}

- (void)testFilterValues;
{
    STAssertEqualObjects(_.filterValues(emptyDictionary, ^(id obj) {return YES;}),
                         emptyDictionary,
                         @"Filtering an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.filterValues(simpleDictionary, ^(id obj) {return YES;}),
                         simpleDictionary,
                         @"Filtering everything results in the original dictionary");

    STAssertEqualObjects(_.filterValues(simpleDictionary, ^(id obj) {return NO;}),
                         emptyDictionary,
                         @"Filtering nothing results in the original dictionary");

    NSDictionary *result = _.filterValues(simpleDictionary, ^(NSString *obj) {
        return [obj isEqualToString:@"object2"];
    });

    STAssertEqualObjects(result,
                         [NSDictionary dictionaryWithObject:@"object2" forKey:@"key2"],
                         @"Can filter only specific values");
}

- (void)testRejectKeys;
{
    STAssertEqualObjects(_.rejectKeys(emptyDictionary, ^(id key) {return YES;}),
                         emptyDictionary,
                         @"Rejecting keys of an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.rejectKeys(simpleDictionary, ^(id key) {return YES;}),
                         emptyDictionary,
                         @"Rejecting everything results in an empty dictionary");

    STAssertEqualObjects(_.rejectKeys(simpleDictionary, ^(id key) {return NO;}),
                         simpleDictionary,
                         @"Rejecting nothing results in the original dictionary");

    NSDictionary *result = _.rejectKeys(simpleDictionary, ^(NSString *key) {
        return [key isEqualToString:@"key2"];
    });

    NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:@"object1", @"key1",
                                                                        @"object3", @"key3",
                                                                        nil];

    STAssertEqualObjects(result,
                         expected,
                         @"Can reject only specific keys");
}

- (void)testRejectValues;
{
    STAssertEqualObjects(_.rejectValues(emptyDictionary, ^(id obj) {return YES;}),
                         emptyDictionary,
                         @"Rejecting values of an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.rejectValues(simpleDictionary, ^(id obj) {return YES;}),
                         emptyDictionary,
                         @"Rejecting everything results in an empty dictionary");

    STAssertEqualObjects(_.rejectValues(simpleDictionary, ^(id obj) {return NO;}),
                         simpleDictionary,
                         @"Rejecting nothing results in the original dictionary");

    NSDictionary *result = _.rejectValues(simpleDictionary, ^(NSString *obj) {
        return [obj isEqualToString:@"object2"];
    });

    NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:@"object1", @"key1",
                                                                        @"object3", @"key3",
                                                                        nil];

    STAssertEqualObjects(result,
                         expected,
                         @"Can reject only specific values");
}

@end
