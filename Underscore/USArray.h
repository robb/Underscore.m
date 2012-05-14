//
//  USArray.h
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USConstants.h"

#define _array(array) [USArray wrap:array]

@interface USArray : NSObject

+ (USArray *)wrap:(NSArray *)array;

- (id)init __attribute__((deprecated("You should +[USArray wrap:] instead")));

@property (readonly) NSArray *unwrap;

@property (readonly) id first;
@property (readonly) id last;

@property (readonly) USArray *(^head)(NSUInteger n);
@property (readonly) USArray *(^tail)(NSUInteger n);

@property (readonly) USArray *flatten;
@property (readonly) USArray *(^without)(NSArray *values);

@property (readonly) USArray *shuffle;

@property (readonly) id (^reduce)(id memo, UnderscoreReduceBlock block);
@property (readonly) id (^reduceRight)(id memo, UnderscoreReduceBlock block);

@property (readonly) USArray *(^each)(UnderscoreArrayIteratorBlock block);
@property (readonly) USArray *(^map)(UnderscoreArrayMapBlock block);

@property (readonly) id (^find)(UnderscoreTestBlock block);

@property (readonly) USArray *(^filter)(UnderscoreTestBlock block);
@property (readonly) USArray *(^reject)(UnderscoreTestBlock block);

@property (readonly) BOOL (^all)(UnderscoreTestBlock block);
@property (readonly) BOOL (^any)(UnderscoreTestBlock block);

@end
