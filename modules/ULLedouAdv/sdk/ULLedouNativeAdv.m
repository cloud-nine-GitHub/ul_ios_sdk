//
//  ULLedouNativeAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULLedouNativeAdv.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSplashViewController.h"
#import "ULGetDeviceId.h"
#import "ULTimer.h"
#import "ULNativeAdvItemCacher.h"
#import "ULLedouNativeAdvItem.h"
#import "NativeAdExtraOptionInfo.h"
#import "NativePolymerization.h"
#import "NativeAdData.h"
#import "ULCmd.h"
#import "ULNativeAdvResponseDataItem.h"
#import "ULAdvCallBackManager.h"
#import "ULNativeSplashAdvLayout.h"


static NSString *const UL_NATIVE_ADV_DEFAULT_TARGET_TITLE = @"点击查看";

@interface ULLedouNativeAdv ()<ULINativeAdvItemProvider,NativeAdDelegate>

@property (nonatomic,strong) ULNativeAdvItemCacher *nativeAdvItemCacher;
@property (nonatomic,strong) NSMutableDictionary *advIdTypeMap;
@property (nonatomic,strong) NSMutableDictionary *advShowStateMap;//记录广告展示状态
@property (nonatomic,strong) NSDictionary *splashJson;
@property (nonatomic,strong) NativeAdData *splashResponse;
@property (nonatomic,strong) ULNativeSplashAdvLayout *layout;
@end

@implementation ULLedouNativeAdv
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
    
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_BANNER_ADV withSelector:@selector(onShowBannerAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_EMBEDDED_ADV withSelector:@selector(onShowEmbeddedAdv:) withPriority:PRIORITY_NONE];
    
    
}



- (void)onShowBannerAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showBannerAdv:data];
}

- (void)onShowInterAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showInterstitialAdv:data];
}

- (void)onShowEmbeddedAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showEmbeddedAdv:data];
}



- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    NSDictionary *json = [ULTools StringToDictionary: param];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_CLICKNATIVEADV]) {
        [self showNativeAdvClick:data];
    }else if ([cmd isEqualToString:MSG_CMD_CLOSENATIVEADV]){
        [self showNativeAdvClose:data];
    }
    return nil;
}




- (void)showNativeAdvClick: (NSDictionary *)data
{
    
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    
    //只有当前模块广告展示才有以下逻辑
    BOOL isShow = [_advShowStateMap objectForKey:advId];
    if (!isShow) {
        return;
    }
    
    NSString *type = [_advIdTypeMap objectForKey:advId];
    ULNativeAdvResponseDataItem *item = [_nativeAdvItemCacher pollUsingItem:advId];
    if (!item) {
        [self showNativeClickResultFailed:data];
        
        return;
    }
    
    [item onClick];
    

    
    NativeAdData *response = item.response;
    [[NativePolymerization sharedInstance] clickAd:response];
    
    [self showNativeClickResultSucess:data];
    NSMutableDictionary *advData = [NSMutableDictionary new];
    [advData setValue:data forKey:@"gameAdvData"];
    NSMutableDictionary *sdkAdvData = [NSMutableDictionary new];
    [sdkAdvData setValue:type forKey:@"type"];
    [sdkAdvData setValue:NSStringFromClass([self class]) forKey:@"module"];
    [advData setValue:sdkAdvData forKey:@"sdkAdvData"];
    
    //[ULAdvCallBackManager clickCallBack:1 :@"show adv clicked" :advData];
    NSString *title = response.title;
    NSString *nativeAdvTitle = title.length <= 6 ? title : [title substringToIndex:6];
    [self showClicked:advData :response.blockid :nativeAdvTitle];
    
    
    
    [_advShowStateMap setValue:[NSNumber numberWithBool:NO] forKey:advId];
    
    [[NativePolymerization sharedInstance] unAttachAd:response toView:item.containerView];
    
    [item onDispose];//顺序不能调换
}


