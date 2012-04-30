//
//  NSArray+Underscore.m
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "NSArray+Underscore.h"

#include <stdlib.h>

@implementation NSArray (Underscore)

+ __from:(NSInteger)start to:(NSInteger)end
{
    return [NSArray __from:start to:end step:start < end ? 1 : -1];
}

+ __from:(NSInteger)start to:(NSInteger)end step:(NSInteger)step
{
    NSInteger length  = fmax(ceil(((double) end - start) / step), 0.0);
    NSInteger current = start;

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        [result addObject:[NSNumber numberWithInteger:current]];
        current += step;
    }

    return result;
}

- (id)__first
{
    return self.count ? [self objectAtIndex:0] : nil;
}

- (id)__last
{
    return [self lastObject];
}

- (NSArray *)__head:(NSUInteger)count
{
    NSRange range = NSMakeRange(0, count);

    return [self subarrayWithRange:range];
}

- (NSArray *)__tail:(NSUInteger)count
{
    NSRange range = NSMakeRange(self.count - count, count);

    return [self subarrayWithRange:range];
}

- (NSArray *)__flatten
{
    NSMutableArray *result = [NSMutableArray array];

    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [result addObjectsFromArray:[obj __flatten]];
        } else {
            [result addObject:obj];
        }
    }

    return result;
}

- (NSArray *)__without:(NSArray *)values
{
    NSMutableArray *result = [NSMutableArray array];

    for (id obj in self) {
        if (![values containsObject:obj]) {
            [result addObject:obj];
        }
    }

    return result;
}

- (NSArray *)__shuffle
{
    NSMutableArray *result = [self mutableCopy];

    for (NSInteger i = self.count - 1; i > 0; i--) {
        [result exchangeObjectAtIndex:arc4random() % (i + 1)
                    withObjectAtIndex:i];
    }

    return result;
}

- (void)__each:(UnderscoreArrayIteratorBlock)block
{
    for (id obj in self) {
        block(obj);
    }
}

- (NSArray *)__map:(UnderscoreArrayMapBlock)block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];

    for (id obj in self) {
        [result addObject:block(obj)];
    }

    return result;
}

- (id)__find:(UnderscoreArrayTestBlock)block
{
    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }

    return nil;
}

- (NSArray *)__filter:(UnderscoreArrayTestBlock)block
{
    NSMutableArray *result = [NSMutableArray array];

    for (id obj in self) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }

    return result;
}

- (NSArray *)__reject:(UnderscoreArrayTestBlock)block
{
    UnderscoreArrayTestBlock inverted = ^BOOL(id obj) {
        return !block(obj);
    };

    return [self __filter:inverted];
}

- (BOOL)__all:(UnderscoreArrayTestBlock)block
{
    for (id obj in self) {
        if (!block(obj)) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)__any:(UnderscoreArrayTestBlock)block
{
    for (id obj in self) {
        if (block(obj)) {
            return YES;
        }
    }

    return NO;
}

@end
