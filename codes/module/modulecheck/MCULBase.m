//
//  MCULBase.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "MCULBase.h"
#import "ULIModuleCheckBase.h"
#import "ULSDKManager.h"
#import "ULStringConst.h"
#import "ULTools.h"
#import "ULConfig.h"

@interface MCULBase ()<ULIModuleCheckBase>

@end

@implementation MCULBase

- (id)initWithY:(int)y
{
    if (self = [super init]) {
        [self initView:y];
    }
    return self;
    
}

//测试界面模拟广告流程测试数据
- (NSMutableDictionary *)getBaseAdvTestData:(NSString *)editAdvId
{
    NSMutableDictionary *advData = [NSMutableDictionary new];
    NSMutableDictionary *gameAdvData = [NSMutableDictionary new];
    NSMutableDictionary *sdkAdvData = [NSMutableDictionary new];
    
    [gameAdvData setValue:editAdvId forKey:@"advId"];
    [gameAdvData setValue:@"{\"modulecheck\":\"this is test data\"}" forKey:@"userData"];
    
    [sdkAdvData setValue:[NSNumber numberWithInt:true] forKey:@"isModuleCheck"];//测试模块广告调用，不返回消息给客户端
    long num = [ULSDKManager getAdvRequestSerialNum];
    [ULSDKManager setAdvRequestSerialNum: num+1];
    [sdkAdvData setValue:[NSNumber numberWithLong:[ULSDKManager getAdvRequestSerialNum]] forKey:@"requestSerialNum"];
    [advData setValue:gameAdvData forKey:@"gameAdvData"];
    [advData setValue:sdkAdvData forKey:@"sdkAdvData"];
    return advData;
}


//测试界面模拟模块广告测试数据
- (NSMutableDictionary *)getModuleAdvTestDataWithType:(NSString *)advType withEditParam:(NSString *)advParam withLocalParamKey:(NSString *)key
{
    NSMutableDictionary *advData = [NSMutableDictionary new];
    NSMutableDictionary *gameAdvData = [NSMutableDictionary new];
    NSMutableDictionary *sdkAdvData = [NSMutableDictionary new];
    
    [gameAdvData setValue:S_CONST_ADV_MC_ADVID_DES forKey:@"advId"];
    [gameAdvData setValue:@"{\"modulecheck\":\"this is test data\"}" forKey:@"userData"];
    
    [sdkAdvData setValue:[NSNumber numberWithInt:true] forKey:@"isStopDispatch"];//测试模块广告调用，中断流程分发
    [sdkAdvData setValue:advType forKey:@"type"];
    [sdkAdvData setValue:@"show" forKey:@"rewardType"];
    
    NSArray *advParamArray;
    if([advParam isEqualToString:@""]){//未输入参数，那么则使用本地的参数配置
        NSString *localParam = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :key :@""];
        advParamArray = [localParam componentsSeparatedByString:@"|"];
    }else{
        advParamArray = [advParam componentsSeparatedByString:@"|"];
    }
    [sdkAdvData setValue:advParamArray forKey:@"advParams"];
    [sdkAdvData setValue:[NSArray new] forKey:@"advParamProbabilities"];
    
    [advData setValue:gameAdvData forKey:@"gameAdvData"];
    [advData setValue:sdkAdvData forKey:@"sdkAdvData"];
    return advData;
}


- (NSMutableDictionary *)getBasePayTestData:(NSString *)editPayId
{
    NSMutableDictionary *payData = [NSMutableDictionary new];
    NSMutableDictionary *gamePayData = [NSMutableDictionary new];
    NSMutableDictionary *sdkPayData = [NSMutableDictionary new];
    
    [gamePayData setValue:editPayId forKey:@"payId"];
    [gamePayData setValue:@"{\"modulecheck\":\"this is test data\"}" forKey:@"userData"];
    
    [sdkPayData setValue:[NSNumber numberWithInt:true] forKey:@"isModuleCheck"];//测试模块广告调用，不返回消息给客户端
   
    [payData setValue:gamePayData forKey:@"gamePayData"];
    [payData setValue:sdkPayData forKey:@"sdkPayData"];
    return payData;
}



- (NSMutableDictionary *)getModulePayTestData:(NSString *)editPayId
{
    NSMutableDictionary *payData = [NSMutableDictionary new];
    NSMutableDictionary *gamePayData = [NSMutableDictionary new];
    NSMutableDictionary *sdkPayData = [NSMutableDictionary new];
    
    [gamePayData setValue:editPayId forKey:@"payId"];
    [gamePayData setValue:@"{\"modulecheck\":\"this is test data\"}" forKey:@"userData"];
    
    [sdkPayData setValue:[NSNumber numberWithInt:true] forKey:@"isStopDispatch"];//测试模块广告调用，不返回消息给客户端
   
    [payData setValue:gamePayData forKey:@"gamePayData"];
    [payData setValue:sdkPayData forKey:@"sdkPayData"];
    return payData;
}



@end
