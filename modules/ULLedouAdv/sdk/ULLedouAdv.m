//
//  ULLedouAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/4.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//
/**
 
 广告会自动加载
 存在问题：
        1.插屏、视频无点击回调。对方反馈存在部分平台没有点击回调，正常
        2.插屏预加载已经在初始化成功回调函数中调用，还是回调加载失败：需在初始化完成后再加载广告。对方反馈初始化回调函数存在时间长的问题，正常，建议延迟2s左右再预加载广告。
 */
#import "ULLedouAdv.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSplashViewController.h"
#import "ULGetDeviceId.h"
#import "ULTimer.h"
#import "VideoPolymerizationSDK.h"
#import "InterstitialPolymerizationSDK.h"
#import "SplashPolymerizationSDK.h"
#import <MobGiBannerAd/MGBannerPolymerizationSDK.h>

@interface ULLedouAdv ()<MGSplashAdDelegate,VideoAdDelegate,MGBannerAdDelegate,InterstitialInitDelegate,PreloadInterstitialAdDelegate,ShowCachedInterstitialAdDelegate>

@property (nonatomic, strong)NSDictionary *splashJson,*videoJson,*interJson;
@property (nonatomic, strong)NSString *videoLoadFailMsg,*interLoadFailMsg;

//TODO
@property (nonatomic, strong)NSMutableDictionary *advLoadObjByParamDic;
@property (nonatomic, assign)BOOL isSplashClicked,isInterClicked,isVideoClicked;
@end


@implementation ULLedouAdv

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
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_LEDOU_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_LEDOU_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    
}



- (void)onShowVideoAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showVideoAdv:data];
}

- (void)onShowInterAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showInterstitialAdv:data];
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
    _videoLoadFailMsg = @"";
    _interLoadFailMsg = @"";
    _advLoadObjByParamDic = [NSMutableDictionary new];
    
    [self addListener];
    
    NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_ledou_appkey" :@""];
    //当前sdk版本号
    NSString *videoSdkVersion = [VideoPolymerizationSDK getCurrentSDKVersion];
    NSLog(@"%s:current video sdk version = %@",__func__,videoSdkVersion);
    NSString *interSdkVersion = [InterstitialPolymerizationSDK getCurrentSDKVersion];
    NSLog(@"%s:current inter sdk version = %@",__func__,interSdkVersion);
    NSString *bannerSdkVersion = [MGBannerPolymerizationSDK getCurrentSDKVersion];
    NSLog(@"%s:current banner sdk version = %@",__func__,bannerSdkVersion);
    
    
    //获取本地配置的参数
    NSString *videoParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_ledou_videoid" :@""];
    NSArray *localVideoParams = [videoParamsStr componentsSeparatedByString:@"|"];
    NSArray *videoParamsArray = [self getParamArrayWithModule:@"ULLedouAdv" withType:@"video" withDefaultValue:localVideoParams];
    //这里需要参数去重，避免重复加载
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString * str in videoParamsArray) {
        if (![dict objectForKey:str]) {
            [dict setValue:str forKey:str];
        }
        
    }
    NSMutableArray * arr2 = [NSMutableArray new];
    for (NSString *value in [dict allValues]) {
        [arr2 addObject:value];
    }
    
    //初始化接口，开发者接入只需调用一次
    [[VideoPolymerizationSDK sharedInstance]initSDK:appKey vc:[ULTools getCurrentViewController] blockIds:arr2 delegate:self];
    
    
    //video debug start
//    [VideoPolymerizationSDK sharedInstance].debug = YES;
//    [VideoPolymerizationSDK validateIntergration];
    //video debug end
    
    
    //interstital debug start
//    [InterstitialPolymerizationSDK sharedInstance].debug = YES;
//    [InterstitialPolymerizationSDK validateIntergration];
    //interstitial debug end
    //初始化插屏
    [[InterstitialPolymerizationSDK sharedInstance] initSDK:appKey delegate:self];
    
}







- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_FULLSCREEN,UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_BANNER,UL_ADV_EMBEDDED]];
}

- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _splashJson = json;
    _isSplashClicked = NO;
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_ledou_splashid" withDefaultParam:@"" withSplitString:@"|"];
    
    [[SplashPolymerizationSDK sharedInstance]setSplashAdDelegate:self];
//    [SplashPolymerizationSDK sharedInstance].debug = true;
    [SplashPolymerizationSDK sharedInstance].fetchDelay = 3;
    NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_ledou_appkey" :@""];
    [[SplashPolymerizationSDK sharedInstance] showSplash:appKey withWindow:[ULTools getAppCurrentWindow] blockid:splashId];
}



