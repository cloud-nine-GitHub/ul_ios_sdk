//
//  ULPrivacyPolicy.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/2.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULPrivacyPolicy.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULTools.h"
#import "ULCop.h"
#import "ULConfig.h"
#import "PrivacyPolicyControllerViewController.h"
#import "ULUserDefaults.h"
#import "ULILifeCycle.h"

@interface ULPrivacyPolicy ()<ULILifeCycle>

@property (nonatomic,strong) PrivacyPolicyControllerViewController *controller;

@end

@implementation ULPrivacyPolicy

- (void)onInitModule
{
    NSLog(@"%s",__func__);
    [self addListener];
}




- (void) presentToController
{
    _controller = [PrivacyPolicyControllerViewController new];
    _controller.view.backgroundColor = [UIColor clearColor];
    //通过透明controller处理点击穿透问题
    if ([UIDevice currentDevice].systemVersion.intValue < 8) {
        //iOS8以下是设置rootViewController为ModalPresentationCurrentContext模式
        [self.controller setModalPresentationStyle:UIModalPresentationCurrentContext];
    }else{
        //iOS8或以上是设置要被present的viewController为ModalPresentationOverCurrentContext模式
        [self.controller setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    //self.controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [[ULTools getCurrentViewController] presentViewController:self.controller animated:YES completion:nil];
    
}

- (void) agreeOnClickEvent:(NSNotification *)notification
{
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    if (_controller) {
        [_controller agreeOnClickEvent];
    }
}

- (void) refuseOnClickEvent:(NSNotification *)notification
{
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    if (_controller) {
        [_controller refuseOnClickEvent];
    }
}

#pragma mark 数据存取

//获取用户同意隐私用户状态
- (BOOL) getPrivacyPolicyState
{
    id value = [ULUserDefaults readDataFromUserDefault:@"ulIsAgreePrivacyPolicy"];
    BOOL isAgreePrivacyPolicy = [value boolValue];
    return isAgreePrivacyPolicy;
}


//保存用户同意隐私政策状态
+ (void) savePrivacyPolicyState :(BOOL) isAgreePrivacyPolicy
{

    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:[NSNumber numberWithBool:isAgreePrivacyPolicy] forKey:@"ulIsAgreePrivacyPolicy"];
    [ULUserDefaults writeDataToUserDefault:dic];
}




- (void)onDisposeModule
{
    
    NSLog(@"%s",__func__);
}

- (void)addListener
{
    NSLog(@"%s",__func__);
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_PRIVACY_POLICY_AGREE_LISTENER withSelector:@selector(agreeOnClickEvent:) withPriority:PRIORITY_NONE];
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_PRIVACY_POLICY_REFUSE_LISTENER withSelector:@selector(refuseOnClickEvent:) withPriority:PRIORITY_NONE];
}

- (void)showPrivacyPolicy
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self getPrivacyPolicyState]) {
            [self presentToController];
        }else{
            NSLog(@"%s%@",__func__,@"该用户已同意隐私政策");
        }
        
    });
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    return nil;
}

- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo
{
    NSLog(@"%s",__func__);
    return nil;
}

- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr
{
    NSLog(@"%s",__func__);
    return nil;
}

- (void)applicationWillResignActive
{
    NSLog(@"%s",__func__);
}

- (void)applicationDidEnterBackground
{
    NSLog(@"%s",__func__);
}

- (void)applicationWillEnterForeground
{
    NSLog(@"%s",__func__);
}

- (void)applicationDidBecomeActive
{
    NSLog(@"%s",__func__);
}

- (void)applicationWillTerminate
{
    NSLog(@"%s",__func__);
}

- (void)applicationDidReceiveMemoryWarning
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    NSLog(@"%s",__func__);
    [self showPrivacyPolicy];
}

@end
