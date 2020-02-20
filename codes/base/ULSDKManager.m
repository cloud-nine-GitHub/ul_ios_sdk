//
//  ULSDKManager.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/21.
//  Copyright © 2018 ul_mac04. All rights reserved.
//
/**
 
 
 
 ulsdk ios 版本
 总体流程：
 1、根据需求编写task的json文件
 2、利用批处理，出对应的cConfig.json文件和对应模块的xCode工程
 3、启动第一时间获取cConfig中的相关配置和cop配置
 4、初始化完毕后展示相关splash并且根据cop获得的初始化列表初始化sdk
 5、完成sdk相关后续功能
 
 
 
 同一使用NSMutableDictionary类型，因为你不知道什么时候调用的某个函数中的字典类型是否需要修改
 */


#import "ULSDKManager.h"
#import "ULNotification.h"
#import "ULCmd.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULModuleBaseSdk.h"
#import "ULConfig.h"
#import "ULModuleBaseAdv.h"
#import "ULAdvBean.h"
#import "ULRequestManager.h"
#import "ULAdvCallBackManager.h"
#import "ULStringConst.h"
#import "ULTimeOut.h"
#import "ULSplashViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ULWebView.h"
#import "ULMoreGame.h"

@interface ULSDKManager ()



@end

static NSString *const MC_SDK_MANAGER_CLASS_NAME = @"MCULManager";

@implementation ULSDKManager


static NSMutableDictionary *moduleClassDic = nil;
static NSMutableDictionary *moduleObjDic = nil;
static long advRequestSerialNum = 0;
static BOOL isSetVersion = NO;
static NSMutableArray *remsgList = nil;
static double currentVolume = 0.00;

+ (void)init{
    NSLog(@"%s",__func__);
    
    moduleClassDic = [[NSMutableDictionary alloc]init];
    moduleObjDic = [[NSMutableDictionary alloc]init];
    remsgList = [NSMutableArray new];
    //获取当前系用的音量大小
    currentVolume = [AVAudioSession sharedInstance].outputVolume;
    NSLog(@"%s%f",__func__,currentVolume);
    //设置音量按键监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //设置sdk基本渠道配置信息
    baseChannelInfo = [self ResultChannelInfo];
    //初始化基类
    [ULModuleBaseSdk init];
    //初始化请求管理类
    [ULRequestManager init];
    //初始化广告回调管理类
    [ULAdvCallBackManager init];
    //初始化模块
    [self initModuleClass];
    
    //注册initAdv函数调用消息,cop拿到后随时都能初始化
    [[ULNotificationDispatcher getInstance] addNotificationWithObserverOnce:self withName:UL_NOTIFICATION_MANAGER_INIT_ADV withSelector:@selector(initAdv) withPriority:PRIORITY_NONE];
}