- (void)showInterstitialAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    _interJson = json;
    _isInterClicked = NO;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *interId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_ledou_interid" withDefaultParam:@"" withSplitString:@"|"];
    BOOL isReady = [[InterstitialPolymerizationSDK sharedInstance] getCacheReady:interId];
    if (isReady) {
        [[InterstitialPolymerizationSDK sharedInstance]showCachedInterstitialAd:interId delegate:self];
    }else{
        //调用广告对象的load函数为下次加载
        NSLog(@"%s,%@",__func__,@"广告未准备好或者已过期");
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_ADV_CALLBACK withData:_interLoadFailMsg];
        [self showNextAdv:json :interId :_interLoadFailMsg];
    }
}


- (void)showVideoAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
    _videoJson = json;
    _isVideoClicked = NO;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_ledou_videoid" withDefaultParam:@"" withSplitString:@"|"];
    
    
    BOOL isReady = [[VideoPolymerizationSDK sharedInstance] isAdPlayable:videoId];
    if (isReady) {
        [[VideoPolymerizationSDK sharedInstance]showViewAd:[ULTools getCurrentViewController] forBlockId:videoId callBack:^{
            
            NSLog(@"%s,%@",__func__,@"video play failed");
            [self resumeSound];
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_ADV_CALLBACK withData:@"video play failed"];
            [self showNextAdv:json :videoId :self->_videoLoadFailMsg];
        }];
        
        
    }else {
        //调用广告对象的load函数为下次加载
        NSLog(@"%s,%@",__func__,@"广告未准备好或者已过期");
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_ADV_CALLBACK withData:_videoLoadFailMsg];
        [self showNextAdv:json :videoId :_videoLoadFailMsg];
    }
    
}




- (void)showFullscreenAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
}

- (void)showBannerAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showUrlAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showEmbeddedAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showGiftAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showIconAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)closeAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}







//-------------------

#pragma marks - MGSplashAdDelegate


/**
 *  This method is invoked when an ad load success.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)splashAdLoadSuccess:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}


/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Description to show the cause of the failure.
 */
- (void)splashAdLoadFailed:(NSString*)blockId
                     error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    NSLog(@"%s%@",__func__,errorMsg);
    [self showNextAdv:_splashJson :blockId :errorMsg];
}

/**
 *  This method is invoked when an ad has been presented.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)splashAdShowSuccess:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    [self showAdv:_splashJson :blockId];
}


/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Description to show the cause of the failure.
 */
- (void)splashAdShowFailed:(NSString *)blockId
                     error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_splashJson :blockId :errorMsg];
}

/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)splashAdDidClicked:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    if (!_isSplashClicked) {
        _isSplashClicked = YES;
        [self showClicked:_splashJson :blockId];
    }
    
}

/**
 *  This method is invoked when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)splashAdDidClosed:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    [[ULSplashViewController getInstance]removeSplashView];
}




#pragma marks - InterstitialInitDelegate



- (void)interstitialAdInitializeSuccess
{
    NSLog(@"%s",__func__);
    //在初始化成功回调中调用预加载接口，依然会导致存在加载失败回调（需在初始化完成后再进行预加载），已反馈给对面，对方反馈初始化存在相应的回调问题，提供方案是可以延时两秒左右进行再预加载
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ULTimer getInstance]startTimerWithName:@"ul_ledou_inter_preload_delay_timer" withTarget:self withTime:2.0 withSel:@selector(delay) withUserInfo:nil withRepeat:NO];
        
    });
    
}

- (void)delay
{
    NSLog(@"%s",__func__);
    //获取本地配置的参数
    NSString *interParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_ledou_interid" :@""];
    NSArray *localInterParams = [interParamsStr componentsSeparatedByString:@"|"];
    NSArray *interParamsArray = [self getParamArrayWithModule:@"ULLedouAdv" withType:@"interstitial" withDefaultValue:localInterParams];
    //这里需要参数去重，避免重复加载
    NSMutableDictionary *interDict = [NSMutableDictionary dictionary];
    for (NSString * str in interParamsArray) {
        if (![interDict objectForKey:str]) {
            [interDict setValue:str forKey:str];
        }
        
    }
    NSMutableArray * interArr = [NSMutableArray new];
    for (NSString *value in [interDict allValues]) {
        [interArr addObject:value];
    }
    
    for (NSString *param in interArr) {
        //预加载插屏，只加载一次
        [[InterstitialPolymerizationSDK sharedInstance] preloadInterstitialAd:param delegate:self];
    }
}

#pragma marks - PreloadInterstitialAdDelegate



/**
 *  This method is called when an ad load success.
 *
 *  @param blockId Detailed message  ad id.
 */
- (void)interstitialAdLoadSuccess:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}


/**
 *  This method is called when an ad load fails.
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Detailed message loading failure.
 */
- (void)interstitialAdLoadFailed:(NSString *)blockId
                           error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    _interLoadFailMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
}




