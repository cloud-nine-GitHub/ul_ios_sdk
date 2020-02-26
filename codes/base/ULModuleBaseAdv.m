//
//  ULModuleBaseAdv.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULModuleBaseAdv.h"
#import "ULIAdv.h"
#import "ULAdvBean.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULTools.h"
#import "ULSDKManager.h"
#import "ULCmd.h"
#import "ULAdvCallBackManager.h"
#import "ULStringConst.h"
#import "ULSplashViewController.h"
#import "ULAccountType.h"

@interface ULModuleBaseAdv ()<ULIAdv>

@property (strong,nonatomic) NSMutableArray *moduleDisableAdvTypes;

@end

@implementation ULModuleBaseAdv


- (id)init
{
    if (self = [super init]) {
        self.moduleDisableAdvTypes = [NSMutableArray new];
        [self setBaseAdvListener];
        [self onConstructorAdv];
    }
    return self;
}

- (void)initModuleBaseAdv :(NSDictionary *)advTargetModuleBeansDic
{
    [self setListener:advTargetModuleBeansDic];
    
    [self initModuleAdv];
}

//根据对应模块对应广告类型获取参数列表
- (NSArray *)getParamArrayWithModule:(NSString *)module withType:(NSString *)type withDefaultValue:(NSArray *)defaultValue
{
    NSMutableDictionary *moduleTypeParamsDic = [ULSDKManager getModuleTypeParamsDic];
    if (!moduleTypeParamsDic) {//未初始化
        return defaultValue;
    }
    NSMutableDictionary *typeParamsDic = [moduleTypeParamsDic objectForKey:module];
    return [typeParamsDic objectForKey:type];
}



- (void)setDisableAdvPriority:(NSString *)disableType,...
{
    //指向变参的指针
    va_list list;
    //使用第一个参数来初使化list指针
    va_start(list, disableType);
    //因为会取第一个元素来初始化，下方循环遍历取的第二个元素作为起始，所以这里先将第一个元素添加
    if (![_moduleDisableAdvTypes containsObject:disableType]) {
        [_moduleDisableAdvTypes addObject:disableType];
    }
    
    while (YES)
    {
        //返回可变参数，va_arg第二个参数为可变参数类型，如果有多个可变参数，依次调用可获取各个参数
        NSString *type = va_arg(list, NSString*);
        if (!type) {
            break;
        }
        if ([_moduleDisableAdvTypes containsObject:type]) {
            continue;
        }
        [_moduleDisableAdvTypes addObject:type];
    }
    //结束可变参数的获取
    va_end(list);
    [_moduleDisableAdvTypes addObject:@"unknow"];
}



- (void)setDisableAdvPriorityByArray:(NSArray *)disableType
{

    for (NSString *type in disableType) {
        if (![_moduleDisableAdvTypes containsObject:type]) {
            [_moduleDisableAdvTypes addObject:type];
        }
        
    }
    
    [_moduleDisableAdvTypes addObject:@"unknow"];
}


- (void)setBaseAdvListener
{
    
}

- (void)setListener:(NSDictionary *)advTargetModuleBeansDic
{
    NSArray *keys = [advTargetModuleBeansDic allKeys];
    for (NSString *key in keys) {
        NSArray *beans = [advTargetModuleBeansDic objectForKey:key];
        for (ULAdvBean *bean in beans) {
            NSMutableDictionary *extra = [NSMutableDictionary new];
            [extra setValue:key forKey:@"advId"];
            [extra setValue:bean forKey:@"advBean"];
            [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_PREPARE_SHOW_ADV_BASE,key] withSelector:@selector(onBasePrepareShowAdv:) withPriority:bean.priority withExtra:extra];

            
        }
    }
}



- (void)onBasePrepareShowAdv:(NSNotification *)notification
{
    NSDictionary *extra = notification.userInfo[@"extra"];
    NSString *advId = [extra objectForKey:@"advId"];
    ULAdvBean *advBean = [extra objectForKey:@"advBean"];
    [[ULNotificationDispatcher getInstance] addNotificationWithObserverOnce:self withName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_SHOW_ADV_BASE,advId] withSelector:@selector(onBaseShowAdv:) withPriority:advBean.priority withExtra:extra];
    
}

