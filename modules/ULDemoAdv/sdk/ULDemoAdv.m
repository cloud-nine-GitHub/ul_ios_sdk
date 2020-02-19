//
//  ULDemoAdv.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/13.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULDemoAdv.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULSplashViewController.h"

@interface ULDemoAdv()<ULILifeCycle>


@end

@implementation ULDemoAdv





- (void)onInitModule
{
    NSLog(@"%s",__func__);
    
}


- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}

- (void)addListener
{
    NSLog(@"%s",__func__);
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_DEMO_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_DEMO_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_DEMO_FULLSCREEN_ADV withSelector:@selector(onShowFullscreenAdv:) withPriority:PRIORITY_NONE];
    
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_DEMO_BANNER_ADV withSelector:@selector(onShowBannerAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_DEMO_URL_ADV withSelector:@selector(onShowUrlAdv:) withPriority:PRIORITY_NONE];
}

- (void)onShowInterAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showInterstitialAdv:data];
}

- (void)onShowVideoAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showVideoAdv:data];
}

- (void)onShowFullscreenAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showFullscreenAdv:data];
}

- (void)onShowBannerAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showBannerAdv:data];
}

- (void)onShowUrlAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showUrlAdv:data];
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




- (void)applicationDidBecomeActive {
    NSLog(@"%s",__func__);
}

- (void)applicationDidEnterBackground {
    NSLog(@"%s",__func__);
}

- (void)applicationDidReceiveMemoryWarning {
    NSLog(@"%s",__func__);
}

- (void)applicationWillEnterForeground {
    NSLog(@"%s",__func__);
}

- (void)applicationWillResignActive {
    NSLog(@"%s",__func__);
}

- (void)applicationWillTerminate {
    NSLog(@"%s",__func__);
}



- (void)initModuleAdv
{
    NSLog(@"%s",__func__);
    [self addListener];
}

- (void)onConstructorAdv
{
    
    NSLog(@"%s",__func__);
    [self setDisableAdvPriority:UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_EMBEDDED];
}


- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemoAdv开屏广告展示" withBtnOneText:@"模拟开屏广告展示成功" withBtnTwoText:@"模拟开屏广告展示失败" withBtnThreeText:@"模拟开屏广告点击" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示成功");
        //[self showAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULSplashViewController getInstance]removeSplashView];
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示失败");
        [self showNextAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"广告点击");
        //[self showClicked:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        //[self showAdv:json];
    }];
}

- (void)showInterstitialAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemoAdv插屏广告展示" withBtnOneText:@"模拟插屏广告展示成功" withBtnTwoText:@"模拟插屏广告展示失败" withBtnThreeText:@"模拟插屏广告点击" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示成功");
        [self showAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示失败");
        [self showNextAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"广告点击");
        [self showClicked:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [self showAdv:json];
    }];
}

- (void)showVideoAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemoAdv视频广告展示" withBtnOneText:@"模拟视频广告展示成功" withBtnTwoText:@"模拟视频广告展示失败" withBtnThreeText:@"模拟视频广告点击" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示成功");
        [self showAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [self showClose:json];
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示失败");
        [self showNextAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"广告点击");
        [self showClicked:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        //[self showAdv:json];
    }];
}

- (void)showFullscreenAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemoAdv全屏视频广告展示" withBtnOneText:@"模拟全屏视频广告展示成功" withBtnTwoText:@"模拟全屏视频广告展示失败" withBtnThreeText:@"模拟全屏视频广告点击" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示成功");
        [self showAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示失败");
        [self showNextAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"广告点击");
        [self showClicked:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [self showAdv:json];
    }];
}

- (void)showBannerAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemoAdv横幅广告展示" withBtnOneText:@"模拟横幅广告展示成功" withBtnTwoText:@"模拟横幅广告展示失败" withBtnThreeText:@"模拟横幅广告点击" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示成功");
        [self showAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示失败");
        [self showNextAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"广告点击");
        [self showClicked:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [self showAdv:json];
    }];
    
}

- (void)showUrlAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemoAdv互动广告展示" withBtnOneText:@"模拟互动广告展示成功" withBtnTwoText:@"模拟互动广告展示失败" withBtnThreeText:@"互动广告无法点击" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示成功");
        [self showAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"展示失败");
        [self showNextAdv:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"广告点击");
        //[self showClicked:json];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    }];
    
}

- (void)showEmbeddedAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

- (void)showGiftAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showIconAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)closeAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

@end
