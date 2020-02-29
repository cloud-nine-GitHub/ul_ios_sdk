//
//  ULInnerPromotion.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULInnerPromotion.h"
#import "ULSKStoreProductViewController.h"
#import "ULTools.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULSDKManager.h"
#import "ULCmd.h"
#import "ULUserDefaults.h"

static NSString *const UL_INTER_PROMOTION_ICON_DEFAULT_BASE_URL = @"http://gamesres.ultralisk.cn/notice/gameIcon/";

@interface ULInnerPromotion ()<SKStoreProductViewControllerDelegate>

@property (nonatomic,strong)NSMutableDictionary *gameIdWithAppleIdDic;
@property (nonatomic,strong)ULSKStoreProductViewController *controller;
@property (nonatomic,strong)NSMutableDictionary *gameIdWithRewardsDic;
@end


@implementation ULInnerPromotion


- (void)onInitModule {
    NSLog(@"%s",__func__);
    
    _gameIdWithAppleIdDic = [NSMutableDictionary new];
    _gameIdWithRewardsDic = [NSMutableDictionary new];
    _controller = [[ULSKStoreProductViewController alloc] init];
    _controller.delegate = self;
    
}


- (void)jumpToOtherGame :(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    NSString *type = [ULTools GetStringFromDic:json :@"type" :@""];
    NSString *gameIndex = [ULTools GetStringFromDic:json :@"gameIndex" :@""];
    
    if (![type isEqualToString:@"reward"]) {
        //检测是否安装
        //测试scheme  yllmjmgame17
        NSString *scheme = [@"game" stringByAppendingPathComponent:gameIndex];
        [self checkAppInstalled:scheme];
        //应该无论是否安装都会跳转。后续会有直接打开已安装应用吗？
        NSString *appleId = [ULTools GetStringFromDic:_gameIdWithAppleIdDic :gameIndex :@""];
        [self jumpToAppstoreWithAppleId:appleId andData:json];
    }else{
        //检测是否安装
        //测试scheme  yllmjmgame17
        NSString *scheme = [@"game" stringByAppendingPathComponent:gameIndex];
        NSString *appleId = [ULTools GetStringFromDic:_gameIdWithAppleIdDic :gameIndex :@""];
        BOOL isInstalled = [self checkAppInstalled:scheme];
        
        if (!isInstalled) {
            
            [self jumpToAppstoreWithAppleId:appleId andData:json];
        }else{
            BOOL isReward = [self getAppRewardStatusWithId:gameIndex];
            if (!isReward) {
                [self jumpOtherGameRewardResult:1 :@"发奖消息" :json];
                //改变发奖状态
                [self saveAppRewardStatusWithId:gameIndex :YES];
            }
            [self jumpToAppstoreWithAppleId:appleId andData:json];
        }
    }
    
    
}

- (void)jumpToAppstoreWithAppleId:(NSString *)appleId andData:(NSDictionary *)json
{
    NSDictionary * dic = @{SKStoreProductParameterITunesItemIdentifier:appleId};
    [_controller loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (result) {
            [self jumpOtherGameResult :1 :@"成功" :json];
        }else{
            [self jumpOtherGameResult :0 :@"失败" :json];
        }
    }];
    [[ULTools getCurrentViewController] presentViewController:_controller animated:YES completion:nil];
}


- (BOOL)checkAppInstalled:(NSString *)scheme
{
    NSLog(@"%s scheme:%@",__func__ ,scheme);
    @try {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[scheme stringByAppendingString:@"://"]]]) {
            NSLog(@"%s 已安装",__func__);
            return YES;
        }else{
            NSLog(@"%s 未安装",__func__);
            return NO;
        }
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%s 检测目标应用是否存在出现异常:%@" ,__func__,exception);
        return NO;
    }
    return NO;
    
}

- (void)jumpOtherGameResult :(int)code :(NSString *)msg :(NSDictionary *)json
{
    NSLog(@"%s downloadResult:%d %@ %@",__func__,code,msg,json);
    NSString *type = [ULTools GetStringFromDic:json :@"type" :@""];
    NSString *userData = [ULTools GetStringFromDic:json :@"userData" :@""];
    NSString *gameIndex = [ULTools GetStringFromDic:json :@"gameIndex" :@""];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [dataDict setValue:msg forKey:@"msg"];
    [dataDict setValue:gameIndex forKey:@"gameIndex"];
    [dataDict setValue:type forKey:@"type"];
    [dataDict setValue:userData forKey:@"userData"];
    
    [ULSDKManager JsonRpcCall:REMSG_CMD_JUMP_OTHER_GAME_RESULT :dataDict];
}


