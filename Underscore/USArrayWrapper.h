//
//  USArrayWrapper.h
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USConstants.h"

#define _array(array) [USArrayWrapper wrap:array]

@interface USArrayWrapper : NSObject

+ (USArrayWrapper *)wrap:(NSArray *)array;

- (id)init __attribute__((deprecated("You should +[USArrayWrapper wrap:] instead")));

@property (readonly) NSArray *unwrap;

@property (readonly) id first;
@property (readonly) id last;

@property (readonly) USArrayWrapper *(^head)(NSUInteger n);
@property (readonly) USArrayWrapper *(^tail)(NSUInteger n);

@property (readonly) USArrayWrapper *flatten;
@property (readonly) USArrayWrapper *(^without)(NSArray *values);

@property (readonly) USArrayWrapper *shuffle;

@property (readonly) id (^reduce)(id memo, UnderscoreReduceBlock block);
@property (readonly) id (^reduceRight)(id memo, UnderscoreReduceBlock block);

@property (readonly) USArrayWrapper *(^each)(UnderscoreArrayIteratorBlock block);
@property (readonly) USArrayWrapper *(^map)(UnderscoreArrayMapBlock block);

@property (readonly) id (^find)(UnderscoreTestBlock block);

@property (readonly) USArrayWrapper *(^filter)(UnderscoreTestBlock block);
@property (readonly) USArrayWrapper *(^reject)(UnderscoreTestBlock block);

@property (readonly) BOOL (^all)(UnderscoreTestBlock block);
@property (readonly) BOOL (^any)(UnderscoreTestBlock block);

@end
