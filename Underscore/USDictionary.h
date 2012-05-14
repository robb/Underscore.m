//
//  USDictionary.h
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USArray.h"

#import "USConstants.h"

@interface USDictionary : NSObject

#define _dict(dictionary) [USDictionary wrap:dictionary]

+ (USDictionary *)wrap:(NSDictionary *)dictionary;
- (NSDictionary *)unwrap;

- (id)init __attribute__((deprecated("You should +[USDictionary wrap:] instead")));

@property (readonly) USArray *keys;
@property (readonly) USArray *values;

@property (readonly) USDictionary *(^each)(UnderscoreDictionaryIteratorBlock block);
@property (readonly) USDictionary *(^map)(UnderscoreDictionaryMapBlock block);

@property (readonly) USDictionary *(^pick)(NSArray *keys);

@property (readonly) USDictionary *(^extend)(NSDictionary *source);
@property (readonly) USDictionary *(^defaults)(NSDictionary *defaults);

@property (readonly) USDictionary *(^filterKeys)(UnderscoreTestBlock block);
@property (readonly) USDictionary *(^filterValues)(UnderscoreTestBlock block);

@property (readonly) USDictionary *(^rejectKeys)(UnderscoreTestBlock block);
@property (readonly) USDictionary *(^rejectValues)(UnderscoreTestBlock block);

@end
