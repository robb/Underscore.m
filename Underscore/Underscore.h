//
//  Underscore.h
//  Underscore
//
//  Created by Robert Böhnke on 4/29/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USConstants.h"
#import "USArrayWrapper.h"
#import "USDictionaryWrapper.h"

@interface Underscore : NSObject

+ (UnderscoreTestBlock(^)(UnderscoreTestBlock))negate;
+ (UnderscoreTestBlock(^)(id obj))isEqual;

+ (UnderscoreTestBlock)isArray;
+ (UnderscoreTestBlock)isDictionary;
+ (UnderscoreTestBlock)isNull;
+ (UnderscoreTestBlock)isNumber;
+ (UnderscoreTestBlock)isString;

- (id)init __deprecated;

@end