#pragma marks - ShowCachedInterstitialAdDelegate



/**
 *  This method is called when an ad has been presented
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)interstitialAdStartShow:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    [self showAdv:_interJson :blockId];
}


/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Description to show the cause of the failure.
 */
- (void)interstitialAdShowFailed:(NSString *)blockId
                           error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_interJson :blockId :errorMsg];
}


/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)interstitialAdDidClicked:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    if (!_isInterClicked) {
        _isInterClicked = YES;
        [self showClicked:_interJson :blockId];
    }
    
}


/**
 *  This method is called when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)interstitialAdDidClosed:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    
}




#pragma marks - VideoAdDelegate

/**
 *  When the video ad is closed, it triggers a reward callback.
 *
 *  @param isShouldReward  YES means you can give rewards, and NO means you can't
 *  @param blockId         Detailed message  ad id.
 */
- (void)triggerReward:(BOOL)isShouldReward
           forBlockid:(NSString *)blockId
{
    NSLog(@"%s",__func__);
        if (isShouldReward) {
            [self showClose:_videoJson :blockId];
        }else{
            NSLog(@"CommonLedouAdv----video don't play completed");
            [self showFailed:_videoJson :blockId :@"adv don't play completed"];
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_ADV_CALLBACK withData:@"adv don't play completed"];
        }
}


/**
 *  This method is invoked when an ad load sucess.
 */
- (void)videoAdLoadSuccess
{
    NSLog(@"%s",__func__);
}



/**
 *  This method is invoked when an ad load fails.
 *
 *  @param  error  Detailed message loading failure.
 */
- (void)videoAdLoadFailed:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    _videoLoadFailMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
}

/**
 *  This method is invoked when an ad has been presented.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)videoAdStartShow:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    [self showAdv:_videoJson :blockId];
}



/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param error  Description to show the cause of the failure.
 */
- (void)videoAdShowFailed:(NSString *)blockId
                    error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    [self resumeSound];
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_videoJson :blockId :errorMsg];
}

/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)videoAdDidClicked:(NSString *)blockId
{
    NSLog(@"%s",__func__);
    if (!_isVideoClicked) {
        _isVideoClicked = YES;
        [self showClicked:_videoJson :blockId];
    }
    
    //测试该函数未回调
}

