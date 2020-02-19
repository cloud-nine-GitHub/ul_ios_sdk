//
//  ULAppDelegate.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/10/30.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULAppDelegate.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULNotification.h"
#import "ULLogoViewController.h"
#import "ULSDKManager.h"

@implementation ULAppDelegate

+ (void)load{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSDK:) name:UL_NOTIFICATION_START_SDK object:nil];
    
}

//初始化sdk之前需要做一些处理
+ (void)startSDK:(NSNotification*) notification{
    NSLog(@"%s",__func__);
    
    [ULConfig initConfigInfo];
    
    [ULCop initCopInfo];
    
    //在启动viewController相关之前先初始化模块。TODO 提前初始化的目的只有一个，那就是确保applicationDidBecomeActive生命周期能被正常监听
    [ULSDKManager init];
    
    [self startLogoView];
}



+ (void)startLogoView{
    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].delegate.window = window;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    ULLogoViewController *view = [[ULLogoViewController alloc] init];
    [window setRootViewController:view];
}



@end
