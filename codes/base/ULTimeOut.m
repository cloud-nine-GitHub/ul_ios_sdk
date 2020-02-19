//
//  ULTimeOut.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/11.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULTimeOut.h"
#import "ULTools.h"
#import "ULCmd.h"
#import "ULStringConst.h"
#import "ULTimer.h"
#import "ULAdvCallBackManager.h"

static int const UL_ADV_DEFAULT_TIMEOUT_TIME = 30;//单位秒

@implementation ULTimeOut

+ (void)startTimeOutTask:(NSMutableDictionary *)json
{
    NSString *isCloseTimeOut = [ULTools getCopOrConfigStringWithKey:@"s_sdk_close_timeout_system" withDefaultString:@"0"];
    if ([isCloseTimeOut isEqualToString:@"1"]) {
        NSLog(@"%s%@",__func__,@"关闭超时处理");
        return;
    }
    NSString *cmd = [ULTools GetStringFromDic:json :@"cmd" :@""];
    NSMutableDictionary *data = [ULTools GetNSMutableDictionaryFromDic:json :@"data" :nil];
    if ([cmd isEqualToString:MSG_CMD_OPENADV]) {
        [self createAdvTask:data];
    }
}


+ (void)createAdvTask :(NSMutableDictionary *)data
{
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    if ([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]) {
        return;
    }
    NSString *delayTimeStr = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_request_timeout" withDefaultString:[NSString stringWithFormat:@"%d",UL_ADV_DEFAULT_TIMEOUT_TIME] ];
    float delayTime = [delayTimeStr floatValue];
    
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequestSerialNum];
    NSString *timerName = [[NSString alloc]initWithFormat:@"%@%@%@",advId,@"_",advRequestSerialNumStr];
    NSLog(@"%s%@",__func__,[[NSString alloc] initWithFormat:@"%@%@",@"创建广告超时任务:",timerName]);
    
    [[ULTimer getInstance]startTimerWithName:timerName  withTarget:self withTime:delayTime withSel:@selector(timerBlock:) withUserInfo:data withRepeat:NO];
}

//timer回调函数
+ (void)timerBlock:(NSTimer *)timer
{
    NSLog(@"%s%@",__func__,@"超时回调");
    NSMutableDictionary *advData = [timer userInfo];
    [ULAdvCallBackManager callBackEntry:timeout :advData];//超时回调
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:advData :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:advData :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequestSerialNum];
    [[ULTimer getInstance]destroyTimerWithName:[[NSString alloc]initWithFormat:@"%@%@%@",advId,@"_",advRequestSerialNumStr]];
}


+ (void)stopTimeOutTask:(NSMutableDictionary *)rpcCallJson
{
    NSString *isCloseTimeOut = [ULTools getCopOrConfigStringWithKey:@"s_sdk_close_timeout_system" withDefaultString:@"0"];
     if ([isCloseTimeOut isEqualToString:@"1"]) {
         NSLog(@"%s%@",__func__,@"关闭超时处理");
         return;
     }
    NSString *cmd = [ULTools GetStringFromDic:rpcCallJson :@"cmd" :@""];
    NSMutableDictionary *data = [ULTools GetNSMutableDictionaryFromDic:rpcCallJson :@"data" :nil];
    if ([cmd isEqualToString:REMSG_CMD_OPENADVRESULT]) {
        [self stopAdvTask:data];
    }
}

+ (void)stopAdvTask:(NSMutableDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    if ([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]) {
        return;
    }
    long advRequestSerialNum = [ULTools GetLongFromDic:data :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequestSerialNum];
    NSString *timerName = [[NSString alloc]initWithFormat:@"%@%@%@",advId,@"_",advRequestSerialNumStr];
    if([[ULTimer getInstance]hasTimerWithName:timerName]){
        NSLog(@"%s%@",__func__,[[NSString alloc] initWithFormat:@"%@%@",@"结束广告超时任务:",timerName]);
        //结束定时任务
        [[ULTimer getInstance]destroyTimerWithName:timerName];
    }
    
}

@end
