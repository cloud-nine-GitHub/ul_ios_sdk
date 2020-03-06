//
//  ULYomobAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/6.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULYomobAdv.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULGetDeviceId.h"
#import "ULCmd.h"
#import "TGSDK.h"



@interface ULYomobAdv ()<TGPreloadADDelegate, TGADDelegate>

@property (nonatomic,strong) NSDictionary *videoJson;
@end

@implementation ULYomobAdv


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
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_YOMOB_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
}


- (void)onShowVideoAdv :(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showVideoAdv:data];
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


- (void)initModuleAdv
{
    NSLog(@"%s",__func__);
    [self addListener];
    NSString* appId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_yomob_appid" :@""];
    [TGSDK initialize:appId callback:^(BOOL success, id tag, NSDictionary* result){
        dispatch_async(dispatch_get_main_queue(), ^{
            [TGSDK tagPayingUser:TGSmallPaymentUser WithCurrency:@"CNY" AndCurrentAmount:0 AndTotalAmount:0];
            NSLog(@"%s:TGSDK init finished",__func__);
        });
    }];
    
    [TGSDK setADDelegate:self];
    [TGSDK preloadAd:self];//会自行加载 只需要预加载一次即可
    
}

- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_SPLAH,UL_ADV_URL,UL_ADV_BANNER,UL_ADV_EMBEDDED,UL_ADV_FULLSCREEN,UL_ADV_INTERSTITIAL]];
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
    _videoJson = json;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_yomob_videoid" withDefaultParam:@"" withSplitString:@"|"];
    if([TGSDK couldShowAd: videoId]){
        [TGSDK showAd: videoId];
    }else{

        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_YOMOB_ADV_CALLBACK withData:@"adv not ready"];
        [self showNextAdv:json :videoId :@"adv not ready"];
    }
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


#pragma mark - TGPreloadADDelegate

- (void) onPreloadSuccess:(NSString* _Nullable)result
{
    NSLog(@"%s",__func__);
}

- (void) onPreloadFailed:(NSString* _Nullable)result WithError:(NSError* _Nullable) error
{
    NSLog(@"%s%@",__func__,error);
}

- (void) onAwardVideoLoaded:(NSString* _Nonnull) result
{
    NSLog(@"%s",__func__);
}

- (void) onInterstitialLoaded:(NSString* _Nonnull) result
{
    NSLog(@"%s",__func__);
}

- (void) onInterstitialVideoLoaded:(NSString* _Nonnull) result
{
    NSLog(@"%s",__func__);
}



#pragma mark - TGADDelegate


- (void) onShow:(NSString* _Nonnull)scene Success:(NSString* _Nonnull)result
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    [self showAdv:_videoJson :scene];
}

- (void) onShow:(NSString* _Nonnull)scene Failed:(NSString* _Nonnull)result Error:(NSError* _Nullable)error
{
    NSLog(@"%s",__func__);
    NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%ld",(long)error.code],@"; errorMsg = ", error.domain];
    [self resumeSound];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_YOMOB_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_videoJson :scene :errorMsg];
}

- (void) onAD:(NSString* _Nonnull)scene Click:(NSString* _Nonnull)result
{
    NSLog(@"%s",__func__);
    [self showClicked:_videoJson :scene];
}

- (void) onAD:(NSString* _Nonnull)scene Close:(NSString* _Nonnull)result Award:(BOOL)award
{
    NSLog(@"%s",__func__);
    [self resumeSound];
    if (award) {
        [self showClose:_videoJson :scene];
    }else{
        [self showFailed:_videoJson :scene :@"adv don't play complete"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_YOMOB_ADV_CALLBACK withData:@"adv don't play complete"];
    }
}


- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
    return @"";
}



@end
