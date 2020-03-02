//
//  ULRequestManager.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/10.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULRequestManager.h"
#import "ULTools.h"
#import "ULCmd.h"
#import "ULStringConst.h"

@implementation ULRequestManager

static NSMutableDictionary *requestTaskingMap = nil;

+ (void)init
{
    requestTaskingMap = [NSMutableDictionary new];
}


//开始创建任务流程
+ (void) createRequestTask:(NSDictionary *)json
{
    NSString *cmd = [json objectForKey:@"cmd"];
    NSDictionary *data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_OPENADV]) {
        [self createAdvRequestTask:cmd :data];
    }else if([cmd isEqualToString:MSG_CMD_OPENPAY]){
        
    }
}

//创建请求任务
+ (void)createAdvRequestTask: (NSString *)taskNameCmd :(NSDictionary *)data
{
    NSDictionary *gameAdvData = [data objectForKey:@"gameAdvData"];
    NSDictionary *sdkAdvData = [data objectForKey:@"sdkAdvData"];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    if ([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]) {
        return;
    }
    NSString *taskingName = [[NSString alloc]initWithFormat:@"%@%@%@",taskNameCmd,@"_",advId];
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequestSerialNum];
    NSMutableArray *advRequestList = [requestTaskingMap objectForKey:taskingName];
    if (!advRequestList) {
        advRequestList = [NSMutableArray new];
        NSLog(@"%s%@%@%@%@",__func__,@"添加广告请求：",taskingName,@"_",advRequestSerialNumStr);
        [advRequestList addObject:advRequestSerialNumStr];
        [requestTaskingMap setValue:advRequestList forKey:taskingName];
    }else{
        NSLog(@"%s%@%@%@%@",__func__,@"添加广告请求：",taskingName,@"_",advRequestSerialNumStr);
        [advRequestList addObject:advRequestSerialNumStr];
    }
}



//获取当前请求任务的状态
+ (BOOL)getRequestTaskState:(NSString *)taskNameCmd :(NSDictionary *)data
{
    NSDictionary *gameAdvData = [data objectForKey:@"gameAdvData"];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *taskingName = [[NSString alloc]initWithFormat:@"%@%@%@",taskNameCmd,@"_",advId];
    NSMutableArray *advRequestList = [requestTaskingMap objectForKey:taskingName];
    if (advRequestList && advRequestList.count > 0) {
        return YES;
    }
    return NO;
}


//移除请求任务流程
+ (void)destroyRequestTask:(NSDictionary *)rpcCallData
{
    NSString *cmd = [ULTools GetStringFromDic:rpcCallData :@"cmd" :@""];
    NSDictionary *data = [ULTools GetNSDictionaryFromDic:rpcCallData :@"data" :nil];
    if ([cmd isEqualToString:REMSG_CMD_OPENADVRESULT]) {
        [self stopAdvRequestTask:data];
    }
}

//移除广告请求任务
+ (void)stopAdvRequestTask:(NSDictionary *)data
{
    NSString *advId = [ULTools GetStringFromDic:data :@"advId" :@""];
    if ([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]) {
        return;
    }
    NSString *taskingName = [[NSString alloc]initWithFormat:@"%@%@%@",MSG_CMD_OPENADV,@"_",advId];
    long advRequesetSerialNum = [ULTools GetLongFromDic:data :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequesetSerialNum];
    NSMutableArray *advRequestList = [requestTaskingMap objectForKey:taskingName];
    if (!advRequestList || advRequestList.count < 1) {
        return;
    }
    
    NSLog(@"%s%@%@%@%@",__func__,@"移除广告请求：",taskingName,@"_",advRequestSerialNumStr);
    [advRequestList removeObject:advRequestSerialNumStr];
}



@end
