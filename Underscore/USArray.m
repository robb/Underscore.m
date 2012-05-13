//
//  USArray.m
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "USArray.h"

@interface USArray ()

- initWithArray:(NSArray *)array;

@property (readwrite, copy) NSArray *array;

@end

@implementation USArray

+ (USArray *)wrap:(NSArray *)array;
{
    return [[USArray alloc] initWithArray:array];
}

- (id)initWithArray:(NSArray *)array;
{
    if (self = [super init]) {
        self.array = array;
    }
    return self;
}

@synthesize array = _array;

- (id (^)(void))first;
{
    return ^id (void){
        return self.array.count ? [self.array objectAtIndex:0] : nil;
    };
}

@end
