//
//  USDictionary.m
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USDictionary.h"

@interface USDictionary ()

- initWithDictionary:(NSDictionary *)dictionary;

@property (readwrite, retain) NSDictionary *dictionary;

@end

@implementation USDictionary

#pragma mark Class methods

+ (USDictionary *)wrap:(NSDictionary *)dictionary;
{
    return [[USDictionary alloc] initWithDictionary:[dictionary copy]];
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

- (USArray *)keys;
{
    return [USArray wrap:self.dictionary.allKeys];
}

- (USArray *)values;
{
    return [USArray wrap:self.dictionary.allValues];
}

- (USDictionary *(^)(UnderscoreDictionaryIteratorBlock))each;
{
    return ^USDictionary *(UnderscoreDictionaryIteratorBlock block) {
        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            block(key, obj);
        }];

        return self;
    };
}

- (USDictionary *(^)(UnderscoreDictionaryMapBlock))map;
{
    return ^USDictionary *(UnderscoreDictionaryMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:block(key, obj)
                       forKey:key];
        }];

        return [[USDictionary alloc] initWithDictionary:result];
    };
}

- (USDictionary *(^)(NSArray *))pick;
{
    return ^USDictionary *(NSArray *keys) {
        __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:keys.count];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([keys containsObject:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [[USDictionary alloc] initWithDictionary:result];
    };
}

- (USDictionary *(^)(NSDictionary *))extend;
{
    return ^USDictionary *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:obj
                       forKey:key];
        }];

        return [[USDictionary alloc] initWithDictionary:result];
    };
}

@end
