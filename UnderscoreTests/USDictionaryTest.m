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

static UnderscoreTestBlock allPass  = ^BOOL(id any) {return YES; };
static UnderscoreTestBlock nonePass = ^BOOL(id any) {return NO; };

#define _ Underscore

#define USAssertEqualObjects(functional, wrapper) \
        STAssertEqualObjects(functional, wrapper, @"Wrapper and Shortcut behave equally");

@implementation USDictionaryTest

- (void)setUp
{
    emptyArray   = @[];
    singleObject = @[ @"foo"];
    threeObjects = @[ @"foo", @"bar", @"baz" ];

    emptyDictionary  = @{};
    simpleDictionary = @{
        @"key1": @"object1",
        @"key2": @"object2",
        @"key3": @"object3"
    };
}

- (void)testKeys
{
    STAssertEqualObjects(_.keys(emptyDictionary),
                         emptyArray,
                         @"An empty dictionary returns an empty keys array");

    NSArray *result = _.keys(simpleDictionary);

    STAssertTrue([result containsObject:@"key1"], @"Can extract key 'key1'");
    STAssertTrue([result containsObject:@"key2"], @"Can extract key 'key2'");
    STAssertTrue([result containsObject:@"key3"], @"Can extract key 'key3'");

    USAssertEqualObjects(_.keys(emptyDictionary) ,
                         _.dict(emptyDictionary).keys.unwrap);
    USAssertEqualObjects(_.keys(simpleDictionary),
                         _.dict(simpleDictionary).keys.unwrap);
}

- (void)testValues
{
    STAssertEqualObjects(_.values(emptyDictionary),
                         emptyArray,
                         @"An empty dictionary returns an empty values array");

    NSArray *result = _.values(simpleDictionary);

    STAssertTrue([result containsObject:@"object1"], @"Can extract object 'object1'");
    STAssertTrue([result containsObject:@"object2"], @"Can extract object 'object2'");
    STAssertTrue([result containsObject:@"object3"], @"Can extract object 'object3'");

    USAssertEqualObjects(_.values(emptyDictionary) ,
                         _.dict(emptyDictionary).values.unwrap);
    USAssertEqualObjects(_.values(simpleDictionary),
                         _.dict(simpleDictionary).values.unwrap);
}

- (void)testEachFunctional
{
    __block NSUInteger zero = 0;

    _.dict(emptyDictionary).each(^(id key, id obj) {
        zero++;
    });

    STAssertTrue(zero == 0, @"An empty dictionary never triggers the block");

    __block NSUInteger runs = 0;
    __block BOOL checked1 = NO, checked2 = NO, checked3 = NO;

    _.dictEach(simpleDictionary, ^(NSString *key, NSString *obj) {
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


- (void)testEachWrapping
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

- (void)testMapFunctional
{
    __block NSUInteger zero = 0;

    _.dictMap(emptyDictionary, ^(id key, id obj) {
        zero++;
        return obj;
    });

    STAssertTrue(zero == 0, @"An empty dictionary never triggers the block");

    STAssertEqualObjects(_.dictMap(simpleDictionary, ^id (id key, id obj) {return nil;}),
                         emptyDictionary,
                         @"Returning nil in the map block removes the key value pair");

    NSDictionary *result = _.dictMap(simpleDictionary, ^(NSString *key, NSString *obj) {
        return [obj capitalizedString];
    });

    NSDictionary *capitalized = @{
        @"key1": @"Object1",
        @"key2": @"Object2",
        @"key3": @"Object3"
    };

    STAssertEqualObjects(result,
                         capitalized,
                         @"Can map objects");
}

- (void)testMapWrapping
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

    NSDictionary *capitalized = @{
        @"key1": @"Object1",
        @"key2": @"Object2",
        @"key3": @"Object3"
    };

    STAssertEqualObjects(result,
                         capitalized,
                         @"Can map objects");
}

- (void)testPick
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

    NSArray *key1 = @[ @"key1" ];

    STAssertEqualObjects(_.pick(simpleDictionary, key1),
                         @{ @"key1": @"object1" },
                         @"Can pick keys");

    USAssertEqualObjects(_.pick(emptyDictionary, threeObjects),
                         _.dict(emptyDictionary).pick(threeObjects).unwrap);
    USAssertEqualObjects(_.pick(simpleDictionary, emptyArray),
                         _.dict(simpleDictionary).pick(emptyArray).unwrap);
    USAssertEqualObjects(_.pick(simpleDictionary, threeObjects),
                         _.dict(simpleDictionary).pick(threeObjects).unwrap);
    USAssertEqualObjects(_.pick(simpleDictionary, key1),
                         _.dict(simpleDictionary).pick(key1).unwrap);
}

- (void)testExtend
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

    NSDictionary *dictionary1 = @{
        @"key1": @"object1",
        @"key2": [NSNull null]
    };

    NSDictionary *dictionary2 = @{
        @"key2": @"object2",
        @"key3": @"object3"
    };

    STAssertEqualObjects(_.extend(dictionary1, dictionary2),
                         simpleDictionary,
                         @"Extending non-empty dictionary with non-empty dictionary overwrites keys where necessary");

    USAssertEqualObjects(_.extend(emptyDictionary, emptyDictionary),
                         _.dict(emptyDictionary).extend(emptyDictionary).unwrap);
    USAssertEqualObjects(_.extend(emptyDictionary, simpleDictionary),
                         _.dict(emptyDictionary).extend(simpleDictionary).unwrap);
    USAssertEqualObjects(_.extend(simpleDictionary, emptyDictionary),
                         _.dict(simpleDictionary).extend(emptyDictionary).unwrap);
    USAssertEqualObjects(_.extend(dictionary1, dictionary2),
                         _.dict(dictionary1).extend(dictionary2).unwrap);
}