- (void)showNativeAdvClose: (NSDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    //只有当前模块广告展示才有以下逻辑
    BOOL isShow = [_advShowStateMap objectForKey:advId];
    if (!isShow) {
        return;
    }
    [self showNativeCloseResultSuccess:data];
    [_advShowStateMap setValue:[NSNumber numberWithBool:NO] forKey:advId];
    
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
    _advIdTypeMap = [NSMutableDictionary new];
    _advShowStateMap = [NSMutableDictionary new];
    [self addListener];
    
    NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_ledou_appkey" :@""];
    //获取原生相关参数
    NSString *nativeParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_ledou_nativeid" :@""];
    NSArray *localNativeParams = [nativeParamsStr componentsSeparatedByString:@"|"];
    NSArray *splashParamsArray = [self getParamArrayWithModule:@"ULLedouNativeAdv" withType:@"splash" withDefaultValue:localNativeParams];
    NSArray *interParamsArray = [self getParamArrayWithModule:@"ULLedouNativeAdv" withType:@"interstitial" withDefaultValue:localNativeParams];
    NSArray *bannerParamsArray = [self getParamArrayWithModule:@"ULLedouNativeAdv" withType:@"banner" withDefaultValue:localNativeParams];
    NSArray *embeddedParamsArray = [self getParamArrayWithModule:@"ULLedouNativeAdv" withType:@"embedded" withDefaultValue:localNativeParams];
    //这里需要参数去重，避免重复加载
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString * str in splashParamsArray) {
        if (![dict objectForKey:str]) {
            [dict setValue:str forKey:str];
        }
        
    }
    for (NSString * str in interParamsArray) {
        if (![dict objectForKey:str]) {
            [dict setValue:str forKey:str];
        }
        
    }
    for (NSString * str in bannerParamsArray) {
        if (![dict objectForKey:str]) {
            [dict setValue:str forKey:str];
        }
        
    }
    for (NSString * str in embeddedParamsArray) {
        if (![dict objectForKey:str]) {
            [dict setValue:str forKey:str];
        }
        
    }
    NSMutableArray * arr2 = [NSMutableArray new];
    for (NSString *value in [dict allValues]) {
        [arr2 addObject:value];
    }
    
    
    //native debug start
//    [NativePolymerization sharedInstance].debug = YES;
//    [NativePolymerization validateIntergration];
    //native debug end
    //    //设置一些可选的属性，如logo标志位置（该方法要在初始化方法之前调用）
    //    NativeAdExtraOptionInfo *optionInfo = [[NativeAdExtraOptionInfo alloc] init];
    //    optionInfo.logoLocation = MGNativeAdLogoLocation_BottomRight;
    //    [[NativePolymerization sharedInstance] setOptionInfo:optionInfo];
    //初始化
    [[NativePolymerization sharedInstance] initSDK:appKey blockids:arr2 delegate:self];
    
    _nativeAdvItemCacher = [[ULNativeAdvItemCacher alloc] initWithProvider:self];
    
}

#pragma mark -NativeAdDelegate
/**
 *  CP可通过该回调，实时收到广告数据准备就绪的通知; CP可通过调用getNativeAd接口拿到广告数据!
 *
 *  @param blockId 广告位ID
 */
- (void)nativeAdLoadSuccess:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}

/**
 *  This method is called when an ad load fails.
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Detailed message loading failure.
 */
- (void)nativeAdLoadFailed:(NSString *)blockId
                     error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
}

/**
 *  This method is called when an ad has been presented
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)nativeAdShowSuccess:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param error  Description to show the cause of the failure.
 */
- (void)nativeAdShowFailed:(NSString *)blockId
                     error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
}

/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)nativeAdDidClicked:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}

