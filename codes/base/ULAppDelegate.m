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

static BOOL appStartFlag = FALSE;

+ (void)load{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSDK:) name:UL_NOTIFICATION_START_SDK object:nil];
    
}

//初始化sdk之前需要做一些处理
+ (void)startSDK:(NSNotification*) notification{
    NSLog(@"%s",__func__);
    // 将下面C函数的函数地址当做参数
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
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
        
        //3.TODO 网络状态改变会导致多次回调，同一次启动后续的回调都不能影响启动流程
        if(!appStartFlag){
            appStartFlag = TRUE;
            [ULCop initCopInfo];
            
            
            [self startLogoView];
        }
        //TODO 这儿存在回调问题，如果没有回调那么可能会影响进入游戏
    }];
    
    [ZYNetworkAccessibity start:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    
    
}

// 设置一个C函数，用来接收崩溃信息
  void UncaughtExceptionHandler(NSException *exception){
      // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
      NSArray *symbols = [exception callStackSymbols];
      NSString *reason = [exception reason];
      NSString *name = [exception name];
      NSLog(@"%s,symbols:%@/nreason:%@/nname:%@",__func__,symbols,reason,name);
  }


+ (void)startLogoView{
    
    
    
    
    //在这里手动创建新的window
    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].delegate.window = window;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    ULLogoViewController *view = [[ULLogoViewController alloc] init];
    [window setRootViewController:view];

}



@end
