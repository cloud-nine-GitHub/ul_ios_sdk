//
//  ULModuleBaseSdk.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULModuleBaseSdk.h"
#import "ULConfig.h"
#import "ULNotificationDispatcher.h"
#import "ULISdk.h"
#import "ULNotification.h"
#import "ULSDKManager.h"
#import "ULCmd.h"
#import "ULTools.h"
#import "ULCop.h"
#import "ULAccountType.h"


@interface ULModuleBaseSdk ()<ULISdk>


@end

@implementation ULModuleBaseSdk

//SEL paySel;

- (id)init
{
    if (self = [super init]) {
        [self setListener];
    }
    return self;
}


//注意区分构造函数
+ (void)init
{
    [self getPriorityFromCop];
}


//获取cop配置的支付优先级
+ (void)getPriorityFromCop
{
    //在获取cop之前就被调用了，这种肯定失效了
//    PAY_PRIORITY_APPSTORE = [[ULTools GetStringFromDic:[ULCop getCopInfo]:@"s_sdk_pay_priority_appstore" :@"1000"] intValue];
//    PAY_PRIORITY_UNKNOW = [[ULTools GetStringFromDic:[ULCop getCopInfo]:@"s_sdk_pay_priority_unknow" :@"100"] intValue];
}

- (void)setListener
{
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_PREOPEN_PAY withSelector:@selector(onBasePrepareOpenPay:) withPriority:_priority];
    
    
}

- (void)onBasePrepareOpenPay:(NSNotification *)notification
{
    [[ULNotificationDispatcher getInstance] addNotificationWithObserverOnce:self withName:UL_NOTIFICATION_OPEN_PAY withSelector:@selector(onBaseOpenPay:) withPriority:_priority];
    
}

- (void)onBaseOpenPay:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    //支付请求统计
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_PAY_INFO],@"",@"",@"",@"requestPay"];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    [self onOpenPay:data];
    
}


+ (NSDictionary *)getBasePayInfo
{
    if (basePayInfoDic == nil) {
        basePayInfoDic = [[ULConfig getConfigInfo] objectForKey:@"s_sdk_common_base_pay_info"];
    }
    return basePayInfoDic;
}

+ (int)getBasePayInfoPolicyWithPayId:(NSString *)payId
{
    NSDictionary *payInfo = [[self getBasePayInfo] objectForKey:payId];
    if (payInfo == nil) {
        return PAY_POLICY_DEFAULT;
    }
    NSString *payPolicyStr = [payInfo objectForKey:@"payPolicy"];
    int payPolicy = [payPolicyStr intValue];
    if (payPolicy == 0) {
        payPolicy = PAY_POLICY_DEFAULT;
    }
    return payPolicy;
}


//传入金额，避免不同渠道计费点金额不一致
- (void)payResult:(PayState )payState :(NSDictionary *)payData :(float )price
{
    NSString *payResult = @"";
    //支付取消是否继续走支付流程，交由控制
    NSString *isDispatchWhenCancel = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_sdk_pay_dispatch_when_cancel" :@"0"];
    if (payState == paySuccess) {
        [self payResultCallBackWithCode:1 withMsg:@"支付成功" withPayData:payData];
        payResult = @"success";
        //支付结果统计
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_PAY_INFO],NSStringFromClass([self class]),@"",[NSString stringWithFormat:@"%.2f",price] ,payResult];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
        return;
    }
    NSMutableDictionary *sdkPayData = [ULTools GetNSMutableDictionaryFromDic:payData :@"sdkPayData" :nil];
    BOOL isStopDispatch = [ULTools GetBoolFromDic:sdkPayData :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        NSLog(@"%s%@",__func__,@"测试模块单独调用,停止后续流程分发");
        return;
    }
    if(payState == payFailed){
        if (![[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_OPEN_PAY withData:payData]) {
            //无后续支付流程，返回支付结果
            [self payResultCallBackWithCode:-1 withMsg:@"支付失败" withPayData:payData];
            payResult = @"failed";
        }
    }
    
    if (payState == payCancel) {
        if ([isDispatchWhenCancel isEqualToString:@"1"]) {
            if (![[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_OPEN_PAY withData:payData]) {
                //无后续支付流程，返回支付结果
                [self payResultCallBackWithCode:0 withMsg:@"支付取消" withPayData:payData];
                payResult = @"cancel";
            }
        }else{
            [self payResultCallBackWithCode:0 withMsg:@"支付取消" withPayData:payData];
            payResult = @"cancel";
        }
    }
    
    //支付结果统计
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_PAY_INFO],NSStringFromClass([self class]),@"",[NSString stringWithFormat:@"%.2f",price] ,payResult];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];

}

