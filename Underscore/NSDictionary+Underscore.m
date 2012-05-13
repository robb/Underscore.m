//
//  NSDictionary+Underscore.m
//  Underscore
//
//  Created by Robert Böhnke on 5/1/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "NSDictionary+Underscore.h"

@implementation NSDictionary (Underscore)

- (NSDictionary *)__prune
{
    return [self __reject:^BOOL(id key, id obj) {
        return [obj isKindOfClass:NSNull.class];
    }];
}

- (id)__reduce:(UnderscoreDictionaryReduceBlock)block intialValue:(id)memo
{
    __block id current = memo;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        current = block(current, key, obj);
    }];

    return current;
}

- (void)__each:(UnderscoreDictionaryIteratorBlock)block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (NSDictionary *)__map:(UnderscoreDictionaryMapBlock)block
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [result setObject:block(key, obj)
                   forKey:key];
    }];

    return result;
}

- (id)__find:(UnderscoreDictionaryTestBlock)block
{
    __block id result = nil;

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) {
            result = key;
            *stop  = YES;
        }
    }];

    return result;
}

- (NSDictionary *)__filter:(UnderscoreDictionaryTestBlock)block
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) {
            [result setObject:obj forKey:key];
        }
    }];

    return result;
}

- (NSDictionary *)__reject:(UnderscoreDictionaryTestBlock)block
{
    UnderscoreDictionaryTestBlock inverted = ^BOOL(id key, id obj) {
        return !block(key, obj);
    };

    return [self __filter:inverted];
}

@end
