//
//  USAsyncArrayWrapper.h
//  Underscore
//
//  Created by Robert Böhnke on 8/21/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USConstants.h"

@interface USAsyncArrayWrapper : NSObject

- (id)init __attribute__((deprecated("You should Underscore.array() instead")));

- (NSArray *)unwrap;

- (void (^)(UnderscoreCallbackBlock(id result)))first;
- (void (^)(UnderscoreCallbackBlock(id result)))last;

- (USAsyncArrayWrapper *(^)(NSUInteger n))head;
- (USAsyncArrayWrapper *(^)(NSUInteger n))tail;

- (void (^)(id obj, UnderscoreCallbackBlock(NSUInteger index)))indexOf;

- (USAsyncArrayWrapper *)flatten;
- (USAsyncArrayWrapper *(^)(NSArray *value))without;

- (USAsyncArrayWrapper *)shuffle;

- (void (^)(id, UnderscoreReduceBlock block, UnderscoreCallbackBlock(id result)))reduce;
- (void (^)(id, UnderscoreReduceBlock block, UnderscoreCallbackBlock(id result)))reduceRight;

- (USAsyncArrayWrapper *(^)(UnderscoreArrayIteratorBlock block))each;
- (USAsyncArrayWrapper *(^)(UnderscoreArrayMapBlock block))map;

- (USAsyncArrayWrapper *(^)(NSString *keyPath))pluck;

- (void (^)(UnderscoreTestBlock block, UnderscoreCallbackBlock(id result)))find;

- (USAsyncArrayWrapper *(^)(UnderscoreTestBlock block))filter;
- (USAsyncArrayWrapper *(^)(UnderscoreTestBlock block))reject;

- (void (^)(UnderscoreTestBlock block, UnderscoreCallbackBlock(BOOL result)))all;
- (void (^)(UnderscoreTestBlock block, UnderscoreCallbackBlock(BOOL result)))any;

- (USAsyncArrayWrapper *(^)(NSOperationQueue *))on;

@end