//广告配置解析及广告模块初始化函数调用
+ (void)initAdv
{
    NSLog(@"%s",__func__);
    NSDictionary *showListObject = [ULTools getCopOrConfigDictionaryWithKey:@"o_sdk_adv_show_list" withDefaultString:nil];
    if (!showListObject) {
        NSLog(@"%s%@",__func__,@"adv show list is null,请检查cop配置");
        return;
    }
    
    //广告买点tags对象
    NSDictionary *advTagsObject = [ULTools GetNSDictionaryFromDic:showListObject :@"advTags" :nil];
    if (!advTagsObject) {
        NSLog(@"%s%@",__func__,@"adv tags is null,请检查cop配置");
        return;
    }
    
    //广告模版temples对象
    NSDictionary *advTemplatesObject = [ULTools GetNSDictionaryFromDic:showListObject :@"advTemplates" :nil];
    if (!advTemplatesObject) {
        NSLog(@"%s%@",__func__,@"adv templates is null,请检查cop配置");
        return;
    }
    
    //开始解析
    //step1: 广告模块对象已经统一创建，这里无需再次处理
    NSMutableArray *initAdvModuleArray = [NSMutableArray new];
    //step2: 创建模块广告对象，绑定数据
    NSMutableDictionary *advBeanWithTemplateMutDic = [NSMutableDictionary new];
    NSArray *templateKeys = [advTemplatesObject allKeys];
    for (NSString *key in templateKeys) {
        NSObject *value = [advTemplatesObject objectForKey:key];
        if (!value || ![value isKindOfClass :[NSDictionary class]]) {
            NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%@%@",@"广告模版[",key,@"]配置异常，请检查cop配置"]);
            continue;
        }
        NSDictionary *valueDic = (NSDictionary *)value;
        NSString *advModule = [ULTools GetStringFromDic:valueDic :@"channel" :@""];
        if (![initAdvModuleArray containsObject:advModule]) {
            [initAdvModuleArray addObject:advModule];
        }
        NSString *advType = [ULTools GetStringFromDic:valueDic :@"type" :@""];
        NSString *advRewardType = [ULTools GetStringFromDic:valueDic :@"rewardType" :@""];
        NSArray *advParams = [ULTools GetArrayFromDic:valueDic :@"params" :[NSArray new]];
        if ([advParams count] == 0) {
            NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%@%@",@"广告模版[",key,@"]参数列表配置异常，请检查cop配置"]);
        }
        NSArray *advParamProbabilitys = [ULTools GetArrayFromDic:valueDic :@"paramProbabilitys" :[NSArray new]];
        ULAdvBean *bean = [[ULAdvBean alloc]initWithModule:advModule andType:advType andRewardTag:advRewardType andParams:advParams andParamProbabilities:advParamProbabilitys];
        
        [advBeanWithTemplateMutDic setValue:bean forKey:key];
    }
    
    //step3
    //step4
    NSMutableDictionary *advBeansWithTagMutDic = [NSMutableDictionary new];
    NSArray *tagKeys = [advTagsObject allKeys];
    for (NSString *key in tagKeys) {
        NSObject *value = [advTagsObject objectForKey:key];
        if (!value || ![value isKindOfClass :[NSDictionary class]]) {
            NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%@%@",@"广告埋点[",key,@"]配置异常，请检查cop配置"]);
            continue;
        }
        NSDictionary *valueDic = (NSDictionary *)value;
        NSArray *temples = [ULTools GetArrayFromDic:valueDic :@"temples" :[NSArray new]];
        NSArray *levels = [ULTools GetArrayFromDic:valueDic :@"levels" :[NSArray new]];
        NSMutableArray *beans = [NSMutableArray new];
        for (int i = 0; i < [temples count]; i++) {
            NSString *temple = temples[i];
            int level = [levels[i] intValue];
            ULAdvBean *bean = [advBeanWithTemplateMutDic objectForKey:temple];
            if (bean) {
                if (bean.priority != 0) {
                    ULAdvBean *newBean = [[ULAdvBean alloc] initWithModule:bean.module andType:bean.type andRewardTag:bean.rewardTag andParams:bean.params andParamProbabilities:bean.paramsProbability andPriority:(int)temples.count - i andLevel:level];
                    [beans addObject:newBean];
                }else{
                    bean.priority = (int)temples.count - i;
                    bean.level = level;
                    [beans addObject:bean];
                }
            }else{
                NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%@%@%@%@",@"当前广告埋点[",key,@"]所配置的广告模版[",temple,@"]不存在,请检查cop配置"]);
            }
            
        }
        [advBeansWithTagMutDic setValue:beans forKey:key];
    }
    
    //step5 调用广告初始化函数
    for (NSString *module in initAdvModuleArray) {
        ULModuleBaseAdv *advObj = [moduleObjDic objectForKey:module];
        if (!advObj) {
            NSLog(@"%s%@",__func__,@"未创建对象的模块不调用广告初始化函数");
            continue;
        }
        //设置对应广告所在模块的消息监听
        NSMutableDictionary *advTargetModuleBeansMutDic = [NSMutableDictionary new];
        NSArray *keys = [advBeansWithTagMutDic allKeys];
        for (NSString *key in keys) {
            NSArray *beans = [advBeansWithTagMutDic objectForKey:key];
            NSMutableArray *array = [NSMutableArray new];
            for (ULAdvBean *bean in beans) {
                NSString *m = bean.module;
                if ([module isEqualToString:m]) {
                    [array addObject:bean];
                }
            }
            [advTargetModuleBeansMutDic setValue:array forKey:key];
        }
        [advObj initModuleBaseAdv:advTargetModuleBeansMutDic];
    }
}

