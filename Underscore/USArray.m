//
//  USArray.m
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USArray.h"

@interface USArray ()

- initWithArray:(NSArray *)array;

@property (readwrite, retain) NSArray *array;

@end

@implementation USArray

#pragma mark Class methods

+ (USArray *)wrap:(NSArray *)array;
{
    return [[USArray alloc] initWithArray:[array copy]];
}

#pragma mark Lifecycle

- (id)init;
{
    return [super init];
}

- (id)initWithArray:(NSArray *)array;
{
    if (self = [super init]) {
        self.array = array;
    }
    return self;
}

@synthesize array = _array;

- (NSArray *)unwrap;
{
    return self.array;
}

#pragma mark Underscore methods

- (id (^)(void))first;
{
    return ^id (void){
        return self.array.count ? [self.array objectAtIndex:0] : nil;
    };
}

- (id (^)(void))last;
{
    return ^id (void){
        return self.array.lastObject;
    };
}

- (USArray *(^)(NSUInteger))head;
{
    return ^USArray *(NSUInteger count) {
        NSRange    range     = NSMakeRange(0, MIN(self.array.count, count));
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray    *result   = [self.array objectsAtIndexes:indexSet];

        return [[USArray alloc] initWithArray:result];
    };
}

- (USArray *(^)(NSUInteger))tail;
{
    return ^USArray *(NSUInteger count) {
        NSRange range;
        if (count > self.array.count) {
            range = NSMakeRange(0, self.array.count);
        } else {
            range = NSMakeRange(self.array.count - count, count);
        }

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray    *result   = [self.array objectsAtIndexes:indexSet];

        return [[USArray alloc] initWithArray:result];
    };
}

- (USArray *(^)(void))flatten;
{
    __block NSArray *(^flatten)(NSArray *) = ^NSArray *(NSArray *input) {
        NSMutableArray *result = [NSMutableArray array];

        for (id obj in input) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [result addObjectsFromArray:flatten(obj)];
            } else {
                [result addObject:obj];
            }
        }

        return result;
    };

    return ^USArray *(void) {
        return [USArray wrap:flatten(self.array)];
    };
}

- (USArray *(^)(NSArray *))without;
{
    return ^USArray *(NSArray *value) {
        return self.reject(^(id obj){
            return [value containsObject:obj];
        });
    };
}

- (USArray *(^)(void))shuffle;
{
    return ^USArray *(void) {
        NSMutableArray *result = [self.array mutableCopy];

        for (NSInteger i = result.count - 1; i > 0; i--) {
                [result exchangeObjectAtIndex:arc4random() % (i + 1)
                            withObjectAtIndex:i];
        }

        return [[USArray alloc] initWithArray:result];
    };
}

- (id (^)(id, USArrayReduceBlock))reduce;
{
    return ^USArray *(id memo, USArrayReduceBlock function) {
        for (id obj in self.array) {
            memo = function(memo, obj);
        }

        return memo;
    };
}

- (id (^)(id, USArrayReduceBlock))reduceRight;
{
    return ^USArray *(id memo, USArrayReduceBlock function) {
        for (id obj in self.array.reverseObjectEnumerator) {
            memo = function(memo, obj);
        }

        return memo;
    };
}

- (USArray *(^)(USArrayIteratorBlock))each;
{
    return ^USArray *(USArrayIteratorBlock block) {
        for (id obj in self.array) {
            block(obj);
        }

        return self;
    };
}

- (USArray *(^)(USArrayMapBlock))map;
{
    return ^USArray *(USArrayMapBlock block) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];

        for (id obj in self.array) {
            [result addObject:block(obj)];
        }

        return [[USArray alloc] initWithArray:result];
    };
}

- (id (^)(USArrayTestBlock))find;
{
    return ^id (USArrayTestBlock test) {
        for (id obj in self.array) {
            if (test(obj)) {
                return obj;
            }
        }

        return nil;
    };
}

- (USArray *(^)(USArrayTestBlock))filter;
{
    return ^USArray *(USArrayTestBlock test) {
        NSMutableArray *result = [NSMutableArray array];

        for (id obj in self.array) {
            if (test(obj)) {
                [result addObject:obj];
            }
        }

        return [[USArray alloc] initWithArray:result];
    };
}

- (USArray *(^)(USArrayTestBlock))reject;
{
    return ^USArray *(USArrayTestBlock test) {
        return self.filter(^BOOL (id obj){
            return !test(obj);
        });
    };
}

- (BOOL (^)(USArrayTestBlock))all;
{
    return ^BOOL (USArrayTestBlock test) {
        BOOL result = YES;

        for (id obj in self.array) {
            if (!test(obj)) {
                return NO;
            }
        }

        return result;
    };
}

- (BOOL (^)(USArrayTestBlock))any;
{
    return ^BOOL (USArrayTestBlock test) {
        if (self.array.count == 0) {
            return YES;
        }

        BOOL result = NO;

        for (id obj in self.array) {
            if (test(obj)) {
                return YES;
            }
        }

        return result;
    };
}

@end
