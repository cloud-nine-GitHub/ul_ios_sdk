//
//  ULUrlAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULUrlAdv.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULWebView.h"

@interface ULUrlAdv()<ULILifeCycle>


@end

@implementation ULUrlAdv





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
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_ULURL_URL_ADV withSelector:@selector(onShowUrlAdv:) withPriority:PRIORITY_NONE];
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
    [self setDisableAdvPriorityByArray:@[UL_ADV_SPLAH,UL_ADV_VIDEO,UL_ADV_BANNER,UL_ADV_EMBEDDED,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_EMBEDDED]];
}


- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

- (void)showInterstitialAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

- (void)showVideoAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

- (void)showFullscreenAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

- (void)showBannerAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
    
}

- (void)showUrlAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    //dispatch_async(dispatch_get_main_queue(), ^{
    NSString *url = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_h5_url" withDefaultString:@""];
    NSMutableDictionary *jsonData = [NSMutableDictionary new];
    [jsonData setValue:url forKey:@"url"];
    [ULWebView showWebView:jsonData];
    [self showAdv:json :@""];
    //});
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

