//
//  USConstants.h
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^UnderscoreTestBlock)(id obj);
typedef id   (^UnderscoreReduceBlock)(id memo, id obj);

typedef void (^UnderscoreArrayIteratorBlock)(id obj);
typedef id   (^UnderscoreArrayMapBlock)(id obj);

typedef void (^UnderscoreDictionaryIteratorBlock)(id key, id obj);
typedef id   (^UnderscoreDictionaryMapBlock)(id key, id obj);
