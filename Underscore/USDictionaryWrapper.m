//
//  USDictionaryWrapper.m
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

#import "USDictionaryWrapper.h"

@interface USDictionaryWrapper ()

- initWithDictionary:(NSDictionary *)dictionary;

@property (readwrite, retain) NSDictionary *dictionary;

@end

@implementation USDictionaryWrapper

#pragma mark Class methods

+ (USDictionaryWrapper *)wrap:(NSDictionary *)dictionary;
{
    return [[USDictionaryWrapper alloc] initWithDictionary:[dictionary copy]];
}

#pragma mark Lifecycle

- (id)init;
{
    return [super init];
}

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    if (self = [super init]) {
        self.dictionary = dictionary;
    }
    return self;
}
@synthesize dictionary = _dictionary;

- (NSDictionary *)unwrap;
{
    return [self.dictionary copy];
}

#pragma mark Underscore methods

- (USArrayWrapper *)keys;
{
    return [USArrayWrapper wrap:self.dictionary.allKeys];
}

- (USArrayWrapper *)values;
{
    return [USArrayWrapper wrap:self.dictionary.allValues];
}

- (USDictionaryWrapper *(^)(UnderscoreDictionaryIteratorBlock))each;
{
    return ^USDictionaryWrapper *(UnderscoreDictionaryIteratorBlock block) {
        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            block(key, obj);
        }];

        return self;
    };
}

- (USDictionaryWrapper *(^)(UnderscoreDictionaryMapBlock))map;
{
    return ^USDictionaryWrapper *(UnderscoreDictionaryMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id mapped = block(key, obj);

            if (mapped) {
                [result setObject:mapped
                           forKey:key];
            }
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(NSArray *))pick;
{
    return ^USDictionaryWrapper *(NSArray *keys) {
        __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:keys.count];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([keys containsObject:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(NSDictionary *))extend;
{
    return ^USDictionaryWrapper *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:obj
                       forKey:key];
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(NSDictionary *))defaults;
{
    return ^USDictionaryWrapper *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![result valueForKey:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))filterKeys;
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.map(^id (id key, id obj) {
            return test(key) ? obj : nil;
        });
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))filterValues;
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.map(^id (id key, id obj) {
            return test(obj) ? obj : nil;
        });
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))rejectKeys;
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.filterKeys(Underscore.negate(test));
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))rejectValues;
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.filterValues(Underscore.negate(test));
    };
}

@end
