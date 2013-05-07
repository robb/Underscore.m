//
//  USArrayProxy.h
//  Underscore
//
//  Created by Robert Böhnke on 5/7/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USArray.h"

@interface USArrayProxy : NSProxy <USArray>

+ (NSArray<USArray> *)wrap:(NSArray *)array;

- (id)initWithArray:(NSArray *)array;

@property (readonly, copy) NSArray *array;

@end
