//
//  USArray.h
//  Underscore
//
//  Created by Robert Böhnke on 5/7/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Underscore.h"

@protocol USArray <NSObject>

@property (readonly) id first;
@property (readonly) id last;

@property (readonly) NSArray<USArray> *(^head)(NSUInteger n);
@property (readonly) NSArray<USArray> *(^tail)(NSUInteger n);

@property (readonly) NSUInteger (^indexOf)(id obj);

@property (readonly) NSArray<USArray> *flatten;
@property (readonly) NSArray<USArray> *(^without)(NSArray *values);

@property (readonly) NSArray<USArray> *shuffle;

@property (readonly) id (^reduce)(id memo, UnderscoreReduceBlock block);
@property (readonly) id (^reduceRight)(id memo, UnderscoreReduceBlock block);

@property (readonly) NSArray<USArray> *(^each)(UnderscoreArrayIteratorBlock block);
@property (readonly) NSArray<USArray> *(^map)(UnderscoreArrayMapBlock block);

@property (readonly) NSArray<USArray> *(^pluck)(NSString *keyPath);

@property (readonly) NSArray<USArray> *uniq;

@property (readonly) id (^find)(UnderscoreTestBlock block);

@property (readonly) NSArray<USArray> *(^filter)(UnderscoreTestBlock block);
@property (readonly) NSArray<USArray> *(^reject)(UnderscoreTestBlock block);

@property (readonly) BOOL (^all)(UnderscoreTestBlock block);
@property (readonly) BOOL (^any)(UnderscoreTestBlock block);

@property (readonly) NSArray<USArray> *(^sort)(UnderscoreSortBlock block);

@end
