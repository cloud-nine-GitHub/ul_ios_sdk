//
//  ULSdkReflecter.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/10/30.
//  Copyright © 2019 ul_mac04. All rights reserved.
//


/**
 中间件，源文件成熟后封装成framework提供给游戏直接引入
 */

#import "ULSdkReflecter.h"


static NSString *const SDK_MANAGER_CLASS_NAME = @"ULSDKManager";
static NSString *const APPLICATION_DID_ENTER_BACKGROUND = @"applicationDidEnterBackground";
static NSString *const APPLICATION_WILL_ENTER_FOREGROUND = @"applicationWillEnterForeground";
static NSString *const APPLICATION_DID_BECOME_ACTIVE = @"applicationDidBecomeActive";
static NSString *const APPLICATION_WILL_RESIGN_ACTIVE = @"applicationWillResignActive";
static NSString *const APPLICATION_DID_RECEIVE_MEMORY_WARNING = @"applicationDidReceiveMemoryWarning";
static NSString *const APPLICATION_WILL_TERMINATE = @"applicationWillTerminate";
static NSString *const SDK_MANAGER_CLASS_METHOD_JSONAPI = @"JsonAPI:";//有参数需要添加：不然无法判断是否存在该方法
static NSString *const SDK_MANAGER_CLASS_METHOD_INIT = @"init";
static NSString *const VIEWCONTROLLER_LIFECYCLE_VIEWDIDLOAD = @"viewDidLoad";

@implementation ULSdkReflecter

//系统方法,在文件加载过程调用
+ (void)load{
    NSLog(@"%s",__func__);
    /**监听系统消息*/
    //ios13如果使用分屏那么启动生命周期的函数将不是UIApplicationDidFinishLaunchingNotification而是UISceneWillConnectNotification
    if (@available(iOS 13.0, *)) {
        //解析工程info.plist文件，判断是否使用分屏特性
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
        NSString *string = [infoDict objectForKey:@"UIApplicationSceneManifest"];
        if (string) {//使用分屏特性
            __block id observerWillConnectNotification =
            [[NSNotificationCenter defaultCenter] addObserverForName:UISceneWillConnectNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                
                //这里先去处理sdk的初始化：
                id sdkManagerClass = NSClassFromString(SDK_MANAGER_CLASS_NAME);
                if(sdkManagerClass == nil){
                    //没有sdkmanager，直接启动游戏app
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startGame" object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startSdk" object:nil];
                }
                
                /** 完成操作后销毁通知的监听 */
                [[NSNotificationCenter defaultCenter] removeObserver:observerWillConnectNotification];
            }];
        }else{//不使用分屏特性
            __block id observerDidFinishLaunching =
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                
                //这里先去处理sdk的初始化：
                id sdkManagerClass = NSClassFromString(SDK_MANAGER_CLASS_NAME);
                if(sdkManagerClass == nil){
                    //没有sdkmanager，直接启动游戏app
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startGame" object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startSdk" object:nil];
                }
                
                /** 完成操作后销毁通知的监听 */
                [[NSNotificationCenter defaultCenter] removeObserver:observerDidFinishLaunching];
            }];
        }
        
        
        
    }else{
        __block id observerDidFinishLaunching =
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            //这里先去处理sdk的初始化：
            id sdkManagerClass = NSClassFromString(SDK_MANAGER_CLASS_NAME);
            if(sdkManagerClass == nil){
                //没有sdkmanager，直接启动游戏app
                [[NSNotificationCenter defaultCenter] postNotificationName:@"startGame" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"startSdk" object:nil];
            }
            
            /** 完成操作后销毁通知的监听 */
            [[NSNotificationCenter defaultCenter] removeObserver:observerDidFinishLaunching];
        }];
    }
    
    
    //下列生命周期存在多次调用可能，所以未在调用后就移除消息
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self applicationDidEnterBackground];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [self applicationWillEnterForeground];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [self applicationDidBecomeActive];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [self applicationWillResignActive];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [self applicationDidReceiveMemoryWarning];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        [self applicationWillTerminate];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLoad:) name:@"main_vc_viewDidLoad" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request:) name:@"request" object:nil];
    
}

+ (void)viewDidLoad :(NSNotification *)notification{
    NSLog(@"%s",__func__);
    [self invokeMethod:VIEWCONTROLLER_LIFECYCLE_VIEWDIDLOAD];
}

+ (void)request :(NSNotification *)notification{
    NSLog(@"%s",__func__);
    NSString *requestStr = notification.userInfo[@"requestStr"];
    [self invokeMethod:SDK_MANAGER_CLASS_METHOD_JSONAPI withParam:requestStr];
}

+ (void)init :(NSNotification *)notification{
    NSLog(@"%s",__func__);
    [self invokeMethod:SDK_MANAGER_CLASS_METHOD_INIT];
}


//生命周期函数
+ (void)applicationWillResignActive {
    NSLog(@"%s",__func__);
    [self invokeMethod:APPLICATION_WILL_RESIGN_ACTIVE];
}

+ (void)applicationDidEnterBackground {
    NSLog(@"%s",__func__);
    [self invokeMethod:APPLICATION_DID_ENTER_BACKGROUND];
}


+ (void)applicationWillEnterForeground {
    NSLog(@"%s",__func__);
    [self invokeMethod:APPLICATION_WILL_ENTER_FOREGROUND];
}

+ (void)applicationDidBecomeActive {
    NSLog(@"%s",__func__);
    [self invokeMethod:APPLICATION_DID_BECOME_ACTIVE];
}


+ (void)applicationWillTerminate {
    NSLog(@"%s",__func__);
    [self invokeMethod:APPLICATION_WILL_TERMINATE];
}

+ (void)applicationDidReceiveMemoryWarning {
    NSLog(@"%s",__func__);
    [self invokeMethod:APPLICATION_DID_RECEIVE_MEMORY_WARNING];
}


+ (void)invokeMethod:(NSString *)methodName
{
    Class class = NSClassFromString(SDK_MANAGER_CLASS_NAME);
    if (class != nil) {
        SEL sel = NSSelectorFromString(methodName);
        if([class respondsToSelector:sel])
        {
            IMP imp = [class methodForSelector:sel];
            void (*func)(Class, SEL) = (void (*)(Class,SEL))imp;
            func(class,sel);
            
        }else{
            NSLog(@"%s:%@[%@]%@",__func__,@"no ",methodName,@" method in sdk manager class");
        }
    }else{
        NSLog(@"%s:%@",__func__,@"no sdk manager class");
    }
}


+ (void)invokeMethod:(NSString *)methodName withParam:(id)param
{
    Class class = NSClassFromString(SDK_MANAGER_CLASS_NAME);
    if (class != nil) {
        SEL sel = NSSelectorFromString(methodName);
        if([class respondsToSelector:sel])
        {
            IMP imp = [class methodForSelector:sel];
            void (*func)(Class, SEL, id) = (void (*)(Class,SEL,id))imp;
            func(class,sel,param);
        }else{
            NSLog(@"%s:%@[%@]%@",__func__,@"no ",methodName,@" method in sdk manager class");
        }
    }else{
        NSLog(@"%s:%@",__func__,@"no sdk manager class");
    }
}


@end
