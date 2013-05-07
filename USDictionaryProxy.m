//
//  USDictionaryProxy.m
//  Underscore
//
//  Created by Robert Böhnke on 5/7/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "USArrayProxy.h"

#import "USDictionaryProxy.h"

@implementation USDictionaryProxy

+ (NSDictionary<USDictionary> *)wrap:(NSDictionary *)dictionary
{
    return (NSDictionary<USDictionary> *)[[self alloc] initWithDictionary:dictionary];
}

#pragma mark - Lifecycle

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self) {
        _dictionary = [dictionary copy];
    }
    return self;
}

#pragma mark - USDictionary

- (NSArray<USArray> *)keys
{
    return [USArrayProxy wrap:self.dictionary.allKeys];
}

- (NSArray<USArray> *)values
{
    return [USArrayProxy wrap:self.dictionary.allValues];
}

- (NSDictionary<USDictionary> *(^)(UnderscoreDictionaryIteratorBlock))each
{
    return ^NSDictionary<USDictionary> *(UnderscoreDictionaryIteratorBlock block) {
        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            block(key, obj);
        }];

        return (NSDictionary<USDictionary> *)self;
    };
}

- (NSDictionary<USDictionary> *(^)(UnderscoreDictionaryMapBlock))map
{
    return ^NSDictionary<USDictionary> *(UnderscoreDictionaryMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id mapped = block(key, obj);

            if (mapped) {
                [result setObject:mapped
                           forKey:key];
            }
        }];

        return [USDictionaryProxy wrap:result];
    };
}

- (NSDictionary<USDictionary> *(^)(NSArray *))pick
{
    return ^NSDictionary<USDictionary> *(NSArray *keys) {
        __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:keys.count];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([keys containsObject:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [USDictionaryProxy wrap:result];
    };
}

- (NSDictionary<USDictionary> *(^)(NSDictionary *))extend
{
    return ^NSDictionary<USDictionary> *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:obj
                       forKey:key];
        }];

        return [USDictionaryProxy wrap:result];
    };
}

- (NSDictionary<USDictionary> *(^)(NSDictionary *))defaults
{
    return ^NSDictionary<USDictionary> *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![result valueForKey:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [USDictionaryProxy wrap:result];
    };
}

- (NSDictionary<USDictionary> *(^)(UnderscoreTestBlock))filterKeys
{
    return ^NSDictionary<USDictionary> *(UnderscoreTestBlock test) {
        return self.map(^id (id key, id obj) {
            return test(key) ? obj : nil;
        });
    };
}

- (NSDictionary<USDictionary> *(^)(UnderscoreTestBlock))filterValues
{
    return ^NSDictionary<USDictionary> *(UnderscoreTestBlock test) {
        return self.map(^id (id key, id obj) {
            return test(obj) ? obj : nil;
        });
    };
}

- (NSDictionary<USDictionary> *(^)(UnderscoreTestBlock))rejectKeys
{
    return ^NSDictionary<USDictionary> *(UnderscoreTestBlock test) {
        return self.filterKeys(Underscore.negate(test));
    };
}

- (NSDictionary<USDictionary> *(^)(UnderscoreTestBlock))rejectValues
{
    return ^NSDictionary<USDictionary> *(UnderscoreTestBlock test) {
        return self.filterValues(Underscore.negate(test));
    };
}

@end