- (void)jumpOtherGameRewardResult :(int)code :(NSString *)msg :(NSDictionary *)json
{
    NSLog(@"%s downloadResult:%d %@ %@",__func__,code,msg,json);
    NSString *type = [ULTools GetStringFromDic:json :@"type" :@""];
    NSString *userData = [ULTools GetStringFromDic:json :@"userData" :@""];
    NSString *gameIndex = [ULTools GetStringFromDic:json :@"gameIndex" :@""];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [dataDict setValue:msg forKey:@"msg"];
    [dataDict setValue:gameIndex forKey:@"gameIndex"];
    [dataDict setValue:type forKey:@"type"];
    [dataDict setValue:userData forKey:@"userData"];
    NSMutableArray *rewards = [ULTools GetMutableArrayFromDic:_gameIdWithRewardsDic :gameIndex :nil];
    [dataDict setValue:rewards forKey:@"rewards"];
    
    [ULSDKManager JsonRpcCall:REMSG_CMD_JUMP_OTHER_GAME_REWARD_RESULT :dataDict];
}







// Sent if the user requests that the page be dismissed
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController __TVOS_PROHIBITED NS_AVAILABLE_IOS(6_0)
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%s退出下载页面",__func__);
    
}





- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    NSDictionary *json = [ULTools StringToDictionary: param];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_OPEN_JUMP]) {
        [self getJumpData:data];
    }else if([cmd isEqualToString:MSG_CMD_JUMP_OTHER_GAME]){
        [self jumpToOtherGame:data];
    }
    
    return nil;
}

- (void)getJumpData:(NSDictionary *)data
{
    NSLog(@"%s",__func__);
    NSString *type = [ULTools GetStringFromDic:data :@"type" :@""];
    NSString *userData = [ULTools GetStringFromDic:data :@"userData" :@""];
    int count = [ULTools GetIntFromDic:data :@"count" :0];//默认返回全部条数
    NSString *innerData = [ULTools getCopOrConfigStringWithKey:@"s_sdk_inner_promotion_data" withDefaultString:@""];
    //游戏标识；苹果id；icon地址后标；应用名称；物品id-物品数量，物品id-物品数量
    //"23;1285648562;23;叶罗丽精灵梦;1-50,2-100|31;1293648542;31;小花仙守护天使;1-50,2-100|34;1285648562;34;小花仙精灵之翼;1-50,2-100"
    /**
     
     {
     “cmd”:/c/openJumpResult”,
     “data”:{
     “jumpInfo”:[
     {“index:string(游戏的唯一id，海外这边需要带上语言70_zhcn)
     “url”:string (海外版由于没有海外CDN服务器，将图片配置在游戏内。使用gameIndex进行索引)
     “reward”:[][]([[itemId, amount]]
         [[1,40]])（itemId为金币或钻石类型的代号，amount即数量）
     “bReceived”:boolean(奖励领取状态)
     ]，
     “type”:string(原样返回)
     “count”:number(原样返回
     “userData”:string透传字段
     }
     }
     */
    
    NSArray *innerDataArray = [innerData componentsSeparatedByString:@"|"];
    
    NSMutableArray *jumpInfoArray = [NSMutableArray new];
    
    
    for (NSString *itemData in innerDataArray) {
        NSArray *itemDataArray = [itemData componentsSeparatedByString:@";"];
        if (itemDataArray.count != 5) {
            NSLog(@"%s%@",__func__,@":检测到元组数据未按要求配置");
            continue;
        }
        NSMutableDictionary *jumpInfoItem = [NSMutableDictionary new];
        NSMutableArray *jumpInfoItemRewardsArray = [NSMutableArray new];
        
        NSString *gameId = itemDataArray[0];//游戏标识
        NSString *appleId = itemDataArray[1];//游戏苹果后台分配的id
        if (![[_gameIdWithAppleIdDic allKeys] containsObject:gameId]) {
            [_gameIdWithAppleIdDic setValue:appleId forKey:gameId];
        }
        
        NSString *iconIndex = itemDataArray[2];//icon地址后缀。如果想要其他图片那么就是23_ohter
        NSString *appName = itemDataArray[3];//应用名称
        NSString *rewards = itemDataArray[4];
        NSArray *rewardsArray = [rewards componentsSeparatedByString:@","];
        for (NSString *rewardItem in rewardsArray) {
            NSArray *rewardItemArray = [rewardItem componentsSeparatedByString:@"-"];
            NSString *rewardId = rewardItemArray[0];//奖励物品id
            NSString *rewardCount = rewardItemArray[1];//奖励物品数量
            NSMutableArray *itemRewardArray = [NSMutableArray new];
            [itemRewardArray addObject:rewardId];
            [itemRewardArray addObject:rewardCount];
            [jumpInfoItemRewardsArray addObject:itemRewardArray];
        }
        if (![[_gameIdWithRewardsDic allKeys] containsObject:gameId]) {
            [_gameIdWithRewardsDic setValue:jumpInfoItemRewardsArray forKey:gameId];
        }
        
        
        
        
        [jumpInfoItem setValue:gameId forKey:@"index"];
        NSString *iconBaseUrl = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_inner_promotion_icon_baseurl" :@""];
        if (iconBaseUrl == nil || [iconBaseUrl isEqualToString:@""]) {
            iconBaseUrl = UL_INTER_PROMOTION_ICON_DEFAULT_BASE_URL;
        }
        NSString *iconUrl = [iconBaseUrl stringByAppendingString: iconIndex];
        iconUrl = [iconUrl stringByAppendingString:@".png"];
        [jumpInfoItem setValue:iconUrl forKey:@"url"];
        [jumpInfoItem setValue:appName forKey:@"appName"];//可选
        [jumpInfoItem setValue:jumpInfoItemRewardsArray forKey:@"rewards"];
        [jumpInfoItem setValue:[NSNumber numberWithBool:[self getAppRewardStatusWithId:gameId]] forKey:@"bReceived"];
        
        [jumpInfoArray addObject:jumpInfoItem];
        
        
    }
    
    if (count > 0) {
        if (count < [jumpInfoArray count]) {//请求条数小于配置条数，则随机配置前面对应条数。其他情况全部返回
            [jumpInfoArray removeObjectsInRange:NSMakeRange(count, [jumpInfoArray count]-1)];
        }
    }
    
    //返回
    NSMutableDictionary *openJumpResultDic = [NSMutableDictionary new];
    [openJumpResultDic setValue:jumpInfoArray forKey:@"jumpInfo"];
    [openJumpResultDic setValue:type forKey:@"type"];
    [openJumpResultDic setValue:[NSNumber numberWithInt:count] forKey:@"count"];
    [openJumpResultDic setValue:userData forKey:@"userData"];
    
    [ULSDKManager JsonRpcCall:REMSG_CMD_OPEN_JUMP_RESULT :openJumpResultDic];
    
}

