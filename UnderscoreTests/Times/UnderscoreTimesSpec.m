//
//  UnderscoreTimesSpec.m
//  Underscore
//
//  Created by akitsukada on 2015/03/21.
//  Copyright (c) 2015年 Robert Böhnke. All rights reserved.
//

#import "Underscore+Times.h"

SpecBegin(UnderscoreTimes)

describe(@"times", ^{
    context(@"when positive number given", ^{
        it(@"should call given block specified times", ^{
            NSInteger __block count = 0;
            NSInteger times = 10;
            Underscore.times(times, ^(NSUInteger n){
                count++;
            });
            expect(count).to.equal(times);
        });
    });

    context(@"when negative number given", ^{
        it(@"should not call given block", ^{
            NSInteger __block count = 0;
            NSInteger times = -1;
            Underscore.times(times, ^(NSUInteger n){
                count++;
            });
            expect(count).to.equal(0);
        });
    });
});

SpecEnd

