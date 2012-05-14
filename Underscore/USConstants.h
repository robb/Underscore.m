//
//  USConstants.h
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UnderscoreIteratorBlock)(id obj);
typedef id   (^UnderscoreMapBlock)(id obj);
typedef BOOL (^UnderscoreTestBlock)(id obj);
typedef id   (^UnderscoreReduceBlock)(id memo, id obj);
