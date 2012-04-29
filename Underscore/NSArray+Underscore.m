//
//  NSArray+Underscore.m
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "NSArray+Underscore.h"

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

- (NSArray *)__flatten;
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

- (NSArray *)__without:(NSArray *)values;
{
    NSMutableArray *result = [NSMutableArray array];

    for (id obj in self) {
        if (![values containsObject:obj]) {
            [result addObject:obj];
        }
    }

    return result;
}

@end