/**
 *  This method is invoked when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)videoAdDidClosed:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}


- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
//    ------------------关于服务端和配置的错误----------------
//    6001  没有网络
//    6002  请求配置失败
//    6003  服务端限制广告下发
//    6004  配置信息为空
//    6005  appKey参数错误
//    6006  数据解析失败
//    6007  包名校验失败
//    6008  网络类型错误（后台配置仅支持wifi，当前网络可能是非wifi）
//    6009  一般配置信息为空
//
//
//    ------------------关于聚合平台的错误--------------------
//
//    7001 没有调用初始化接口
//    7002 广告位传入为空
//    7003 广告位传入错误
//    7004 广告位达到展示限制
//    7005 所有广告平台达到展示限制
//    7006 广告位配置了概率，没有随机到
//    7007 视图控制器传入为空
//    7008 聚合请求超时
//    7009 广告位概率小于等于零
//    7010 广告没有就绪
//    7011 视图传入为空
//    7012 广告尺寸传入为空
//    7013 初始化没有完成
//    7014 广告位配置为空
//    7015 该广告位还没有使用加载方法
//    7016 概率随机平台出错
//    7017 选中平台出错
//    7018 html模板下载失败
//    7019 图片下载失败
//    7020 传入数据为空
//    7021 传入数据错误（传入一个不存在的数据）
//    7022 缓存中没有任何数据（还没有开始缓存任何广告信息）
//    7023 缓存中没有该广告位任何数据（多在展示时触发，该广告位没有使用加载方法）
//    7024 该广告位没有任何平台缓存成功（该广告位下的平台，没有一家加载成功）
//    7025 交互视图为空（原生信息流中输入用于点击下载的视图为空）
//    7026 视图信息为空（原生信息流中输入用于大图、小图、小标题等的信息为空）
//    7027 没有使用获取状态方法
//    7028 窗口（window）传入为空
//    7029 视频资源下载失败
//    7030 系统版本小于9.0
//    7031 webview错误（原生拼装的类型中渲染html模板容器的问题）
//    7032 加载资源超时（在规定的时间没有下载资源成功，自有dsp、原生拼装）
//    7033 屏幕方向错误
//
//
//    -----------------关于聚合第三方平台的错误-----------------
//
//    8001  第三方平台请求超时
//    8002  第三方平台广告过期
//    8003  第三方平台参数为空
//    8004  第三方平台达到展示限制
//    8005  第三方平台没有填充
//    8006  第三方平台返回数据为空
//    8007  内存中不存在该平台，输入的第三方平台数据错误，加载好的平台中不存在该平台（原生和信息流）
//
//
//    ----------------其他的错误-----------------
//
//    9001  第三方平台其他加载错误
//    9002  第三方平台其他展示错误
    NSString *errorMsg = @"";
    if ([code isEqualToString:@"6001"]) {
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"没有网络"];
    }else if ([code isEqualToString:@"6002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求配置失败"];
    }else if ([code isEqualToString:@"6003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"服务端限制广告下发"];
    }else if ([code isEqualToString:@"6004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"配置信息为空"];
    }else if ([code isEqualToString:@"6005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"appKey参数错误"];
    }else if ([code isEqualToString:@"6006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"数据解析失败"];
    }else if ([code isEqualToString:@"6007"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"包名校验失败"];
    }else if ([code isEqualToString:@"6008"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"网络类型错误（后台配置仅支持wifi，当前网络可能是非wifi）"];
    }else if ([code isEqualToString:@"6009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"一般配置信息为空"];
    }else if ([code isEqualToString:@"7001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"没有调用初始化接口"];
    }else if ([code isEqualToString:@"7002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位传入为空"];
    }else if ([code isEqualToString:@"7003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位传入错误"];
    }else if ([code isEqualToString:@"7004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位达到展示限制"];
    }else if ([code isEqualToString:@"7005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"所有广告平台达到展示限制"];
    }else if ([code isEqualToString:@"7006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位配置了概率，没有随机到"];
    }else if ([code isEqualToString:@"7007"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视图控制器传入为空"];
    }else if ([code isEqualToString:@"7008"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"聚合请求超时"];
    }else if ([code isEqualToString:@"7009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位概率小于等于零"];
    }else if ([code isEqualToString:@"7010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告没有就绪"];
    }else if ([code isEqualToString:@"7011"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视图传入为空"];
    }else if ([code isEqualToString:@"7012"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告尺寸传入为空"];
    }else if ([code isEqualToString:@"7013"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"初始化没有完成"];
    }else if ([code isEqualToString:@"7014"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位配置为空"];
    }else if ([code isEqualToString:@"7015"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"该广告位还没有使用加载方法"];
    }else if ([code isEqualToString:@"7016"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"概率随机平台出错"];
    }else if ([code isEqualToString:@"7017"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"选中平台出错"];
    }else if ([code isEqualToString:@"7018"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"html模板下载失败"];
    }else if ([code isEqualToString:@"7019"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"图片下载失败"];
    }else if ([code isEqualToString:@"7020"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"传入数据为空"];
    }else if ([code isEqualToString:@"7021"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"传入数据错误（传入一个不存在的数据）"];
    }else if ([code isEqualToString:@"7022"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缓存中没有任何数据（还没有开始缓存任何广告信息）"];
    }else if ([code isEqualToString:@"7023"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缓存中没有该广告位任何数据（多在展示时触发，该广告位没有使用加载方法）"];
    }else if ([code isEqualToString:@"7024"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"该广告位没有任何平台缓存成功（该广告位下的平台，没有一家加载成功）"];
    }else if ([code isEqualToString:@"7025"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"交互视图为空（原生信息流中输入用于点击下载的视图为空）"];
    }else if ([code isEqualToString:@"7026"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视图信息为空（原生信息流中输入用于大图、小图、小标题等的信息为空）"];
    }else if ([code isEqualToString:@"7027"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"没有使用获取状态方法"];
    }else if ([code isEqualToString:@"7028"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"窗口（window）传入为空"];
    }else if ([code isEqualToString:@"7029"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频资源下载失败"];
    }else if ([code isEqualToString:@"7030"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"系统版本小于9.0"];
    }else if ([code isEqualToString:@"7031"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"webview错误（原生拼装的类型中渲染html模板容器的问题）"];
    }else if ([code isEqualToString:@"7032"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"加载资源超时（在规定的时间没有下载资源成功，自有dsp、原生拼装）"];
    }else if ([code isEqualToString:@"7033"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"屏幕方向错误"];
    }else if ([code isEqualToString:@"8001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台请求超时"];
    }else if ([code isEqualToString:@"8002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台广告过期"];
    }else if ([code isEqualToString:@"8003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台参数为空"];
    }else if ([code isEqualToString:@"8004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台达到展示限制"];
    }else if ([code isEqualToString:@"8005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台没有填充"];
    }else if ([code isEqualToString:@"8006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台返回数据为空"];
    }else if ([code isEqualToString:@"8007"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"内存中不存在该平台，输入的第三方平台数据错误，加载好的平台中不存在该平台（原生和信息流）"];
    }else if ([code isEqualToString:@"9001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台其他加载错误"];
    }else if ([code isEqualToString:@"9002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"第三方平台其他展示错误"];
    }
    
    return errorMsg;
}


@end