- (void)onBaseShowAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    NSDictionary *extra = notification.userInfo[@"extra"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    
    ULAdvBean *bean = [extra objectForKey:@"advBean"];
    NSString *typeS = bean.type;
    NSString *rewardTypeS = bean.rewardTag;
    NSString *moduleS = bean.module;
    NSArray *params = bean.params;
    NSArray *paramProbabilities = bean.paramsProbability;
    int level = bean.level;
    
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    //广告请求统计 对于多参数来说并不知道本次请求的是哪一个参数
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],moduleS,typeS,@"branchAdvRequest",@"",@"",advId,advId,@"",@""];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    [sdkAdvData setValue:typeS forKey:@"type"];
    [sdkAdvData setValue:moduleS forKey:@"module"];
    [sdkAdvData setValue:rewardTypeS forKey:@"rewardType"];
    [sdkAdvData setValue:params forKey:@"advParams"];
    [sdkAdvData setValue:paramProbabilities forKey:@"advParamProbabilities"];
    
    if([_moduleDisableAdvTypes containsObject:typeS]){
        NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%@%@%@%@",@"模块:(",moduleS,@")不支持[",typeS,@"]类型广告,请检查配置"]);
        [self showNextAdv:data :@"" :[[NSString alloc]initWithFormat:@"%@%@%@%@%@",@"模块:(",moduleS,@")不支持[",typeS,@"]类型广告"]];
        return;
    }
    
    //条件限制处理
    if (level == 0) {
        NSLog(@"%s%@%@%@%@%@%@%@",__func__,@"(",moduleS,@")",@"[",typeS,@"]",@"----标示为0，不展示该广告，请检查配置");
    }
    NSLog(@"%s%@%@%@%@%@%@%@%@%@%@",__func__,@"(",moduleS,@")",@"[",typeS,@"]",@"----state值：",[NSString stringWithFormat:@"%d",SDK_ADV_STATE] ,@";level:",[NSString stringWithFormat:@"%d",level]);
    
    if ((SDK_ADV_STATE & level) == 0) {
        [self showNextAdv: data :@"" :[[NSString alloc]initWithFormat:@"%@%@%@%@%@",@"模块:(",moduleS,@")不支持[",typeS,@"]类型广告"]];
        return;
    }
    
    if ([typeS isEqualToString:UL_ADV_SPLAH]) {
        [self showSplashAdv:data];
    } else if([typeS isEqualToString:UL_ADV_INTERSTITIAL]){
        [self showInterstitialAdv:data];
    } else if([typeS isEqualToString:UL_ADV_FULLSCREEN]){
        [self showFullscreenAdv:data];
    } else if([typeS isEqualToString:UL_ADV_VIDEO]){
        [self showVideoAdv:data];
    } else if([typeS isEqualToString:UL_ADV_BANNER]){
        [self showBannerAdv:data];
    } else if([typeS isEqualToString:UL_ADV_EMBEDDED]){
        [self showEmbeddedAdv:data];
    } else if([typeS isEqualToString:UL_ADV_URL]){
        [self showUrlAdv:data];
    } else if([typeS isEqualToString:UL_ADV_ICON]){
        [self showIconAdv:data];
    } else if([typeS isEqualToString:UL_ADV_GIFT]){
        [self showGiftAdv:data];
    }
}

- (void)showNextAdv:(NSDictionary *)data :(NSString *)param :(NSString *)failedReason
{
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    NSString *module = [ULTools GetStringFromDic:sdkAdvData :@"module" :@""];
    NSString *rewardType = [ULTools GetStringFromDic:sdkAdvData :@"rewardType" :@""];
    NSString *advParams = [ULTools GetStringFromDic:sdkAdvData :@"advParams" :@""];
    NSString *advParamProbabilities = [ULTools GetStringFromDic:sdkAdvData :@"advParamProbabilities" :@""];
    
    [sdkAdvData removeObjectForKey:@"type"];
    [sdkAdvData removeObjectForKey:@"module"];
    [sdkAdvData removeObjectForKey:@"rewardType"];
    [sdkAdvData removeObjectForKey:@"advParams"];
    [sdkAdvData removeObjectForKey:@"advParamProbabilities"];
    
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    
    BOOL isStopDispatch = [ULTools GetBoolFromDic:data :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        return;
    }
    
    if (![[ULNotificationDispatcher getInstance] postNotificationWithName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_SHOW_ADV_BASE,advId] withData:data]) {
        if([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]){
            [[ULSplashViewController getInstance]removeSplashView];
        }else{
            [sdkAdvData setValue:type forKey:@"type"];
            [sdkAdvData setValue:module forKey:@"module"];
            [sdkAdvData setValue:rewardType forKey:@"rewardType"];
            [sdkAdvData setValue:advParams forKey:@"advParams"];
            [sdkAdvData setValue:advParamProbabilities forKey:@"advParamProbabilities"];
            [self showFailed:(NSMutableDictionary *)data :param :failedReason];
        }
        
    }else{
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],module,type,@"failed",failedReason,@"",advId,advId,@"",param];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    }
    
}

- (void)showFailed:(NSMutableDictionary *)data :(NSString *)param :(NSString *)failedReason
{
    [ULAdvCallBackManager callBackEntry:failed :data];
    //广告点击统计
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    NSString *module = [ULTools GetStringFromDic:sdkAdvData :@"module" :@""];
    
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],module,type,@"failed",failedReason,@"",advId,advId,@"",param];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
}

