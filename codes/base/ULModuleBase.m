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

@interface ULModuleBase ()<ULIBase>

@end

@implementation ULModuleBase


- (id)init
{
    if (self = [super init]) {
        [self onInitModule];
        [self setBaseListener];
        [self onResultChannelInfo:baseChannelInfo];
    }
    return self;
}


- (void)setBaseListener
{
    //生命周期函数
    if ([self conformsToProtocol:@protocol(ULILifeCycle)]) {
        [self setLifeCycleListener];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBaseJsonAPI:) name:UL_NOTIFICATION_ONJSONAPI object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBaseDisposeModule:) name:UL_NOTIFICATION_ONDISPOSEMODULE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBaseJsonRpcCall:) name:UL_NOTIFICATION_ONJSONRPCCALL object:nil];
}




- (void)setLifeCycleListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidReceiveMemoryWarning:) name:UL_NOTIFICATION_APPLICATION_DID_RECEIVE_MEMORYWARNING object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidEnterBackground:) name:UL_NOTIFICATION_APPLICATION_DID_ENTER_BACKGROUND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive:) name:UL_NOTIFICATION_APPLICATION_WILL_RESIGN_ACTIVE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActive:) name:UL_NOTIFICATION_APPLICATION_DID_BECOME_ACTIVE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillTerminate:) name:UL_NOTIFICATION_APPLICATION_WILL_TERMINATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillEnterForeground:) name:UL_NOTIFICATION_APPLICATION_WILL_ENTER_FOREGROUND object:nil];
}


- (void)onBaseJsonAPI:(NSNotification *)notification
{
    NSString *data = [ULTools DictionaryToString:notification.userInfo];
    [self onJsonAPI:data];
}

- (void)onBaseDisposeModule:(NSNotification *)notification
{
    [self onDisposeModule];
}


- (void)onBaseJsonRpcCall:(NSNotification *)notification
{
    NSString *data = [ULTools DictionaryToString:notification.userInfo];
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

