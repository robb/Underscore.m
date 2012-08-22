//
//  USAsyncArrayWrapper.m
//  Underscore
//
//  Created by Robert Böhnke on 8/21/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

#import "USAsyncArrayWrapper.h"

@interface USAsyncArrayWrapper ()

@property (readwrite) NSOperationQueue *operationQueue;
@property (readwrite) NSOperation *lastOperation;

@property (readwrite) NSArray *operations;
@property (readwrite) NSArray *array;

- (void)enqueueOperation:(NSOperation *)operation inQueue:(NSOperationQueue *)queue;

@end

@implementation USAsyncArrayWrapper

- (id)init;
{
    return [super init];
}

- (USAsyncArrayWrapper *)initWithArray:(NSArray *)array queue:(NSOperationQueue *)queue;
{
    self = [super init];
    if (self) {
        self.operationQueue = queue;
        self.array = array;
    }
    return self;
}

- (void (^)(void (^)(NSArray *)))unwrap;
{
    return ^(void (^callback)(NSArray *)) {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            callback(self.array);
        }];

        [self enqueueOperation:operation];
    };
}


- (USAsyncArrayWrapper *(^)(NSUInteger))head;
{
    return ^USAsyncArrayWrapper *(NSUInteger n) {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            self.array = Underscore.array(self.array).head(n).unwrap;
        }];

        [self enqueueOperation:operation];

        return self;
    };
}

- (USAsyncArrayWrapper *(^)(NSUInteger))tail;
{
    return ^USAsyncArrayWrapper *(NSUInteger n) {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            self.array = Underscore.array(self.array).tail(n).unwrap;
        }];

        [self enqueueOperation:operation];

        return self;
    };
}

- (USAsyncArrayWrapper *(^)(UnderscoreArrayIteratorBlock block))each;
{
    return ^USAsyncArrayWrapper *(UnderscoreArrayIteratorBlock block) {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            self.array = Underscore.array(self.array).each(block).unwrap;
        }];

        [self enqueueOperation:operation];

        return self;
    };
}

- (void (^)(UnderscoreTestBlock, void (^)(BOOL)))all;
{
    return ^(UnderscoreTestBlock block, void (^callback)(BOOL)) {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            callback(Underscore.array(self.array).all(block));
        }];

        [self enqueueOperation:operation];
    };
}

- (void (^)(UnderscoreTestBlock, void (^)(BOOL)))any;
{
    return ^(UnderscoreTestBlock block, void (^callback)(BOOL)) {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            callback(Underscore.array(self.array).any(block));
        }];

        [self enqueueOperation:operation];
    };
}

- (USAsyncArrayWrapper *(^)(NSOperationQueue *))on;
{
    return ^USAsyncArrayWrapper *(NSOperationQueue *queue) {
        self.operationQueue = queue;
        return self;
    };
}

#pragma mark - Private

- (void)enqueueOperation:(NSOperation *)operation;
{
    if (self.lastOperation) {
        [operation addDependency:self.lastOperation];
    }

    self.lastOperation = operation;

    [self.operationQueue addOperation:operation];
}

@end