- (void)testDefaults
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

    NSDictionary *defaults = @{
        @"key3": [NSNull null],
        @"key4": @"object4"
    };

    NSDictionary *fourKeys = @{
        @"key1": @"object1",
        @"key2": @"object2",
        @"key3": @"object3",
        @"key4": @"object4"
    };

    STAssertEqualObjects(_.defaults(simpleDictionary, defaults),
                         fourKeys,
                         @"Applying defaults from a non-empty dictionary to a non-empty dictionary copies over all key-values pairs not existant in the latter");

    USAssertEqualObjects(_.defaults(emptyDictionary, emptyDictionary),
                         _.dict(emptyDictionary).defaults(emptyDictionary).unwrap);
    USAssertEqualObjects(_.defaults(emptyDictionary, simpleDictionary),
                         _.dict(emptyDictionary).defaults(simpleDictionary).unwrap);
    USAssertEqualObjects(_.defaults(simpleDictionary, emptyDictionary),
                         _.dict(simpleDictionary).defaults(emptyDictionary).unwrap);
    USAssertEqualObjects(_.defaults(simpleDictionary, defaults),
                         _.dict(simpleDictionary).defaults(defaults).unwrap);
}

- (void)testFilterKeys
{
    UnderscoreTestBlock key2Passes = ^(NSString *key) {
        return [key isEqualToString:@"key2"];
    };

    STAssertEqualObjects(_.filterKeys(emptyDictionary, allPass),
                         emptyDictionary,
                         @"Filtering an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.filterKeys(simpleDictionary, allPass),
                         simpleDictionary,
                         @"Filtering everything results in the original dictionary");

    STAssertEqualObjects(_.filterKeys(simpleDictionary, nonePass),
                         emptyDictionary,
                         @"Filtering nothing results in the original dictionary");

    STAssertEqualObjects(_.filterKeys(simpleDictionary, key2Passes),
                         @{ @"key2": @"object2" },
                         @"Can filter only specific keys");

    USAssertEqualObjects(_.filterKeys(emptyDictionary, allPass),
                         _.dict(emptyDictionary).filterKeys(allPass).unwrap);
    USAssertEqualObjects(_.filterKeys(simpleDictionary, allPass),
                         _.dict(simpleDictionary).filterKeys(allPass).unwrap);
    USAssertEqualObjects(_.filterKeys(simpleDictionary, nonePass),
                         _.dict(simpleDictionary).filterKeys(nonePass).unwrap);
    USAssertEqualObjects(_.filterKeys(simpleDictionary, key2Passes),
                         _.dict(simpleDictionary).filterKeys(key2Passes).unwrap);
}