//获取推送app是否已经发奖
- (BOOL)getAppRewardStatusWithId:(NSString *)gameid
{
    NSLog(@"%s",__func__);
    NSString *appRewardStatus = [ULUserDefaults readDataFromUserDefault:@"s_sdk_open_jump_app_reward_status"];
    if (!appRewardStatus) {
        return NO;
    }
    NSDictionary *appRewardStatusDic = [ULTools StringToDictionary:appRewardStatus];
    id status = [appRewardStatusDic objectForKey:gameid];
    if (!status) {
        return NO;
    }
    return [status boolValue];
}



//保存推送app发奖状态
- (void)saveAppRewardStatusWithId:(NSString *)gameid :(BOOL)status
{
    NSLog(@"%s",__func__);
    NSString *appRewardStatus = [ULUserDefaults readDataFromUserDefault:@"s_sdk_open_jump_app_reward_status"];
    if (!appRewardStatus) {
        NSMutableDictionary *appRewardStatusDic = [NSMutableDictionary new];
        [appRewardStatusDic setValue:[NSNumber numberWithBool:status] forKey:gameid];
        appRewardStatus = [ULTools DictionaryToString:appRewardStatusDic];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:appRewardStatus forKey:@"s_sdk_open_jump_app_reward_status"];
        [ULUserDefaults writeDataToUserDefault:dic];
        return;
    }
    NSDictionary *appRewardStatusDic = [ULTools StringToDictionary:appRewardStatus];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    for (NSString *key in [appRewardStatusDic allKeys]) {
        [dic setValue:[appRewardStatusDic objectForKey:key] forKey:key];
    }
    [dic setValue:[NSNumber numberWithBool:status] forKey:gameid];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    [dic1 setValue:[ULTools DictionaryToString:dic] forKey:@"s_sdk_open_jump_app_reward_status"];
    [ULUserDefaults writeDataToUserDefault:dic1];
    
}


- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo
{
    NSLog(@"%s",__func__);
    NSString *isCloseCop = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_close_cop" :@"0"];
    if ([isCloseCop isEqualToString:@"1"]) {
        //对于不使用cop而使用本地配置的情况，下列配置依然需要返回
        //是否显示互推按钮
        NSString *inner = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_inner_promotion_data" :@""];
        if (inner && ![inner isEqualToString:@""]) {
            [baseChannelInfo setValue:[NSNumber numberWithBool:true] forKey:@"isSupportJumpList"];
        }else{
            [baseChannelInfo setValue:[NSNumber numberWithBool:false] forKey:@"isSupportJumpList"];
        }
    }
    [ULSDKManager setBaseChannelInfo:baseChannelInfo];
    return nil;
}


- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr
{
    NSLog(@"%s",__func__);
    return nil;
}


@end
