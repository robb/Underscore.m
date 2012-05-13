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

@end