+ (void)initModuleClass
{
    [self initModuleClassWithClassList:[ULConfig getModuleList] withSuperClassName:nil];
}


//模块对象创建
+ (void)initModuleClassWithClassList:(NSArray *)moduleNameList withSuperClassName:(Class )classFilter
{
    for (NSString *aModuleNameList in moduleNameList) {
        
        Class class = NSClassFromString(aModuleNameList);
        if (class == nil) {
            NSLog(@"%s:%@%@%@",__func__,@"the class [",aModuleNameList,@"] not found");
            continue;
        }
        
        if ([moduleClassDic objectForKey:aModuleNameList]) {
            //该模块已经初始化
            continue;
        }
        
        if (classFilter != nil && ![aModuleNameList isKindOfClass:classFilter]) {
            continue;
        }
        [moduleClassDic setValue:class forKey:aModuleNameList];
        
        id classObj = [[class alloc] init];
        [moduleObjDic setValue:classObj forKey:aModuleNameList];
        
    }
}



+ (void)JsonAPI :(NSString *)jsonStr
{
    NSLog(@"%s:%@",__func__,jsonStr);
    NSDictionary *json = [ULTools StringToDictionary: jsonStr];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_SETVERSION]) {
        isSetVersion = YES;
        //清空缓存消息
        [self JsonRpcCallQueue];
        //该消息只返回sdk相关基础配置，具体cop相关配置由相应接口返回
        [self JsonRpcCall:REMSG_CMD_CHANNELINFORESULT:baseChannelInfo];
        //在setVersion调用后发送一条消息，按需去注册消息
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_SETVERSION withData:nil];
    }else if([cmd isEqualToString:MSG_CMD_OPENPAY]){
        [self openPay:(NSDictionary *)data];
    }else if([cmd isEqualToString:MSG_CMD_OPENADV]){
        [self openAdv:(NSDictionary *)data];
    }else if([cmd isEqualToString:MSG_CMD_EXITGAME]){
        //ios应该没有退出一说。do nothing
    }else if([cmd isEqualToString:MSG_CMD_OPENWEBVIEW]){
        [ULWebView showWebView:data];
    }else if([cmd isEqualToString:MSG_CMD_OPENULMOREGAME]){
        [ULMoreGame showMoreGame];
    }else if([cmd isEqualToString:MSG_CMD_OPENSHARE]){
        
    }else{
        //manager中只需要处理基础流程。 模块根据自身需求去监听其他cmd消息
        [[ULNotificationDispatcher getInstance]postNotificationWithName:cmd withData:data];
    }
    
}




