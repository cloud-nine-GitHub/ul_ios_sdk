//
//  ULSplashViewController.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/26.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import "ULSplashViewController.h"
#import "ULNotification.h"
#import "ULTools.h"
#import "ULSDKManager.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULStringConst.h"

@interface ULSplashViewController ()

@end

@implementation ULSplashViewController

{
    NSString *_mainViewControllerName;
}

static ULSplashViewController* instance=nil;



+ (instancetype)getInstance{
    if(!instance){
        instance = [[self alloc] init];
    }
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s",__func__);
    //    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    [UIApplication sharedApplication].delegate.window = window;
    //    window.backgroundColor = [UIColor whiteColor];
    //    [window makeKeyAndVisible];
    //    [window setRootViewController:self];
    
    //TODO 开屏横转竖功能是否保留
    
    //TODO 是否设置开屏底图
    //是否读cop配置
    NSString *isUseCop = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_close_cop" :@"0"];
    if ([isUseCop isEqualToString:@"1"]) {
        //不读cop也需要初始化广告,不然本地配置将失效,如果确实有不展示广告的需求那么广告列表不配置即可
        [ULSDKManager initAdv];
    }
    [self showSplashAdv];
}



- (void)showSplashAdv
{
    NSString *splashSwitch = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_sdk_adv_close_splash" :@"1"];
    if ([splashSwitch isEqualToString:@"1"]) {
        [self removeSplashView];
    }else{
        NSMutableDictionary *data = [NSMutableDictionary new];
        [data setValue:S_CONST_ADV_SPLASH_ADVID_DES forKey:@"advId"];
        [data setValue:@"{}" forKey:@"userData"];
        [ULSDKManager openAdv:data];
    }
}


- (void)removeSplashView
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *mainController = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_common_main_controller" :@""];
//        if ([mainController isEqualToString:@""]) {
//            NSLog(@"%s%@",__func__,@"main controll 属于必配置项，请检查相关配置");
//            return;
//        }
//        //这里需要重新设置游戏所在的viewControoler
//
//        UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        [UIApplication sharedApplication].delegate.window = window;
//        window.backgroundColor = [UIColor whiteColor];
//        [window makeKeyAndVisible];
//        id controller = [[NSClassFromString(mainController) alloc]init];
//        [window setRootViewController:controller];
        //这里只需要发送启动消息即可，无需创建应用的vc
        [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_START_GAME object:nil];
        
        
    });
}

@end
