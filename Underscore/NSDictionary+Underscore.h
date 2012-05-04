//
//  NSDictionary+Underscore.h
//  Underscore
//
//  Created by Robert Böhnke on 5/1/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UnderscoreDictionaryIteratorBlock)(id key, id obj);
typedef id   (^UnderscoreDictionaryMapBlock)(id key, id obj);
typedef BOOL (^UnderscoreDictionaryTestBlock)(id key, id obj);
typedef id   (^UnderscoreDictionaryReduceBlock)(id memo, id key, id obj);

@interface NSDictionary (Underscore)

- (NSDictionary *)__prune;

- (id)__reduce:(UnderscoreDictionaryReduceBlock)block intialValue:(id)memo;

- (void)__each:(UnderscoreDictionaryIteratorBlock)block;

- (NSDictionary *)__map:(UnderscoreDictionaryMapBlock)block;

- (id)__find:(UnderscoreDictionaryTestBlock)block;

- (NSArray *)__filter:(UnderscoreDictionaryTestBlock)block;
- (NSArray *)__reject:(UnderscoreDictionaryTestBlock)block;

- (BOOL)__all:(UnderscoreDictionaryTestBlock)block;
- (BOOL)__any:(UnderscoreDictionaryTestBlock)block;

@end
