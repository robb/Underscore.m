//
//  Underscore.m
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import "Underscore.h"

@implementation Underscore

+ (UnderscoreTestBlock (^)(UnderscoreTestBlock))negate;
{
    return ^UnderscoreTestBlock (UnderscoreTestBlock test) {
        return ^BOOL (id obj) {
            return !test(obj);
        };
    };
}

@end
