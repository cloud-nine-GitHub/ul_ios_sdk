//
//  ULCallBackManager.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/11.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULAdvCallBackManager.h"
#import "ULCmd.h"
#import "ULTools.h"
#import "ULSDKManager.h"
#import "ULModuleBaseAdv.h"
#import "ULStringConst.h"
#import "ULTimeOut.h"

@implementation ULAdvCallBackManager

static NSMutableDictionary *advRefuseCallBackMap;
static NSMutableDictionary *advCallBackMap;
static NSMutableDictionary *advRequestSerialNumDataMap;

//回调统一出口函数
+ (void)callBackExit:(int )code :(NSString *)msg :(NSMutableDictionary *)data
{
    
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:data :@"gameAdvData" :nil ];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:data :@"sdkAdvData" :nil ];
    BOOL isModuleCheck = [ULTools GetBoolFromDic:sdkAdvData :@"isModuleCheck" :NO];
    if (isModuleCheck) {
        return;
    }
    BOOL isStopDispatch = [ULTools GetBoolFromDic:sdkAdvData :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        return;
    }
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *tag = [ULTools GetStringFromDic:gameAdvData :@"tag" :@""];
    NSString *userData = [ULTools GetStringFromDic:gameAdvData :@"userData" :@""];
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    NSString *rewardTag = [ULTools GetStringFromDic:sdkAdvData :@"rewardType" :@""];
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [json setValue:msg forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:tag forKey:@"tag"];
    [json setValue:userData forKey:@"userData"];
    [json setValue:[NSNumber numberWithLong:advRequestSerialNum] forKey:@"requestSerialNum"];
    if (code == 1) {
        [json setValue:type forKey:@"type"];
        [json setValue:rewardTag forKey:@"rewardType"];
        //TODO
        //修改缓存次数
    }
    
    [ULSDKManager JsonRpcCall:REMSG_CMD_OPENADVRESULT :json];
    
}


//点击回调统一出口函数
+ (void)clickCallBack:(int )code :(NSString *)msg :(NSMutableDictionary *)data
{
    
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:data :@"gameAdvData" :nil ];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:data :@"sdkAdvData" :nil ];
    BOOL isModuleCheck = [ULTools GetBoolFromDic:sdkAdvData :@"isModuleCheck" :NO];
    if (isModuleCheck) {
        return;
    }
    BOOL isStopDispatch = [ULTools GetBoolFromDic:sdkAdvData :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        return;
    }
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *tag = [ULTools GetStringFromDic:gameAdvData :@"tag" :@""];
    NSString *userData = [ULTools GetStringFromDic:gameAdvData :@"userData" :@""];
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [json setValue:msg forKey:@"msg"];
    [json setValue:advId forKey:@"advId"];
    [json setValue:tag forKey:@"tag"];
    [json setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_CLICKADVRESULT :json];
    
}


//回调入口函数
+ (void)callBackEntry :(CallBackType )type :(NSMutableDictionary *)data
{
    if (!data) {
        NSLog(@"%s%@",__func__,@"无效回调直接返回");
        return;
    }
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:data :@"sdkAdvData" :nil];
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequestSerialNum];
    id b = [advRefuseCallBackMap objectForKey:advRequestSerialNumStr];
    if (b!=nil && [b boolValue]) {
        NSLog(@"%s%@",__func__,@"不再接受后续回调");
        return;
    }
    if (!b) {
        [advRefuseCallBackMap setValue:[NSNumber numberWithInt:false] forKey:advRequestSerialNumStr];
    }
    NSMutableArray *advCallBackList = [advCallBackMap objectForKey:advRequestSerialNumStr];
    if (!advCallBackList) {
        advCallBackList = [NSMutableArray new];
        [advCallBackList addObject:[[CallBack alloc]initWith:type :data]];
        [advCallBackMap setValue:advCallBackList forKey:advRequestSerialNumStr];
    }else{
        [advCallBackList addObject:[[CallBack alloc]initWith:type :data]];
    }
    [self CallBackManager:type :data];
}