+ (void)JsonRpcCall :(NSString *)cmd :(NSMutableDictionary *)dataDic{
    //在主线程中进行回调
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *rpcCallJsonObj = [[NSMutableDictionary alloc]init];
        [rpcCallJsonObj setValue:cmd forKey:@"cmd"];
        [rpcCallJsonObj setValue:dataDic forKey:@"data"];
        NSString *rpcCallJsonObjStr = [ULTools DictionaryToString:rpcCallJsonObj];
        NSLog(@"%s%@",__func__,rpcCallJsonObjStr);
        //结束超时任务
        [ULTimeOut stopTimeOutTask:rpcCallJsonObj];
        //结束请求任务
        [ULRequestManager destroyRequestTask:rpcCallJsonObj];
        //移除返回数据中的请求序列号
        if([cmd isEqualToString:REMSG_CMD_OPENADVRESULT]){
            [dataDic removeObjectForKey:@"requestSerialNum"];
            [rpcCallJsonObj setValue:dataDic forKey:@"data"];
            rpcCallJsonObjStr = [ULTools DictionaryToString:rpcCallJsonObj];
        }
        
        //在未收到setVersion消息之前不给客户端发送消息，先将消息进行缓存
        if (!isSetVersion) {
            [remsgList addObject:rpcCallJsonObjStr];
            NSLog(@"%s%@",__func__,@"未收到setVersion消息，当前消息无法返回给客户端");
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_RESPONSE object:nil userInfo:@{
                @"responseStr":rpcCallJsonObjStr
            }];
        }
    });
    
}


+ (void)JsonRpcCallQueue
{
    if (remsgList.count == 0) {
        return;
    }
    for (NSString *remsg in remsgList) {
        NSLog(@"%s%@",__func__,remsg);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_RESPONSE object:nil userInfo:@{
                @"responseStr":remsg
            }];
        });
    }
    [remsgList removeAllObjects];
}



+ (NSMutableDictionary *)ResultChannelInfo
{
    NSMutableDictionary *channeInfoDic = [NSMutableDictionary new];
    //返回cdk渠道id
    [channeInfoDic setValue:[ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cdk_channel_id" :@"0"] forKey:@"cdkChannelId"];
    //返回cop渠道id
    [channeInfoDic setValue:[ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cop_channel_id" :@"0"] forKey:@"copChannelId"];
    //返回ulsdk版本
    [channeInfoDic setValue:[ULConfig getUlsdkVersion] forKey:@"ulsdkVersion"];
    return channeInfoDic;
}



+ (void)openPay:(NSDictionary *)data
{
    NSLog(@"%s:%@",__func__,[ULTools DictionaryToString:data]);
    //目前只有iOS内购，需要按照android照来？
    NSString *payId = [data objectForKey:@"payId"];
    int payPolicy = [ULModuleBaseSdk getBasePayInfoPolicyWithPayId:payId];
    //添加一层，方便sdk内部传输数据
    NSMutableDictionary *sdkData = [NSMutableDictionary new];
    NSMutableDictionary *payData = [NSMutableDictionary new];
    [payData setValue:sdkData forKey:@"sdkPayData"];
    [payData setValue:data forKey:@"gamePayData"];
    switch (payPolicy) {
        case PAY_POLICY_DEFAULT:
        default:
            //先通知做好支付准备。初始化模块支付消息等
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_PREOPEN_PAY withData:payData];
            
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_OPEN_PAY withData:payData];
            break;
        case PAY_POLICY_ULPAY:
            
            break;
    }
}

+ (void)openAdv:(NSDictionary *)data
{
    NSLog(@"%s:%@",__func__,[ULTools DictionaryToString:data]);
    NSMutableDictionary *advData = [NSMutableDictionary new];
    [advData setValue:data forKey:@"gameAdvData"];
    NSMutableDictionary *sdkAdvData = [NSMutableDictionary new];
    long num = advRequestSerialNum + 1;
    [self setAdvRequestSerialNum:num];
    [sdkAdvData setValue:[NSNumber numberWithLong: [self getAdvRequestSerialNum]] forKey:@"requestSerialNum"];
    [advData setValue:sdkAdvData forKey:@"sdkAdvData"];
    
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    
    //判断当前是否已有广告请求
    if ([ULRequestManager getRequestTaskState:MSG_CMD_OPENADV :advData]) {
        NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%@%@%@",@"广告展示中，请勿重复展示",MSG_CMD_OPENADV,@"_",advId]);
        [ULAdvCallBackManager callBackExit:0 :S_CONST_ADV_FAIL_DES :advData];
    }
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:MSG_CMD_OPENADV forKey:@"cmd"];
    [json setValue:advData forKey:@"data"];
    //创建广告请求任务
    [ULRequestManager createRequestTask:json];
    //创建超时任务
    [ULTimeOut startTimeOutTask:json];
    [ULAdvCallBackManager callBackInit:advData];
    //开始调用聚合流程
    [[ULNotificationDispatcher getInstance] postNotificationWithName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_PREPARE_SHOW_ADV_BASE,advId]  withData:advData];
    
    BOOL hasShowAdv = [[ULNotificationDispatcher getInstance] postNotificationWithName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_SHOW_ADV_BASE,advId] withData:advData];
    
    if (!hasShowAdv) {
        if ([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]) {
            //销毁开屏所在controller
            [[ULSplashViewController getInstance] removeSplashView];
        }else{
            [ULAdvCallBackManager callBackExit:0 :S_CONST_ADV_FAIL_DES :advData];
        }
    }
}


