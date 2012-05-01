//
//  NSArray+Underscore.h
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

typedef void (^UnderscoreArrayIteratorBlock)(id obj);
typedef id   (^UnderscoreArrayMapBlock)(id obj);
typedef BOOL (^UnderscoreArrayTestBlock)(id obj);

@interface NSArray (Underscore)

# pragma mark - Array specific

+ __from:(NSInteger)start to:(NSInteger)end;
+ __from:(NSInteger)start to:(NSInteger)end step:(NSInteger)step;

- (id)__first;
- (id)__last;

- (NSArray *)__head:(NSUInteger)count;
- (NSArray *)__tail:(NSUInteger)count;

- (NSArray *)__flatten;

- (NSArray *)__without:(NSArray *)values;

- (NSArray *)__shuffle;

# pragma mark - NSDictionay and NSArray

- (void)__each:(UnderscoreArrayIteratorBlock)block;

- (NSArray *)__map:(UnderscoreArrayMapBlock)block;

- (id)__find:(UnderscoreArrayTestBlock)block;

- (NSArray *)__filter:(UnderscoreArrayTestBlock)block;
- (NSArray *)__reject:(UnderscoreArrayTestBlock)block;

- (BOOL)__all:(UnderscoreArrayTestBlock)block;
- (BOOL)__any:(UnderscoreArrayTestBlock)block;

@end
