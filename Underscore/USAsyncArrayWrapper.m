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

- (void)enqueueBlock:(void (^)(void))block;

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
        [self enqueueBlock:^{
            callback(self.array);
        }];
    };
}


- (USAsyncArrayWrapper *(^)(NSUInteger))head;
{
    return ^USAsyncArrayWrapper *(NSUInteger n) {
        [self enqueueBlock:^{
            self.array = Underscore.array(self.array).head(n).unwrap;
        }];

        return self;
    };
}

- (USAsyncArrayWrapper *(^)(NSUInteger))tail;
{
    return ^USAsyncArrayWrapper *(NSUInteger n) {
        [self enqueueBlock:^{
            self.array = Underscore.array(self.array).tail(n).unwrap;
        }];

        return self;
    };
}

- (USAsyncArrayWrapper *(^)(UnderscoreArrayIteratorBlock))each;
{
    return ^USAsyncArrayWrapper *(UnderscoreArrayIteratorBlock block) {
        [self enqueueBlock:^{
            self.array = Underscore.array(self.array).each(block).unwrap;
        }];

        return self;
    };
}

- (USAsyncArrayWrapper *(^)(UnderscoreArrayMapBlock))map;
{
    return ^USAsyncArrayWrapper *(UnderscoreArrayMapBlock block) {
        [self enqueueBlock:^{
            self.array = Underscore.array(self.array).map(block).unwrap;
        }];

        return self;
    };
}

- (USAsyncArrayWrapper *(^)(NSString *))pluck;
{
    return ^USAsyncArrayWrapper *(NSString *keyPath) {
        [self enqueueBlock:^{
            self.array = Underscore.array(self.array).pluck(keyPath).unwrap;
        }];

        return self;
    };
}

- (void (^)(UnderscoreTestBlock, void (^)(id)))find;
{
    return ^(UnderscoreTestBlock block, void (^callback)(id)) {
        [self enqueueBlock:^{
            callback(Underscore.array(self.array).find(block));
        }];
    };
}

- (void (^)(UnderscoreTestBlock, void (^)(BOOL)))all;
{
    return ^(UnderscoreTestBlock block, void (^callback)(BOOL)) {
        [self enqueueBlock:^{
            callback(Underscore.array(self.array).all(block));
        }];
    };
}

- (void (^)(UnderscoreTestBlock, void (^)(BOOL)))any;
{
    return ^(UnderscoreTestBlock block, void (^callback)(BOOL)) {
        [self enqueueBlock:^{
            callback(Underscore.array(self.array).any(block));
        }];
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

- (void)enqueueBlock:(void (^)(void))block;
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:block];

    if (self.lastOperation) {
        [operation addDependency:self.lastOperation];
    }

    self.lastOperation = operation;

    [self.operationQueue addOperation:operation];
}

@end
