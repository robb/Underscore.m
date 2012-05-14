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

+ (UnderscoreTestBlock)isNull;
{
    return ^BOOL (id obj) {
        return [obj isKindOfClass:[NSNull class]];
    };
}

+ (UnderscoreTestBlock)isNumber;
{
    return ^BOOL (id obj) {
        return [obj isKindOfClass:[NSNumber class]];
    };
}

+ (UnderscoreTestBlock)isString;
{
    return ^BOOL (id obj) {
        return [obj isKindOfClass:[NSString class]];
    };
}

- (id)init;
{
    return [super init];
}

@end
