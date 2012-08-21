//
//  SenAsyncTestCase.m
//  AsyncSenTestingKit
//
//  Created by 小野 将司 on 12/03/17.
//  Copyright (c) 2012年 AppBankGames Inc. All rights reserved.
//

#import "SenAsyncTestCase.h"


@interface SenAsyncTestCase ()
@property (nonatomic, retain) NSDate *loopUntil;
@property (nonatomic, assign) BOOL notified;
@property (nonatomic, assign) SenAsyncTestCaseStatus notifiedStatus;
@property (nonatomic, assign) SenAsyncTestCaseStatus expectedStatus;
@end


@implementation SenAsyncTestCase


@synthesize loopUntil = _loopUntil;
@synthesize notified = _notified;
@synthesize notifiedStatus = _notifiedStatus;
@synthesize expectedStatus = _expectedStatus;


- (void)dealloc
{
    self.loopUntil = nil;
}


#pragma mark - Public


- (void)waitForStatus:(SenAsyncTestCaseStatus)status timeout:(NSTimeInterval)timeout
{
    self.notified = NO;
    self.expectedStatus = status;
    self.loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];

    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!self.notified && [self.loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }

    // Only assert when notified. Do not assert when timed out
    // Fail if not notified
    if (self.notified) {
        STAssertEquals(self.notifiedStatus, self.expectedStatus, @"Notified status does not match the expected status.");
    } else {
        STFail(@"Async test timed out.");
    }
}

- (void)waitForTimeout:(NSTimeInterval)timeout
{
    self.notified = NO;
    self.expectedStatus = SenAsyncTestCaseStatusUnknown;
    self.loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];

    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!self.notified && [self.loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
}

- (void)notify:(SenAsyncTestCaseStatus)status
{
    self.notifiedStatus = status;
    // self.notified must be set at the last of this method
    self.notified = YES;
}

@end