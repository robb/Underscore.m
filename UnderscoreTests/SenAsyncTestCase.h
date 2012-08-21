//
//  SenAsyncTestCase.h
//  AsyncSenTestingKit
//
//  Created by 小野 将司 on 12/03/17.
//  Copyright (c) 2012年 AppBankGames Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


enum {
    SenAsyncTestCaseStatusUnknown = 0,
    SenAsyncTestCaseStatusWaiting,
    SenAsyncTestCaseStatusSucceeded,
    SenAsyncTestCaseStatusFailed,
    SenAsyncTestCaseStatusCancelled,
};
typedef NSUInteger SenAsyncTestCaseStatus;


@interface SenAsyncTestCase : SenTestCase

- (void)waitForStatus:(SenAsyncTestCaseStatus)status timeout:(NSTimeInterval)timeout;
- (void)waitForTimeout:(NSTimeInterval)timeout;
- (void)notify:(SenAsyncTestCaseStatus)status;

@end