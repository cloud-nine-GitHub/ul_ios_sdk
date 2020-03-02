//
//  ULUmeng.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/2.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULUmeng.h"
#import "ULILifeCycle.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMAnalytics/MobClickGameAnalytics.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "ULCop.h"
#import "ULConfig.h"
#import "ULTools.h"
#import "ULCmd.h"

@interface ULUmeng ()<ULILifeCycle>

@end

@implementation ULUmeng


- (void)onInitModule
{
    NSLog(@"%s",__func__);
    NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_account_umeng_appkey" :@""];
    
    [UMConfigure setLogEnabled:NO];
    /** 初始化友盟所有组件产品
    @param appKey 开发者在友盟官网申请的AppKey.
    @param channel 渠道标识，可设置nil表示"App Store".
    */
    [UMConfigure initWithAppkey:appKey channel:nil];
    
    
    [MobClick setScenarioType:E_UM_GAME];//支持游戏场景
    [UMCommonLogManager setUpUMCommonLogManager];
        

}


- (void)megadataAccount :(NSArray *)data
{

    NSLog(@"%s",__func__);
    if (!data || data.count == 0) {
        return;
    }
    
    NSString *actionTypeStr = data[0];
    if ([actionTypeStr isEqualToString:@"gameLevelStart"]) {
        [self gameLevelStart:data];
    }else if([actionTypeStr isEqualToString:@"gameLevelComplete"]){
        [self gameLevelComplete:data];
    }else if([actionTypeStr isEqualToString:@"gameCoinAdd"]){
        [self gameCoinAdd:data];
    }else if([actionTypeStr isEqualToString:@"gameCoinLost"]){
        [self gameCoinLost:data];
    }else if([actionTypeStr isEqualToString:@"itemBuy"]){
        [self itemBuy:data];
    }else if([actionTypeStr isEqualToString:@"buyAction"]){
        [self buyAction:data];
    }else if([actionTypeStr isEqualToString:@"commonEvent"]){
        [self commonEvent:data];
    }else if([actionTypeStr isEqualToString:@"commonEventMultiField"]){
        [self commonEventMultiField:data];
    }

    
    
}


//关卡统计开始
- (void)gameLevelStart:(NSArray* )array
{
    NSString *level = array[1];
    [MobClickGameAnalytics startLevel:level];
    
}


//闯关完成
-(void)gameLevelComplete:(NSArray *)array
{
    NSString *level = array[1];
    NSString *passResult = array[2];
    if ([passResult isEqualToString:@"0"]) {
        [MobClickGameAnalytics failLevel:level];
    }else if([passResult isEqualToString:@"1"]){
        [MobClickGameAnalytics finishLevel:level];
    }
    
}


//游戏币增加
-(void)gameCoinAdd:(NSArray *)array
{
    NSString *coinType = array[1];
    NSString *addNum = array[2];
    NSString *reason = array[3];
    NSString *name = [[NSString alloc] initWithFormat:@"%@%@%@",reason,@"/",coinType];
    [MobClickGameAnalytics bonus:name amount:1 price:[addNum intValue] source:3];
    
    
}

//游戏币消耗
-(void)gameCoinLost:(NSArray *)array
{
    NSString *coinType = array[1];
    NSString *lostNum = array[2];
    NSString *reason = array[3];
    NSString *name = [[NSString alloc] initWithFormat:@"%@%@%@",reason,@"/",coinType];
    [MobClickGameAnalytics use:name amount:1 price:[lostNum intValue]];
}

//通用自定义事件
-(void)commonEvent:(NSArray *)array
{
    NSString *content = array[1];
    [MobClick event:content];
    
}

//道具购买（消耗游戏币）
-(void)itemBuy:(NSArray *)array
{
    
    NSString *goodsName = array[1];
    NSString *account = array[2];
    //NSString *reason = array[3];
    [MobClickGameAnalytics buy:goodsName amount:[account intValue] price:0];
    
}

//购买行为
- (void)buyAction: (NSArray *)array
{
    
}


- (void)commonEventMultiField: (NSArray *)array
{
    
}



//充值
-(void)userPaySuccess:(NSDictionary *)data
{
    int code = [ULTools GetIntFromDic:data :@"code" :-1];
    if (code == 1) {
        NSString *payId = [ULTools GetStringFromDic:data :@"payId" :@""];
        NSDictionary *payInfoObj = [ULTools GetNSDictionaryFromDic:[ULConfig getConfigInfo] :@"s_sdk_common_base_pay_info" :nil];
        NSDictionary *payIdDic = [ULTools GetNSDictionaryFromDic:payInfoObj :payId :nil];
        NSString *price = [ULTools GetStringFromDic:payIdDic :@"price" :@"0"];
        NSString *proName = [ULTools GetStringFromDic:payIdDic :@"proName" :@""];
        [MobClickGameAnalytics pay:[price doubleValue]/100 source:1 item:proName amount:1 price:0];
    }
}






- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}


- (void)addListener
{
    NSLog(@"%s",__func__);
}




- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    NSDictionary *json = [ULTools StringToDictionary: param];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_MEGADATASERVER]) {
        [self megadataAccount:data];
    }
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
    NSDictionary *json = [ULTools StringToDictionary: jsonRpcCallStr];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:REMSG_CMD_PAYRESULT]) {
        [self userPaySuccess:data];
    }
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


@end
