//
//  USDictionary.h
//  Underscore
//
//  Created by Robert Böhnke on 5/7/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USArray.h"

@protocol USArray;

@protocol USDictionary <NSObject>

@property (readonly) NSArray<USArray> *keys;
@property (readonly) NSArray<USArray> *values;

@property (readonly) NSDictionary<USDictionary> *(^each)(UnderscoreDictionaryIteratorBlock block);
@property (readonly) NSDictionary<USDictionary> *(^map)(UnderscoreDictionaryMapBlock block);

@property (readonly) NSDictionary<USDictionary> *(^pick)(NSArray *keys);

@property (readonly) NSDictionary<USDictionary> *(^extend)(NSDictionary *source);
@property (readonly) NSDictionary<USDictionary> *(^defaults)(NSDictionary *defaults);

@property (readonly) NSDictionary<USDictionary> *(^filterKeys)(UnderscoreTestBlock block);
@property (readonly) NSDictionary<USDictionary> *(^filterValues)(UnderscoreTestBlock block);

@property (readonly) NSDictionary<USDictionary> *(^rejectKeys)(UnderscoreTestBlock block);
@property (readonly) NSDictionary<USDictionary> *(^rejectValues)(UnderscoreTestBlock block);

@end
