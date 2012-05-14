//
//  USArray.h
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^USArrayIteratorBlock)(id obj);
typedef id   (^USArrayMapBlock)(id obj);
typedef BOOL (^USArrayTestBlock)(id obj);
typedef id   (^USArrayReduceBlock)(id memo, id obj);

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

@property (readonly) id (^reduce)(id memo, USArrayReduceBlock block);
@property (readonly) id (^reduceRight)(id memo, USArrayReduceBlock block);

@property (readonly) USArray *(^each)(USArrayIteratorBlock block);
@property (readonly) USArray *(^map)(USArrayMapBlock block);

@property (readonly) id (^find)(USArrayTestBlock block);

@property (readonly) USArray *(^filter)(USArrayTestBlock block);
@property (readonly) USArray *(^reject)(USArrayTestBlock block);

@property (readonly) BOOL (^all)(USArrayTestBlock block);
@property (readonly) BOOL (^any)(USArrayTestBlock block);

@end