- (void)testFilterValues
{
    UnderscoreTestBlock object2Passes = ^(NSString *obj) {
        return [obj isEqualToString:@"object2"];
    };

    STAssertEqualObjects(_.filterValues(emptyDictionary, allPass),
                         emptyDictionary,
                         @"Filtering an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.filterValues(simpleDictionary, allPass),
                         simpleDictionary,
                         @"Filtering everything results in the original dictionary");

    STAssertEqualObjects(_.filterValues(simpleDictionary, nonePass),
                         emptyDictionary,
                         @"Filtering nothing results in the original dictionary");

    STAssertEqualObjects(_.filterValues(simpleDictionary, object2Passes),
                         @{ @"key2": @"object2" },
                         @"Can filter only specific values");

    USAssertEqualObjects(_.filterValues(emptyDictionary, allPass),
                         _.dict(emptyDictionary).filterValues(allPass).unwrap);
    USAssertEqualObjects(_.filterValues(simpleDictionary, allPass),
                         _.dict(simpleDictionary).filterValues(allPass).unwrap);
    USAssertEqualObjects(_.filterValues(simpleDictionary, nonePass),
                         _.dict(simpleDictionary).filterValues(nonePass).unwrap);
    USAssertEqualObjects(_.filterValues(simpleDictionary, object2Passes),
                         _.dict(simpleDictionary).filterValues(object2Passes).unwrap);
}

- (void)testRejectKeys
{
    UnderscoreTestBlock key2Passes = ^(NSString *obj) {
        return [obj isEqualToString:@"key2"];
    };

    STAssertEqualObjects(_.rejectKeys(emptyDictionary, allPass),
                         emptyDictionary,
                         @"Rejecting keys of an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.rejectKeys(simpleDictionary, allPass),
                         emptyDictionary,
                         @"Rejecting everything results in an empty dictionary");

    STAssertEqualObjects(_.rejectKeys(simpleDictionary, nonePass),
                         simpleDictionary,
                         @"Rejecting nothing results in the original dictionary");

    NSDictionary *expected = @{
        @"key1": @"object1",
        @"key3": @"object3"
    };

    STAssertEqualObjects(_.rejectKeys(simpleDictionary, key2Passes),
                         expected,
                         @"Can reject only specific keys");

    USAssertEqualObjects(_.rejectKeys(emptyDictionary, allPass),
                         _.dict(emptyDictionary).rejectKeys(allPass).unwrap);
    USAssertEqualObjects(_.rejectKeys(simpleDictionary, allPass),
                         _.dict(simpleDictionary).rejectKeys(allPass).unwrap);
    USAssertEqualObjects(_.rejectKeys(simpleDictionary, nonePass),
                         _.dict(simpleDictionary).rejectKeys(nonePass).unwrap);
    USAssertEqualObjects(_.rejectKeys(simpleDictionary, key2Passes),
                         _.dict(simpleDictionary).rejectKeys(key2Passes).unwrap);
}

- (void)testRejectValues
{
    UnderscoreTestBlock object2Passes = ^(NSString *obj) {
        return [obj isEqualToString:@"object2"];
    };

    STAssertEqualObjects(_.rejectValues(emptyDictionary, allPass),
                         emptyDictionary,
                         @"Rejecting values of an empty dictionary returns an empty dictionary");

    STAssertEqualObjects(_.rejectValues(simpleDictionary, allPass),
                         emptyDictionary,
                         @"Rejecting everything results in an empty dictionary");

    STAssertEqualObjects(_.rejectValues(simpleDictionary, nonePass),
                         simpleDictionary,
                         @"Rejecting nothing results in the original dictionary");

    NSDictionary *expected = @{
        @"key1": @"object1",
        @"key3": @"object3"
    };

    STAssertEqualObjects(_.rejectValues(simpleDictionary, object2Passes),
                         expected,
                         @"Can reject only specific values");

    USAssertEqualObjects(_.rejectValues(emptyDictionary, allPass),
                         _.dict(emptyDictionary).rejectValues(allPass).unwrap);
    USAssertEqualObjects(_.rejectValues(simpleDictionary, allPass),
                         _.dict(simpleDictionary).rejectValues(allPass).unwrap);
    USAssertEqualObjects(_.rejectValues(simpleDictionary, nonePass),
                         _.dict(simpleDictionary).rejectValues(nonePass).unwrap);
    USAssertEqualObjects(_.rejectValues(simpleDictionary, object2Passes),
                         _.dict(simpleDictionary).rejectValues(object2Passes).unwrap);
}

@end
