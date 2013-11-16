//
//  USStringWrapper.h
//  Underscore
//
//  Created by Vasco d'Orey on 16/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "Underscore+Functional.h"
#import "USArrayWrapper.h"

@interface USStringWrapper : NSObject

+(instancetype) wrap:(NSString *)string;

-(id) init __deprecated_msg("You should use Underscore.string() instead.");

@property (readonly) NSString *unwrap;

@property (readonly) USStringWrapper *(^trim)();

@property (readonly) USStringWrapper *(^capitalize)();

@property (readonly) USStringWrapper *(^lowercase)();

@property (readonly) USStringWrapper *(^uppercase)();

@property (readonly) USArrayWrapper *(^split)(NSString *separator);

@end

@interface USArrayWrapper (USStrings)

@property (readonly) USStringWrapper *(^join)();

@end
