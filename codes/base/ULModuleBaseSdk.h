//
//  ULModuleBaseSdk.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULModuleBase.h"

NS_ASSUME_NONNULL_BEGIN
/**
 支付状态
 */
typedef NS_ENUM(NSUInteger, PayState) {
    paySuccess = 1,
    payFailed,
    payCancel
};

static int const PAY_POLICY_DEFAULT = 1;
static int const PAY_POLICY_ULPAY = 2;

static NSDictionary *basePayInfoDic = nil;
//保留支付逻辑算了
static int PAY_PRIORITY_APPSTORE = 1000;
static int PAY_PRIORITY_UNKNOW = 100;

@interface ULModuleBaseSdk : ULModuleBase
{
    int _priority;
    SEL _paySel;
}


@property (nonatomic) int priority;
@property (nonatomic) SEL paySel;



+ (void)init;
+ (NSDictionary *)getBasePayInfo;
+ (int)getBasePayInfoPolicyWithPayId:(NSString *)payId;

- (void)payResult:(PayState )payState :(NSDictionary *)payData :(float )price;
- (void)onPayResult:(PayState) payState :(NSDictionary *)payData;
- (void)payResultCallBackWithCode:(int )code withMsg:(NSString *)msg withPayData:(NSDictionary *)payData;

@end

NS_ASSUME_NONNULL_END
