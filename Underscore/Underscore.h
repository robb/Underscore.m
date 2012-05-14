//
//  Underscore.h
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USConstants.h"
#import "USArray.h"
#import "USDictionary.h"

@interface Underscore : NSObject

+ (UnderscoreTestBlock(^)(UnderscoreTestBlock))negate;

+ (UnderscoreTestBlock)isNull;
+ (UnderscoreTestBlock)isNumber;
+ (UnderscoreTestBlock)isString;

@end