+ (void)exitGame:(NSDictionary *)data
{
    NSLog(@"%s:%@",__func__,[ULTools DictionaryToString:data]);
}


+ (long)getAdvRequestSerialNum
{
    return advRequestSerialNum;
}

+ (void)setAdvRequestSerialNum:(long)num
{
    advRequestSerialNum = num;
}



//-----生命周期-----
//生命周期函数
+ (void)applicationWillResignActive {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_APPLICATION_WILL_RESIGN_ACTIVE object:nil userInfo:nil];
}

+ (void)applicationDidEnterBackground {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_APPLICATION_DID_ENTER_BACKGROUND object:nil userInfo:nil];
}


+ (void)applicationWillEnterForeground {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_APPLICATION_WILL_ENTER_FOREGROUND object:nil userInfo:nil];
}


//TODO 此生命周期在第一个viewController展示出来之后就会立即被触发，此时sdk各模块并未初始化，无法监听此消息
+ (void)applicationDidBecomeActive {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_APPLICATION_DID_BECOME_ACTIVE object:nil userInfo:nil];
}


+ (void)applicationWillTerminate {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_APPLICATION_WILL_TERMINATE object:nil userInfo:nil];
}

+ (void)applicationDidReceiveMemoryWarning {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:UL_NOTIFICATION_APPLICATION_DID_RECEIVE_MEMORYWARNING object:nil userInfo:nil];
}

+ (void)volumeDidChange:(NSNotification *)notification

{
    if([notification.name isEqualToString:@"AVSystemController_SystemVolumeDidChangeNotification"]){
        NSDictionary *userInfo = notification.userInfo;
        if ([userInfo[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"]) {
            NSLog(@"%s%@",__func__,@"点击音量键静音");
            //需要区分音量加还是音量减
            NSString *param = @"";
            //获取触发音量按键后的声音
            double volume = [userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
            if(currentVolume == 0){
                if ((volume - currentVolume) > 0.00){//音量加
                    param = @"+";
                }else{//音量减
                    param = @"-";
                }
            }else{
                if ((volume - currentVolume) >= 0.00){//音量加
                    param = @"+";
                }else{//音量减
                    param = @"-";
                }
            }
            
            currentVolume = volume;
            NSLog(@"%s%f%@",__func__,currentVolume,param);
            NSString *methodName = @"volumeChangeListenerWithBtn:";
            Class class = NSClassFromString(MC_SDK_MANAGER_CLASS_NAME);
            if (class != nil) {
                SEL sel = NSSelectorFromString(methodName);
                if([class respondsToSelector:sel])
                {
                    IMP imp = [class methodForSelector:sel];
                    void (*func)(Class, SEL, id) = (void (*)(Class,SEL,id))imp;
                    func(class,sel,param);
                }else{
                    NSLog(@"%s:%@[%@]%@",__func__,@"no ",methodName,@" method in mc sdk manager class");
                }
            }else{
                NSLog(@"%s:%@",__func__,@"no mc sdk manager class");
            }
        }
    }
    

}

//销毁的时候，移除监听

//[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];

 //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];


@end
