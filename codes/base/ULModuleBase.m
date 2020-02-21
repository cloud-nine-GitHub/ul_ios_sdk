//
//  ULModuleBase.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULModuleBase.h"
#import "ULIBase.h"
#import "ULSDKManager.h"
#import "ULILifeCycle.h"
#import "ULNotification.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"

@interface ULModuleBase ()<ULIBase>

@end

@implementation ULModuleBase


- (id)init
{
    if (self = [super init]) {
        [self onInitModule];
        [self setBaseListener];
        [self onResultChannelInfo:[ULSDKManager getBaseChannelInfo]];
    }
    return self;
}


- (void)setBaseListener
{
    //生命周期函数
    if ([self conformsToProtocol:@protocol(ULILifeCycle)]) {
        [self setLifeCycleListener];
    }
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_ONJSONAPI withSelector:@selector(onBaseJsonAPI:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_ONDISPOSEMODULE withSelector:@selector(onBaseDisposeModule:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_ONJSONRPCCALL withSelector:@selector(onBaseJsonRpcCall:) withPriority:PRIORITY_NONE];
    
}




- (void)setLifeCycleListener
{
    
    
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_APPLICATION_DID_RECEIVE_MEMORYWARNING withSelector:@selector(onApplicationDidReceiveMemoryWarning:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_APPLICATION_DID_ENTER_BACKGROUND withSelector:@selector(onApplicationDidEnterBackground:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_APPLICATION_WILL_RESIGN_ACTIVE withSelector:@selector(onApplicationWillResignActive:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_APPLICATION_DID_BECOME_ACTIVE withSelector:@selector(onApplicationDidBecomeActive:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_APPLICATION_DID_BECOME_ACTIVE withSelector:@selector(onApplicationWillTerminate:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_APPLICATION_WILL_ENTER_FOREGROUND withSelector:@selector(onApplicationWillEnterForeground:) withPriority:PRIORITY_NONE];
    
}


- (void)onBaseJsonAPI:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *data = userInfo[@"data"];
    [self onJsonAPI:data];
}

- (void)onBaseDisposeModule:(NSNotification *)notification
{
    [self onDisposeModule];
}


- (void)onBaseJsonRpcCall:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *data = userInfo[@"data"];
    [self onJsonRpcCall:data];
}


- (void)onApplicationWillResignActive:(NSNotification *)notification
{
    id<ULILifeCycle> lifeCycle = self;
    [lifeCycle applicationWillResignActive];
}

- (void)onApplicationDidEnterBackground:(NSNotification *)notification
{
    id<ULILifeCycle> lifeCycle = self;
    [lifeCycle applicationDidEnterBackground];
}

- (void)onApplicationWillEnterForeground:(NSNotification *)notification
{
    id<ULILifeCycle> lifeCycle = self;
    [lifeCycle applicationWillEnterForeground];
}

- (void)onApplicationDidBecomeActive:(NSNotification *)notification
{
    id<ULILifeCycle> lifeCycle = self;
    [lifeCycle applicationDidBecomeActive];
}

- (void)onApplicationWillTerminate:(NSNotification *)notification
{
    id<ULILifeCycle> lifeCycle = self;
    [lifeCycle applicationWillTerminate];
}

- (void)onApplicationDidReceiveMemoryWarning:(NSNotification *)notification
{
    id<ULILifeCycle> lifeCycle = self;
    [lifeCycle applicationDidReceiveMemoryWarning];
}

@end