/**
 *  This method is called when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)nativeAdDidClosed:(NSString *)blockId
{
    NSLog(@"%s",__func__);
}



- (id <ULINativeAdvItem>)getItem:(NSString *)advParam :(id <ULINativeAdvItemCallback>)callback
{
    return (id <ULINativeAdvItem>)[[ULLedouNativeAdvItem alloc] initWithParam:advParam withCallback:callback];
}



- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_VIDEO,UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_FULLSCREEN]];
}

- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    NSDictionary *advData = json;
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:advData :@"gameAdvData" :nil];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:advData :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *paramString = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_ledou_nativeid" withDefaultParam:@"" withSplitString:@"|"];
    //参数为空会导致乐逗sdk出现crash，那么我们直接将隐患扼杀在摇篮中
    if (paramString.length == 0){
        //失败
        [self showNextAdv:advData :paramString :@"param is empty"];
        return;
    }
    
    
    //先设置回调，不然block会造成空指针
    __block ULLedouNativeAdv *ledouNativeAdv = self;
    _nativeAdvItemCacher.cacheCallback = ^(NSDictionary *gameJson,id __nullable response,id __nullable error){//乐逗原生加载为同步回调，应该不会出现无回调情况导致开屏卡住
        if (!error) {
            //成功
            [ledouNativeAdv onSplashAdvShow:gameJson :response];
            
        }else{
            //失败
            [ledouNativeAdv showNextAdv:gameJson :paramString :error];
        }
    };
    
    [_nativeAdvItemCacher getAdvItem:advId :paramString :advData];
}

- (void)onSplashAdvShow:(NSDictionary *)gameJson :(id )response
{
    _splashJson = gameJson;
    ULNativeAdvResponseDataItem *nativeItem = response;
    NativeAdData *nativeResponse = nativeItem.response;
    _splashResponse = nativeResponse;
    NSString *title = nativeResponse.title;
    NSString *desc = nativeResponse.descriptionText;
    //NSString *url = [self getNativeUrl:nativeResponse];
    //NSString *targetTitle = UL_NATIVE_ADV_DEFAULT_TARGET_TITLE;
    NSString *blockId = nativeResponse.blockid;
    
    //创建开屏ui对象
    _layout = [[ULNativeSplashAdvLayout alloc] initWithOrientation:[ULTools isLandscapeScreen] withViewController:[ULTools getCurrentViewController]];
    
    //填充view内容
    _layout.titleLabel.text = title;
    _layout.descLabel.text = desc;
    //NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];//TODO 同步加载网络图片可能会导致ui线程卡顿
    //layout.imageUI.image = [UIImage imageWithData:imgData];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];//异步加载图片，避免ui线程阻塞
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    [operationQueue addOperation:op];
    
    //注册广告页面点击事件，全局的
    UITapGestureRecognizer *parentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentTap:)];
    [_layout.parentView addGestureRecognizer:parentTap];
    _layout.parentView.userInteractionEnabled = YES;
    
    
    //跳过按钮开始倒计时动画
    __weak __typeof(self) weakSelf = self;
    [_layout.drawCircleBtn startAnimationDuration:UL_NATIVE_SPLASH_ADV_SHOW_TIME withBlock:^{
        [weakSelf onNativeSplashDismiss];
    }];
    //跳过按钮注册点击事件
    [_layout.drawCircleBtn addTarget:self action:@selector(removeSplash) forControlEvents:UIControlEventTouchUpInside];
    
    //截取标题前6个字符进行数据上报
    NSString *nativeAdvTitle = title.length <= 6 ? title : [title substringToIndex:6];
    [self showAdv:gameJson :blockId :nativeAdvTitle];
}

- (void)downloadImage
{
    NSURL *imageUrl = [NSURL URLWithString:[self getNativeUrl:_splashResponse]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_layout.imageUI.image = image;
    });
    
}

- (void)parentTap:(UITapGestureRecognizer *)gr {
    NSString *nativeAdvTitle = _splashResponse.title.length <= 6 ? _splashResponse.title : [_splashResponse.title substringToIndex:6];
    [[NativePolymerization sharedInstance] clickAd:_splashResponse];
    [self showClicked:_splashJson :_splashResponse.blockid :nativeAdvTitle];
    [self onNativeSplashDismiss];
}

- (void)removeSplash
{
    [self onNativeSplashDismiss];
}


- (void)onNativeSplashDismiss
{
    [[ULSplashViewController getInstance]removeSplashView];
}


- (void)showInterstitialAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    [self onNativeAdvShow:json];
}


- (void)showVideoAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
    
    
}




- (void)showFullscreenAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
}

- (void)showBannerAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    [self onNativeAdvShow:json];
}
- (void)showUrlAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showEmbeddedAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    [self onNativeAdvShow:json];
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



- (void)onNativeAdvShow :(NSDictionary *)advData
{
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:advData :@"gameAdvData" :nil];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:advData :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *paramString = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_ledou_nativeid" withDefaultParam:@"" withSplitString:@"|"];
    //参数为空会导致乐逗sdk出现crash，那么我们直接将隐患扼杀在摇篮中
    if (paramString.length == 0){
        //失败
        //该广告位展示的不是当前模块的广告
        [self->_advShowStateMap setValue:[NSNumber numberWithBool:NO] forKey:advId];
        NSMutableDictionary *nativeDataJson = [NSMutableDictionary new];
        [nativeDataJson setValue:@"" forKey:@"title"];
        [nativeDataJson setValue:@"" forKey:@"desc"];
        [nativeDataJson setValue:@"" forKey:@"url"];
        [nativeDataJson setValue:@"" forKey:@"targetTitle"];
        [self showNativeAdvResultFailed:nativeDataJson :advData];
        [self showNextAdv:advData :paramString :@"param is empty"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_ADV_CALLBACK withData:@"param is empty"];
        return;
    }
    
    
    //先设置回调，不然block会造成空指针
    __block ULLedouNativeAdv *ledouNativeAdv = self;
    _nativeAdvItemCacher.cacheCallback = ^(NSDictionary *gameJson,id __nullable response,id __nullable error){
        if (!error) {
            //成功
            //该广告位展示的是当前模块的广告
            [ledouNativeAdv->_advShowStateMap setValue:[NSNumber numberWithBool:YES] forKey:advId];
            
            ULNativeAdvResponseDataItem *nativeResponse = response;
            NativeAdData *nativeAdData = nativeResponse.response;
            NSMutableDictionary *nativeDataJson = [NSMutableDictionary new];
            NSString *title = nativeAdData.title;
            if (!title || title.length == 0) {
                title = NATIVE_DEFAULT_TITLE;
            }
            NSString *desc = nativeAdData.descriptionText;
            if (!desc || desc.length == 0) {
                desc = NATIVE_DEFAULT_DESC;
            }
            [nativeDataJson setValue:title forKey:@"title"];
            [nativeDataJson setValue:desc forKey:@"desc"];
            [nativeDataJson setValue:[ledouNativeAdv getNativeUrl:nativeAdData] forKey:@"url"];
            [nativeDataJson setValue:UL_NATIVE_ADV_DEFAULT_TARGET_TITLE forKey:@"targetTitle"];
            
            [ledouNativeAdv showNativeAdvResultSuccess:nativeDataJson :gameJson];
            [ledouNativeAdv onNativeAdvExposured:gameJson :response :paramString];
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_ADV_CALLBACK withData:[ULTools DictionaryToString:nativeDataJson]];
        }else{
            //失败
            //该广告位展示的不是当前模块的广告
            [ledouNativeAdv->_advShowStateMap setValue:[NSNumber numberWithBool:NO] forKey:advId];
            NSMutableDictionary *nativeDataJson = [NSMutableDictionary new];
            [nativeDataJson setValue:@"" forKey:@"title"];
            [nativeDataJson setValue:@"" forKey:@"desc"];
            [nativeDataJson setValue:@"" forKey:@"url"];
            [nativeDataJson setValue:@"" forKey:@"targetTitle"];
            [ledouNativeAdv showNativeAdvResultFailed:nativeDataJson :gameJson];
            [ledouNativeAdv showNextAdv:gameJson :paramString :error];
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_ADV_CALLBACK withData:error];
        }
    };
    
    [_nativeAdvItemCacher getAdvItem:advId :paramString :advData];
}


- (void)onNativeAdvExposured :(NSDictionary *)gameJson :(id )response :(NSString *)param
{
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:gameJson :@"gameAdvData" :nil];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:gameJson :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    [_advIdTypeMap setValue:type forKey:advId];
    
    ULNativeAdvResponseDataItem *nativeItem = response;
    NativeAdData *nativeResponse = nativeItem.response;
    NSString *title = nativeResponse.title;
    NSString *nativeAdvTitle = title.length <= 6 ? title : [title substringToIndex:6];
    [self showAdv:gameJson :param :nativeAdvTitle];
}

- (NSString *)getNativeUrl :(NativeAdData *)response
{
    NSString *url = @"";
    NSString *iconUrl = response.iconURL;
    if (iconUrl && iconUrl.length > 0) {
        url = iconUrl;
        return url;
    }
    NSString *imageUrl = response.imageURL;
    if (imageUrl && imageUrl.length > 0) {
        url = imageUrl;
        return url;
    }
    return url;
}


@end
