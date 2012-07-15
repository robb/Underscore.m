//
//  Underscore+Shortcuts.h
//  Underscore
//
//  Created by Robert Böhnke on 7/15/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

@interface Underscore (Shortcuts)

#pragma mark NSArray shortcuts

+ (USArrayWrapper *(^)(NSArray *))array;

+ (id (^)(NSArray *))first;
+ (id (^)(NSArray *))last;

+ (NSArray *(^)(NSArray *array, NSUInteger n))head;
+ (NSArray *(^)(NSArray *array, NSUInteger n))tail;

+ (NSArray *(^)(NSArray *array))flatten;
+ (NSArray *(^)(NSArray *array, NSArray *values))without;

+ (NSArray *(^)(NSArray *array))shuffle;

+ (id (^)(NSArray *array, id memo, UnderscoreReduceBlock block))reduce;
+ (id (^)(NSArray *array, id memo, UnderscoreReduceBlock block))reduceRight;

+ (NSArray *(^)(NSArray *array, NSString *keyPath))pluck;

+ (id (^)(NSArray *array, UnderscoreTestBlock block))find;

+ (NSArray *(^)(NSArray *array, UnderscoreTestBlock block))filter;
+ (NSArray *(^)(NSArray *array, UnderscoreTestBlock block))reject;

+ (BOOL (^)(NSArray *array, UnderscoreTestBlock block))all;
+ (BOOL (^)(NSArray *array, UnderscoreTestBlock block))any;

#pragma mark NSDictionary shortcuts

+ (USDictionaryWrapper *(^)(NSDictionary *dictionary))dict;

+ (NSArray *(^)(NSDictionary *dictionary))keys;
+ (NSArray *(^)(NSDictionary *dictionary))values;

+ (NSDictionary *(^)(NSDictionary *dictionary, NSArray *keys))pick;

+ (NSDictionary *(^)(NSDictionary *dictionary, NSDictionary *source))extend;
+ (NSDictionary *(^)(NSDictionary *dictionary, NSDictionary *defaults))defaults;

+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))filterKeys;
+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))filterValues;

+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))rejectKeys;
+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))rejectValues;

@end
