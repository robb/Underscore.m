//
//  USArrayProxy.m
//  Underscore
//
//  Created by Robert Böhnke on 5/7/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "USArrayProxy.h"

@implementation USArrayProxy

+ (NSArray<USArray> *)wrap:(NSArray *)array
{
    return (NSArray<USArray> *)[[self alloc] initWithArray:array];
}

#pragma mark - Lifecycle

- (id)initWithArray:(NSArray *)array
{
    if (self) {
        _array = [array copy];
    }
    return self;
}

#pragma mark - USArray

- (id)first
{
    return self.array.count ? [self.array objectAtIndex:0] : nil;
}

- (id)last
{
    return self.array.lastObject;
}

- (NSArray<USArray> *(^)(NSUInteger))head
{
    return ^NSArray<USArray> *(NSUInteger count) {
        NSRange    range     = NSMakeRange(0, MIN(self.array.count, count));
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray    *result   = [self.array objectsAtIndexes:indexSet];

        return [USArrayProxy wrap:result];
    };
}

- (NSArray<USArray> *(^)(NSUInteger))tail
{
    return ^NSArray<USArray> *(NSUInteger count) {
        NSRange range;
        if (count > self.array.count) {
            range = NSMakeRange(0, self.array.count);
        } else {
            range = NSMakeRange(self.array.count - count, count);
        }

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray    *result   = [self.array objectsAtIndexes:indexSet];

        return [USArrayProxy wrap:result];
    };
}

- (NSUInteger (^)(id))indexOf
{
    return ^NSUInteger (id obj) {
        return [self.array indexOfObject:obj];
    };
}

- (NSArray<USArray> *)flatten
{
    __weak NSArray *array = self.array;
    __block NSArray *(^flatten)(NSArray *) = ^NSArray *(NSArray *input) {
        NSMutableArray *result = [NSMutableArray array];

        for (id obj in input) {
            if ([obj isKindOfClass:[NSArray class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
                [result addObjectsFromArray:flatten(obj)];
#pragma clang diagnostic pop
            } else {
                [result addObject:obj];
            }
        }

        // If the outmost call terminates, nil the reference to flatten to break
        // the retain cycle
        if (input == array) {
            flatten = nil;
        }

        return result;
    };

    return [USArrayProxy wrap:flatten(self.array)];
}

- (NSArray<USArray> *(^)(NSArray *))without
{
    return ^NSArray<USArray> *(NSArray *value) {
        return self.reject(^(id obj){
            return [value containsObject:obj];
        });
    };
}

- (NSArray<USArray> *)shuffle
{
    NSMutableArray *result = [self.array mutableCopy];

    for (NSInteger i = result.count - 1; i > 0; i--) {
        [result exchangeObjectAtIndex:arc4random() % (i + 1)
                    withObjectAtIndex:i];
    }

    return [USArrayProxy wrap:result];
}

- (id (^)(id, UnderscoreReduceBlock))reduce
{
    return ^NSArray<USArray> *(id memo, UnderscoreReduceBlock function) {
        for (id obj in self.array) {
            memo = function(memo, obj);
        }

        return memo;
    };
}

- (id (^)(id, UnderscoreReduceBlock))reduceRight
{
    return ^NSArray<USArray> *(id memo, UnderscoreReduceBlock function) {
        for (id obj in self.array.reverseObjectEnumerator) {
            memo = function(memo, obj);
        }

        return memo;
    };
}

- (NSArray<USArray> *(^)(UnderscoreArrayIteratorBlock))each
{
    return ^NSArray<USArray> *(UnderscoreArrayIteratorBlock block) {
        for (id obj in self.array) {
            block(obj);
        }

        return (NSArray<USArray> *)self;
    };
}

- (NSArray<USArray> *(^)(UnderscoreArrayMapBlock))map
{
    return ^NSArray<USArray> *(UnderscoreArrayMapBlock block) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];

        for (id obj in self.array) {
            id mapped = block(obj);

            if (mapped) {
                [result addObject:mapped];
            }
        }

        return [USArrayProxy wrap:result];
    };
}

- (NSArray<USArray> *(^)(NSString *))pluck
{
    return ^NSArray<USArray> *(NSString *keyPath) {
        return self.map(^id (id obj) {
            return [obj valueForKeyPath:keyPath];
        });
    };
}

- (NSArray<USArray> *)uniq
{
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:self.array];

    return [USArrayProxy wrap:[set array]];
}

- (id (^)(UnderscoreTestBlock))find
{
    return ^id (UnderscoreTestBlock test) {
        for (id obj in self.array) {
            if (test(obj)) {
                return obj;
            }
        }

        return nil;
    };
}

- (NSArray<USArray> *(^)(UnderscoreTestBlock))filter
{
    return ^NSArray<USArray> *(UnderscoreTestBlock test) {
        return self.map(^id (id obj) {
            return test(obj) ? obj : nil;
        });
    };
}

- (NSArray<USArray> *(^)(UnderscoreTestBlock))reject
{
    return ^NSArray<USArray> *(UnderscoreTestBlock test) {
        return self.filter(Underscore.negate(test));
    };
}

- (BOOL (^)(UnderscoreTestBlock))all
{
    return ^BOOL (UnderscoreTestBlock test) {
        if (self.array.count == 0) {
            return NO;
        }

        BOOL result = YES;

        for (id obj in self.array) {
            if (!test(obj)) {
                return NO;
            }
        }

        return result;
    };
}

- (BOOL (^)(UnderscoreTestBlock))any
{
    return ^BOOL (UnderscoreTestBlock test) {
        BOOL result = NO;

        for (id obj in self.array) {
            if (test(obj)) {
                return YES;
            }
        }

        return result;
    };
}

- (NSArray<USArray> *(^)(UnderscoreSortBlock))sort
{
    return ^NSArray<USArray> *(UnderscoreSortBlock block) {
        NSArray *result = [self.array sortedArrayUsingComparator:block];
        return [USArrayProxy wrap:result];
    };
}

@end