- (void)showClicked:(NSMutableDictionary *)data :(NSString *)param
{
    
    //广告点击统计
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    NSString *module = [ULTools GetStringFromDic:sdkAdvData :@"module" :@""];
    
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],module,type,@"clicked",@"",@"",advId,advId,@"",param];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    if(![type isEqualToString:UL_ADV_SPLAH]){
        [ULAdvCallBackManager callBackEntry:clicked :data];
    }
}

- (void)showAdv:(NSMutableDictionary *)data :(NSString *)param
{
    
    //广告展示统计
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    NSString *module = [ULTools GetStringFromDic:sdkAdvData :@"module" :@""];
    if (![type isEqualToString:UL_ADV_VIDEO]) {
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],module,type,@"success",@"",@"",advId,advId,@"",param];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    }
    
    if(![type isEqualToString:UL_ADV_SPLAH]){
        [ULAdvCallBackManager callBackEntry:showed :data];
    }
}

- (void)showClose:(NSMutableDictionary *)data :(NSString *)param
{
    [ULAdvCallBackManager callBackEntry:closed :data];
    //广告展示统计
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    
    if ([type isEqualToString:UL_ADV_VIDEO]) {
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],NSStringFromClass([self class]),type,@"success",@"",@"",advId,advId,@"",param];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    }
}

- (void)showNativeAdvResultSuccess:(NSMutableDictionary *)nativeData :(NSMutableDictionary *)data
{
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:data :@"gameAdvData" :nil ];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:data :@"sdkAdvData" :nil ];
    BOOL isStopDispatch = [ULTools GetBoolFromDic:sdkAdvData :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        return;
    }
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    NSString *rewardTag = [ULTools GetStringFromDic:sdkAdvData :@"rewardTag" :@""];
    
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:gameAdvData :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:1] forKey:@"code"];
    [json setValue:S_CONST_ADV_NATIVE_SUCCESS_DES forKey:@"msg"];
    [json setValue:nativeData forKey:@"nativeData"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [json setValue:type forKey:@"type"];
    [json setValue:rewardTag forKey:@"rewardType"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_OPENNATIVEADVRESULT :json];
}

- (void)showNativeAdvResultFailed:(NSMutableDictionary *)nativeData :(NSMutableDictionary *)data
{
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:data :@"gameAdvData" :nil ];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:data :@"sdkAdvData" :nil ];
    BOOL isStopDispatch = [ULTools GetBoolFromDic:sdkAdvData :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        return;
    }
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:gameAdvData :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
    [json setValue:S_CONST_ADV_NATIVE_FAIL_DES forKey:@"msg"];
    [json setValue:nativeData forKey:@"nativeData"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_OPENNATIVEADVRESULT :json];
}

- (void)showNativeClickResultFailed:(NSMutableDictionary *)data
{
    
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
    [json setValue:S_CONST_ADV_NATIVE_CLICK_FAIL_DES forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLICKNATIVEADVRESULT :json];
}

- (void)showNativeClickResultSucess:(NSMutableDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:1] forKey:@"code"];
    [json setValue:S_CONST_ADV_NATIVE_CLICK_SUCCESS_DES forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLICKNATIVEADVRESULT :json];
}

- (void)showNativeCloseResultSuccess:(NSMutableDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:1] forKey:@"code"];
    [json setValue:S_CONST_ADV_NATIVE_CLOSE_SUCCESS_DES forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLOSENATIVEADVRESULT :json];
}

- (void)showNativeCloseResultFailed:(NSMutableDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
    [json setValue:S_CONST_ADV_NATIVE_CLOSE_FAIL_DES forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLOSENATIVEADVRESULT :json];
}

- (void)showCloseResultSuccess:(NSMutableDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:1] forKey:@"code"];
    [json setValue:S_CONST_ADV_CLOSE_SUCCESS_DES forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLOSEADVRESULT :json];
}

- (void)showCloseResultFailed:(NSMutableDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
    [json setValue:S_CONST_ADV_CLOSE_FAIL_DES forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLOSEADVRESULT :json];
}


- (void)showCloseAllAdvByTypeResultSuccess:(NSMutableDictionary *)data
{
    NSString *type = [ULTools GetStringFromDic:data :@"type" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:1] forKey:@"code"];
    [json setValue:S_CONST_ADV_CLOSE_SUCCESS_DES forKey:@"msg"];
    [json setValue:type forKey:@"type"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLOSEALLADVBYTYPERESULT :json];
}


- (void)pauseSound
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    [ULSDKManager JsonRpcCall:REMSG_CMD_PAUSESOUND :data];
}

- (void)resumeSound
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    [ULSDKManager JsonRpcCall:REMSG_CMD_RESUMESOUND :data];
}

@end



