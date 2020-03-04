//
//  ULGdtAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/4.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//


#import "ULGdtAdv.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSplashViewController.h"
#import "ULGetDeviceId.h"

@interface ULGdtAdv ()

@property (nonatomic, strong)NSDictionary *splashJson,*videoJson,*interJson;
@property (nonatomic, strong)NSString *videoLoadFailMsg,*interLoadFailMsg;

//TODO
@property (nonatomic, strong)NSMutableDictionary *advLoadObjByParamDic;
@end


@implementation ULGdtAdv

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
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_GDT_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_GDT_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    
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
    
    NSString *appid = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_gdt_appid" :@""];

    
    //获取本地配置的参数
    NSString *videoParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_ledou_videoid" :@""];
    NSArray *localVideoParams = [videoParamsStr componentsSeparatedByString:@"|"];
    NSArray *videoParamsArray = [self getParamArrayWithModule:@"ULLedouAdv" withType:@"video" withDefaultValue:localVideoParams];

    
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
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_splashid" withDefaultParam:@"" withSplitString:@"|"];
    
}



- (void)showInterstitialAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    _interJson = json;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *interId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_interid" withDefaultParam:@"" withSplitString:@"|"];

}


- (void)showVideoAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
    _videoJson = json;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_videoid" withDefaultParam:@"" withSplitString:@"|"];

    
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









- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
//3001    网络错误
//3003    手机无网络
//4001    初始化错误, 包括广告位为空、AppKey为空、ViewController
//为空
//4003    广告位错误
//4006    广告未曝光
//4007    设备不支持
//4008    设备方向不支持
//4009    开屏跳过按钮定义非法
//4010    开屏bottomView设置非法
//4011    请求广告超时
//4013    系统不支持，原生视频模板广告只支持 iOS 9 及以上系统
//4014    广告数据返回前尝试展示广告, 例如激励视频拉到广告后才可以调用展示接口
//4015    广告已经曝光过，不允许二次展示，请重新拉取
//4016    应用横竖方向与广告位支持方向不匹配
//4017    外部传入的VC无效
//4018    缓存文件在流程中被意外删除
//4019    开屏广告 rootViewController presentVC 被占用
//5001    后台数据错误
//5002    视频素材下载错误
//5003    视频素材播放错误
//5004    没匹配的广告，禁止重试，否则影响流量变现效果
//5005    广告请求量或者消耗等超过日限额，请第二天再请求广告
//5006    包名校验非法
//5009    广告请求量或者消耗等超过小时限额，请一小时后再请求广告
//5010    广告样式校验失败，请检查广告位与接口使用是否一致
//5012    广告过期，请重新拉取
//5013    广告拉取过于频繁，请稍后再试
//5014    视频广告视频和图片素材都下载错误
//5015    当前版本不出广告
//5016    JSON数据解析失败
//5017    adCount参数非法
//5018    广告位下线
//5019    视频时长超过设定时长
//5020    视频URL为空
//5021    广告已下线
//5022    VAST接入错误
//5024    接口组合错误
//6000    未知错误，联系腾讯广告商务同事协助排查
    NSString *errorMsg = @"";
    if ([code isEqualToString:@"3001"]) {
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"网络错误"];
    }else if ([code isEqualToString:@"3003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"手机无网络"];
    }else if ([code isEqualToString:@"4001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"初始化错误, 包括广告位为空、AppKey为空、ViewController为空"];
    }else if ([code isEqualToString:@"4003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位错误"];
    }else if ([code isEqualToString:@"4006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告未曝光"];
    }else if ([code isEqualToString:@"4007"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"设备不支持"];
    }else if ([code isEqualToString:@"4008"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"设备方向不支持"];
    }else if ([code isEqualToString:@"4009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏跳过按钮定义非法"];
    }else if ([code isEqualToString:@"4010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏bottomView设置非法"];
    }else if ([code isEqualToString:@"4011"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求广告超时"];
    }else if ([code isEqualToString:@"4013"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"系统不支持，原生视频模板广告只支持 iOS 9 及以上系统"];
    }else if ([code isEqualToString:@"4014"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告数据返回前尝试展示广告, 例如激励视频拉到广告后才可以调用展示接口"];
    }else if ([code isEqualToString:@"4015"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告已经曝光过，不允许二次展示，请重新拉取"];
    }else if ([code isEqualToString:@"4016"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"应用横竖方向与广告位支持方向不匹配"];
    }else if ([code isEqualToString:@"4017"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"外部传入的VC无效"];
    }else if ([code isEqualToString:@"4018"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缓存文件在流程中被意外删除"];
    }else if ([code isEqualToString:@"4019"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏广告 rootViewController presentVC 被占用"];
    }else if ([code isEqualToString:@"5001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"后台数据错误"];
    }else if ([code isEqualToString:@"5002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频素材下载错误"];
    }else if ([code isEqualToString:@"5003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频素材播放错误"];
    }else if ([code isEqualToString:@"5004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"没匹配的广告，禁止重试，否则影响流量变现效果"];
    }else if ([code isEqualToString:@"5005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告请求量或者消耗等超过日限额，请第二天再请求广告"];
    }else if ([code isEqualToString:@"5006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"包名校验非法"];
    }else if ([code isEqualToString:@"5009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告请求量或者消耗等超过小时限额，请一小时后再请求广告"];
    }else if ([code isEqualToString:@"5010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告样式校验失败，请检查广告位与接口使用是否一致"];
    }else if ([code isEqualToString:@"5012"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告过期，请重新拉取"];
    }else if ([code isEqualToString:@"5013"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告拉取过于频繁，请稍后再试"];
    }else if ([code isEqualToString:@"5014"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频广告视频和图片素材都下载错误"];
    }else if ([code isEqualToString:@"5015"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"当前版本不出广告"];
    }else if ([code isEqualToString:@"5016"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"JSON数据解析失败"];
    }else if ([code isEqualToString:@"5017"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"adCount参数非法"];
    }else if ([code isEqualToString:@"5018"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位下线"];
    }else if ([code isEqualToString:@"5019"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频时长超过设定时长"];
    }else if ([code isEqualToString:@"5020"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频URL为空"];
    }else if ([code isEqualToString:@"5021"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告已下线"];
    }else if ([code isEqualToString:@"5022"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"VAST接入错误"];
    }else if ([code isEqualToString:@"5024"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"接口组合错误"];
    }else if ([code isEqualToString:@"6000"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"未知错误，联系腾讯广告商务同事协助排查"];
    }
    
    return errorMsg;
}


@end
