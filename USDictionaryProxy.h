//
//  USDictionaryProxy.h
//  Underscore
//
//  Created by Robert Böhnke on 5/7/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USDictionary.h"

@interface USDictionaryProxy : NSProxy <USDictionary>

+ (NSDictionary<USDictionary> *)wrap:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (readonly, copy) NSDictionary *dictionary;

@end
