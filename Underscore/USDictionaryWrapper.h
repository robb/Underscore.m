//
//  USDictionaryWrapper.h
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USArrayWrapper.h"

#import "USConstants.h"

@interface USDictionaryWrapper : NSObject

#define _dict(dictionary) [USDictionaryWrapper wrap:dictionary]

+ (USDictionaryWrapper *)wrap:(NSDictionary *)dictionary;
- (NSDictionary *)unwrap;

- (id)init __attribute__((deprecated("You should +[USDictionaryWrapper wrap:] instead")));

@property (readonly) USArrayWrapper *keys;
@property (readonly) USArrayWrapper *values;

@property (readonly) USDictionaryWrapper *(^each)(UnderscoreDictionaryIteratorBlock block);
@property (readonly) USDictionaryWrapper *(^map)(UnderscoreDictionaryMapBlock block);

@property (readonly) USDictionaryWrapper *(^pick)(NSArray *keys);

@property (readonly) USDictionaryWrapper *(^extend)(NSDictionary *source);
@property (readonly) USDictionaryWrapper *(^defaults)(NSDictionary *defaults);

@property (readonly) USDictionaryWrapper *(^filterKeys)(UnderscoreTestBlock block);
@property (readonly) USDictionaryWrapper *(^filterValues)(UnderscoreTestBlock block);

@property (readonly) USDictionaryWrapper *(^rejectKeys)(UnderscoreTestBlock block);
@property (readonly) USDictionaryWrapper *(^rejectValues)(UnderscoreTestBlock block);

@end
