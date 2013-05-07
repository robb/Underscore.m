//
//  Underscore+Functional.m
//  Underscore
//
//  Created by Robert Böhnke on 7/15/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "USArrayProxy.h"
#import "USDictionaryProxy.h"

#import "Underscore+Functional.h"

@implementation Underscore (Functional)

#pragma mark NSArray shortcuts

+ (NSArray<USArray> *(^)(NSArray *))array
{
    return ^(NSArray *array) {
        return [USArrayProxy wrap:array];
    };
}

+ (id (^)(NSArray *))first
{
    return ^(NSArray *array) {
        return Underscore.array(array).first;
    };
}

+ (id (^)(NSArray *))last
{
    return ^(NSArray *array) {
        return Underscore.array(array).last;
    };
}

+ (NSArray *(^)(NSArray *, NSUInteger))head
{
    return ^(NSArray *array, NSUInteger n) {
        return Underscore.array(array).head(n);
    };
}

+ (NSArray *(^)(NSArray *, NSUInteger))tail
{
    return ^(NSArray *array, NSUInteger n) {
        return Underscore.array(array).tail(n);
    };
}

+ (NSUInteger (^)(NSArray *, id))indexOf
{
    return ^(NSArray *array, id obj) {
        return Underscore.array(array).indexOf(obj);
    };
}

+ (NSArray *(^)(NSArray *))flatten
{
    return ^(NSArray *array) {
        return Underscore.array(array).flatten;
    };
}

+ (NSArray *(^)(NSArray *))uniq
{
    return ^(NSArray *array) {
        return Underscore.array(array).uniq;
    };
}

+ (NSArray *(^)(NSArray *, NSArray *))without
{
    return ^(NSArray *array, NSArray *values) {
        return Underscore.array(array).without(values);
    };
}

+ (NSArray *(^)(NSArray *))shuffle
{
    return ^(NSArray *array) {
        return Underscore.array(array).shuffle;
    };
}

+(id (^)(NSArray *, id, UnderscoreReduceBlock))reduce
{
    return ^(NSArray *array, id memo, UnderscoreReduceBlock block) {
        return Underscore.array(array).reduce(memo, block);
    };
}

+ (id (^)(NSArray *, id, UnderscoreReduceBlock))reduceRight
{
    return ^(NSArray *array, id memo, UnderscoreReduceBlock block) {
        return Underscore.array(array).reduceRight(memo, block);
    };
}

+ (void (^)(NSArray *, UnderscoreArrayIteratorBlock))arrayEach
{
    return ^(NSArray *array, UnderscoreArrayIteratorBlock block) {
        Underscore.array(array).each(block);
    };
}

+ (NSArray *(^)(NSArray *array, UnderscoreArrayMapBlock block))arrayMap
{
    return ^(NSArray *array, UnderscoreArrayMapBlock block) {
        return Underscore.array(array).map(block);
    };
}

+ (NSArray *(^)(NSArray *, NSString *))pluck
{
    return ^(NSArray *array, NSString *keyPath) {
        return Underscore.array(array).pluck(keyPath);
    };
}

+ (id (^)(NSArray *, UnderscoreTestBlock))find
{
    return ^(NSArray *array, UnderscoreTestBlock block) {
        return Underscore.array(array).find(block);
    };
}

+ (NSArray *(^)(NSArray *, UnderscoreTestBlock))filter
{
    return ^(NSArray *array, UnderscoreTestBlock block) {
        return Underscore.array(array).filter(block);
    };
}
+ (NSArray *(^)(NSArray *, UnderscoreTestBlock))reject
{
    return ^(NSArray *array, UnderscoreTestBlock block) {
        return Underscore.array(array).reject(block);
    };
}

+ (BOOL (^)(NSArray *, UnderscoreTestBlock))all
{
    return ^(NSArray *array, UnderscoreTestBlock block) {
        return Underscore.array(array).all(block);
    };
}
+ (BOOL (^)(NSArray *, UnderscoreTestBlock))any
{
    return ^(NSArray *array, UnderscoreTestBlock block) {
        return Underscore.array(array).any(block);
    };
}

+ (NSArray *(^)(NSArray *, UnderscoreSortBlock))sort
{
    return ^(NSArray *array, UnderscoreSortBlock block) {
        return Underscore.array(array).sort(block);
    };
}

#pragma mark NSDictionary shortcuts

+ (NSDictionary<USDictionary> *(^)(NSDictionary *))dict
{
    return ^(NSDictionary *dictionary) {
        return [USDictionaryProxy wrap:dictionary];
    };
}

+ (NSArray *(^)(NSDictionary *))keys
{
    return ^(NSDictionary *dictionary) {
        return [USDictionaryProxy wrap:dictionary].keys;
    };
}
+ (NSArray *(^)(NSDictionary *))values
{
    return ^(NSDictionary *dictionary) {
        return [USDictionaryProxy wrap:dictionary].values;
    };
}

+ (void (^)(NSDictionary *, UnderscoreDictionaryIteratorBlock))dictEach
{
    return ^(NSDictionary *dictionary, UnderscoreDictionaryIteratorBlock block) {
        Underscore.dict(dictionary).each(block);
    };
}

+ (NSDictionary *(^)(NSDictionary *, UnderscoreDictionaryMapBlock))dictMap
{
    return ^(NSDictionary *dictionary, UnderscoreDictionaryMapBlock block) {
        return Underscore.dict(dictionary).map(block);
    };
}

+ (NSDictionary *(^)(NSDictionary *, NSArray *))pick
{
    return ^(NSDictionary *dictionary, NSArray *keys) {
        return [USDictionaryProxy wrap:dictionary].pick(keys);
    };
}

+ (NSDictionary *(^)(NSDictionary *, NSDictionary *))extend
{
    return ^(NSDictionary *dictionary, NSDictionary *source) {
        return [USDictionaryProxy wrap:dictionary].extend(source);
    };
}
+ (NSDictionary *(^)(NSDictionary *, NSDictionary *))defaults
{
    return ^(NSDictionary *dictionary, NSDictionary *defaults) {
        return [USDictionaryProxy wrap:dictionary].defaults(defaults);
    };
}

+ (NSDictionary *(^)(NSDictionary *, UnderscoreTestBlock))filterKeys
{
    return ^(NSDictionary *dictionary, UnderscoreTestBlock block) {
        return [USDictionaryProxy wrap:dictionary].filterKeys(block);
    };
}
+ (NSDictionary *(^)(NSDictionary *, UnderscoreTestBlock))filterValues
{
    return ^(NSDictionary *dictionary, UnderscoreTestBlock block) {
        return [USDictionaryProxy wrap:dictionary].filterValues(block);
    };
}

+ (NSDictionary *(^)(NSDictionary *, UnderscoreTestBlock))rejectKeys
{
    return ^(NSDictionary *dictionary, UnderscoreTestBlock block) {
        return [USDictionaryProxy wrap:dictionary].rejectKeys(block);
    };
}

+ (NSDictionary *(^)(NSDictionary *, UnderscoreTestBlock))rejectValues
{
    return ^(NSDictionary *dictionary, UnderscoreTestBlock block) {
        return [USDictionaryProxy wrap:dictionary].rejectValues(block);
    };
}

@end
