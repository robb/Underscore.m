//
//  USStringWrapper.m
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

#import "USStringWrapper.h"

@interface USStringWrapper ()
-(id) initWithString:(NSString *)string;
@property (readwrite, retain) NSString *string;
@end

@implementation USStringWrapper

#pragma mark - Class Methods

+ (instancetype)wrap:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

#pragma mark - Lifecycle

- (id)init
{
    return [super init];
}

- (id)initWithString:(NSString *)string
{
    if((self = [super init])) {
        _string = string;
    }
    return self;
}

- (NSString *)unwrap
{
    return [self.string copy];
}

#pragma mark - Underscore (Strings) Methods

- (USStringWrapper *(^)())trim
{
    return ^USStringWrapper *() {
        NSString *final = [self.string hasPrefix:@" "] ? [self.string substringFromIndex:1] : self.string;
        final = [final hasSuffix:@" "] ? [final substringToIndex:final.length - 1] : final;
        return [USStringWrapper wrap:final];
    };
}

- (USStringWrapper *(^)())capitalize
{
    return ^USStringWrapper *() {
        NSString *capitalized = [self.string capitalizedString];
        return [USStringWrapper wrap:capitalized];
    };
}

- (USStringWrapper *(^)())lowercase
{
    return ^USStringWrapper *() {
        return [USStringWrapper wrap:self.string.lowercaseString];
    };
}

- (USStringWrapper *(^)())uppercase
{
    return ^USStringWrapper *() {
        return [USStringWrapper wrap:self.string.uppercaseString];
    };
}

- (USArrayWrapper *(^)())split
{
    return ^USArrayWrapper *() {
        return self.splitAt(@" ");
    };
}

- (USArrayWrapper *(^)(NSString *))splitAt
{
    return ^USArrayWrapper *(NSString *separator) {
        return Underscore.array([self.string componentsSeparatedByString:separator]);
    };
}

@end

@implementation USArrayWrapper (USStrings)

- (USStringWrapper *(^)())join
{
    return ^USStringWrapper *() {
        return [USStringWrapper wrap:[self.unwrap componentsJoinedByString:@" "]];
    };
}

@end