+ (void)CallBackManager :(CallBackType)type :(NSMutableDictionary *)data
{
    NSMutableDictionary *gameAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"gameAdvData" :nil];
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSString *typeStr = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSString *advRequestSerialNumStr = [NSString stringWithFormat:@"%lu",advRequestSerialNum];
    NSMutableArray *advCallBackList = [advCallBackMap objectForKey:advRequestSerialNumStr];
    if (!advCallBackList || advCallBackList.count == 0) {
        return;
    }
    
    switch (type) {
        case showed:
            if ([self isRepeatCallBack:advCallBackList :showed]) {
                return;
            }
            if ([typeStr isEqualToString:UL_ADV_VIDEO]) {
                NSMutableDictionary *videoData = [NSMutableDictionary new];
                [videoData setValue:advId forKey:@"advId"];
                [videoData setValue:[NSNumber numberWithLong:advRequestSerialNum] forKey:@"requestSerialNum"];
                NSMutableDictionary *rpcCallJsonObj = [NSMutableDictionary new];
                [rpcCallJsonObj setValue:REMSG_CMD_OPENADVRESULT forKey:@"cmd"];
                [rpcCallJsonObj setValue:videoData forKey:@"data"];
                //结束超时任务
                [ULTimeOut stopTimeOutTask:rpcCallJsonObj];
                
            }else{
                NSMutableArray *callBackTypeList = [NSMutableArray new];
                for (CallBack *c in advCallBackList) {
                    [callBackTypeList addObject:[NSNumber numberWithInt:c.type]];
                }
                if ([callBackTypeList containsObject:[NSNumber numberWithInt:failed]] || [callBackTypeList containsObject:[NSNumber numberWithInt:timeout]]) {
                    return;
                }
                [self callBackExit:1 :S_CONST_ADV_SUCCESS_DES :data];
            }
            break;
        case clicked:
            if ([self isRepeatCallBack:advCallBackList :clicked]) {
                return;
            }
            if ([typeStr isEqualToString:UL_ADV_VIDEO]) {
                [self callBackExit:1 :S_CONST_ADV_SUCCESS_DES :data];
                [self clickCallBack:1 :S_CONST_ADV_CLICK_DES :data];
                [advRefuseCallBackMap setValue:[NSNumber numberWithInt:true] forKey:advRequestSerialNumStr];
            }else{
                NSMutableArray *callBackTypeList = [NSMutableArray new];
                for (CallBack *c in advCallBackList) {
                    [callBackTypeList addObject:[NSNumber numberWithInt:c.type]];
                }
                if ([callBackTypeList containsObject:[NSNumber numberWithInt:failed]] || [callBackTypeList containsObject:[NSNumber numberWithInt:timeout]]) {
                    return;
                }
                [self clickCallBack:1 :S_CONST_ADV_CLICK_DES :data];
            }
            break;
        case closed:
            if ([typeStr isEqualToString:UL_ADV_VIDEO]) {
                NSMutableArray *callBackTypeList = [NSMutableArray new];
                for (CallBack *c in advCallBackList) {
                    [callBackTypeList addObject:[NSNumber numberWithInt:c.type]];
                }
                if ([callBackTypeList containsObject:[NSNumber numberWithInt:showed]]) {
                    [self callBackExit:1 :S_CONST_ADV_SUCCESS_DES :data];
                    [advRefuseCallBackMap setValue:[NSNumber numberWithInt:true] forKey:advRequestSerialNumStr];
                    return;
                }else{
                    [self callBackExit:0 :S_CONST_ADV_FAIL_DES :data];
                    [advRefuseCallBackMap setValue:[NSNumber numberWithInt:true] forKey:advRequestSerialNumStr];
                }
                
            }
            break;
        case timeout:
        case failed:
            if ([self isRepeatCallBack:advCallBackList :failed] || [self isRepeatCallBack:advCallBackList :timeout] ) {
                return;
            }
            if ([typeStr isEqualToString:UL_ADV_VIDEO]) {
                [self callBackExit:0 :S_CONST_ADV_FAIL_DES :data];
                [advRefuseCallBackMap setValue:[NSNumber numberWithInt:true] forKey:advRequestSerialNumStr];
            }else{
                NSMutableArray *callBackTypeList = [NSMutableArray new];
                for (CallBack *c in advCallBackList) {
                    [callBackTypeList addObject:[NSNumber numberWithInt:c.type]];
                }
                if ([callBackTypeList containsObject:[NSNumber numberWithInt:showed]]) {
                    return;
                }
                if(type == failed && [callBackTypeList containsObject:[NSNumber numberWithInt:timeout]]){
                    
                    return;
                }
                [self callBackExit:0 :S_CONST_ADV_FAIL_DES :data];
            }
            break;
            
    }
}





+ (void)init
{
    advRefuseCallBackMap = [NSMutableDictionary new];
    advCallBackMap = [NSMutableDictionary new];
    advRequestSerialNumDataMap = [NSMutableDictionary new];
}

+ (void)callBackInit:(NSMutableDictionary *)data
{
    NSMutableDictionary *sdkAdvData = [ULTools GetNSMutableDictionaryFromDic:data :@"sdkAdvData" :nil];
    long advReuqestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    [advRequestSerialNumDataMap setValue:data forKey:[NSString stringWithFormat:@"%lu",advReuqestSerialNum]];
    [advRefuseCallBackMap setValue:false forKey:[NSString stringWithFormat:@"%lu",advReuqestSerialNum]];
}


+ (BOOL)isRepeatCallBack:(NSMutableArray *)advCallBackList :(CallBackType)type
{
    int count = 0;
    for (CallBack *c in advCallBackList) {
        if (c.type == type) {
            count++;
        }
    }
    if (count > 1) {
        return true;
    }
    return false;
}




@end

@implementation CallBack

-(id)initWith:(CallBackType)type :(NSMutableDictionary *)data
{
    if (self == [super init]) {
        _type = type;
        _data = data;
    }
    return self;
}

@end