//支付结果同意返回函数，按理说只有支付模块才可调用,先给个对象方法
- (void)payResultCallBackWithCode:(int )code withMsg:(NSString *)msg withPayData:(NSDictionary *)payData
{
    NSMutableDictionary *sdkPayData = [ULTools GetNSMutableDictionaryFromDic:payData :@"sdkPayData" :nil];
    BOOL isModuleCheck = [ULTools GetBoolFromDic:sdkPayData :@"isModuleCheck" :NO];
    if (isModuleCheck) {
        return;
    }
    
    BOOL isStopDispatch = [ULTools GetBoolFromDic:sdkPayData :@"isStopDispatch" :NO];
    if (isStopDispatch) {
        return;
    }
    
    NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:payData :@"gamePayData" :nil];
    NSString *payId = [gamePayData objectForKey:@"payId"];
    NSString *userData = [gamePayData objectForKey:@"userData"];
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [data setValue:msg forKey:@"msg"];
    [data setValue:payId forKey:@"payId"];
    [data setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_PAYRESULT :data];
}

+ (void)prePayResultCallBackWithCode:(int )code withMsg:(NSString *)msg withPayData:(NSDictionary *)payData
{
    
    
    
    NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:payData :@"gamePayData" :nil];
    NSString *payId = [gamePayData objectForKey:@"payId"];
    NSString *userData = [gamePayData objectForKey:@"userData"];
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [data setValue:msg forKey:@"msg"];
    [data setValue:payId forKey:@"payId"];
    [data setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_PREPAYRESULT :data];
    
    NSDictionary *payIdDic = [ULTools GetNSDictionaryFromDic:[self getBasePayInfo] :payId :nil];
    NSString *priceS = [ULTools GetStringFromDic:payIdDic :@"price" :@""];
    float price = [priceS floatValue] / 100;
    NSString *payResult = @"failed";
    if (code == 1) {
        payResult = @"success";
    }
    //支付结果统计
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_PAY_INFO],NSStringFromClass([self class]),@"",[NSString stringWithFormat:@"%.2f",price] ,payResult];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
}

- (void)prePayResultCallBackWithCode:(int )code withMsg:(NSString *)msg withPayData:(NSDictionary *)payData
{
    
    
    
    NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:payData :@"gamePayData" :nil];
    NSString *payId = [gamePayData objectForKey:@"payId"];
    NSString *userData = [gamePayData objectForKey:@"userData"];
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [data setValue:msg forKey:@"msg"];
    [data setValue:payId forKey:@"payId"];
    [data setValue:userData forKey:@"userData"];
    [ULSDKManager JsonRpcCall:REMSG_CMD_PREPAYRESULT :data];
    
    NSDictionary *payIdDic = [ULTools GetNSDictionaryFromDic:[[self class] getBasePayInfo] :payId :nil];
    NSString *priceS = [ULTools GetStringFromDic:payIdDic :@"price" :@""];
    float price = [priceS floatValue] / 100;
    NSString *payResult = @"failed";
    if (code == 1) {
        payResult = @"success";
    }
    //支付结果统计
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_PAY_INFO],NSStringFromClass([self class]),@"",[NSString stringWithFormat:@"%.2f",price] ,payResult];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
}

// ios 没有退出的嘛
-(void)exitGameResult{}

@end
