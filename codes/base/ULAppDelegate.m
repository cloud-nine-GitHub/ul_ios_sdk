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
#import "ZYNetworkAccessibity.h"

@implementation ULAppDelegate

+ (void)load{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSDK:) name:UL_NOTIFICATION_START_SDK object:nil];
    
}

//初始化sdk之前需要做一些处理
+ (void)startSDK:(NSNotification*) notification{
    NSLog(@"%s",__func__);
    
    //TODO 为确保applicationDidBecomeActive生命周期能被正常监听，初始化函数必须及早调用，用于每个模块创建对象时注册消息监听，不能放在网络回调中处理，在回调时上述生命周期已经被调用
    [ULConfig initConfigInfo];
    [ULSDKManager init];
    //网络权限处理
    //网络判断
    //    [ZYNetworkAccessibity setAlertEnable:YES];
    
    [ZYNetworkAccessibity setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        //ZYNetworkChecking
        //ZYNetworkUnknown
        //ZYNetworkAccessible 选择无限网和蜂窝时
        //ZYNetworkRestricted 弹出权限申请框or选择不允许or仅无限局域网
        NSString *desc = @"用户设置的不允许或仅限于无线网络";
        if(state == ZYNetworkAccessible){
            desc = @"当前应用网络权限可用";
        }
        NSLog(@"%s%@", __func__ ,desc);
        //1.获取应用网络权限 TODO 用户无论选择哪个选项都会进游戏
        //2.判断当前网络状况，进行无网提示 TODO
        
        [ULCop initCopInfo];
        
        
        [self startLogoView];
            
    }];
        
    [ZYNetworkAccessibity start:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    
    
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
