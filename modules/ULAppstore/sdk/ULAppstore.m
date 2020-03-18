//
//  ULAppstore.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/21.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULAppstore.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import <StoreKit/StoreKit.h>
#import "ULSDKManager.h"
#import "ULConfig.h"
#import "PayResult.h"
#import "PayResultManager.h"
#import "ULUserDefaults.h"
#import "ULAccountType.h"


/**
 
 补发功能已屏蔽：订单校验存在不可控网络因素，暂时屏蔽该功能，即暂不支持补发
 
 */

@interface ULAppstore ()<ULILifeCycle,SKPaymentTransactionObserver,SKProductsRequestDelegate>


@property (nonatomic,strong) NSDictionary *applePayInfo;
@property (nonatomic,assign) BOOL isPaying;//提供一个支付中标识，需先完成本次订单才能进行下一次支付
@property (nonatomic,strong) NSDictionary *payData;

@end

@implementation ULAppstore
- (void)onInitModule {
    NSLog(@"%s",__func__);
    self->_priority = PAY_PRIORITY_APPSTORE;
    [self addListener];
//    [PayResultManager initManager];
    //设置支付服务
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}



- (void)addListener
{
    NSLog(@"%s",__func__);
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY withSelector:@selector(mcOnOpenPay:) withPriority:PRIORITY_NONE];
}

- (void)mcOnOpenPay:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self onOpenPay:data];
}



- (void)onOpenPay :(NSDictionary *)data
{
    NSLog(@"%s",__func__);
    NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:data :@"gamePayData" :nil];
    NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
    NSDictionary *payIdData = [ULTools GetNSDictionaryFromDic:[self getPayInfoObj] :payId :nil];
    NSString *payCode = [ULTools GetStringFromDic:payIdData :@"payCode" :@""];
    NSString *price = [ULTools GetStringFromDic:payIdData :@"price" :@""];
    
    //TODO 先这样处理
    if(_isPaying){
        //支付结果统计
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_PAY_INFO],NSStringFromClass([self class]),@"",[NSString stringWithFormat:@"%f",[price floatValue] / 100] ,@"failed"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
        [self payResultCallBackWithCode:-1 withMsg:@"支付失败" withPayData:data];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK withData:@"存在为完成订单,需完成该订单后才能再次请求支付"];
        __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"已有订单进行中,需完成该订单后才能再次购买" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            alert = nil;
        }];
        return;
    }
    _isPaying = YES;
    _payData = data;
    
    
    //1.首先判断用户是否禁止付费，如果没有禁止付费，就向苹果服务器请求产品信息。
    if ([SKPaymentQueue canMakePayments]) {
        NSArray *product = [[NSArray alloc] initWithObjects:payCode, nil];
        NSSet *IDSet = [NSSet setWithArray:product];
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:IDSet];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        NSLog(@"%s:用户禁止付费",__func__);
        [self payResult:payFailed :data :[price floatValue] / 100];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK withData:@"用户禁止付费"];
        _isPaying = NO;
    }
}



#pragma mark 产品信息回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response NS_AVAILABLE(10_7, 3_0)
{
    
    NSLog(@"%s%lu", __func__, (unsigned long)response.products.count);
    NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:_payData :@"gamePayData" :nil];
    NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
    NSDictionary *payIdData = [ULTools GetNSDictionaryFromDic:[self getPayInfoObj] :payId :nil];
    NSString *payCode = [ULTools GetStringFromDic:payIdData :@"payCode" :@""];
    NSString *price = [ULTools GetStringFromDic:payIdData :@"price" :@""];
    
    
    NSArray *myProducts = response.products;
    if (0 == myProducts.count) {
        NSLog(@"%s:无法获取产品信息列表",__func__);
        [self payResult:payFailed :_payData :[price floatValue] / 100];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK withData:@"产品信息列表获取失败"];
        _isPaying = NO;
    } else {
        
        SKProduct *requestProduct = nil;
        
        for (SKProduct *pro in myProducts) {
            NSLog(@"%s%@", __func__, [pro localizedTitle]);
            NSLog(@"%s%@", __func__, [pro localizedDescription]);
            NSLog(@"%s%@", __func__, [pro price]);
            NSLog(@"%s%@", __func__, [pro.priceLocale objectForKey:NSLocaleCurrencySymbol]);
            NSLog(@"%s%@", __func__, [pro.priceLocale objectForKey:NSLocaleCurrencyCode]);
            NSLog(@"%s%@", __func__, [pro productIdentifier]);
            //判断商品信息列表中是否包含该商品
            if([pro.productIdentifier isEqualToString: payCode]){
                requestProduct = pro;
                break;
            }
        }
        
        if(requestProduct == nil){
            NSLog(@"在商品列表信息中未查找到当前请求的计费点信息");
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK withData:@"在商品列表信息中未查找到当前请求的计费点信息"];
            [self payResult:payFailed :_payData :[price floatValue] / 100];
            _isPaying = NO;
        }else{
            //发送购买请求
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:requestProduct];
            //利用透传字段将支付信息传递保证唯一
            payment.applicationUsername = [ULTools DictionaryToString:_payData];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            
        }
    }
}

#pragma mark - 购买请求失败回调
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s,error:%@", __func__,error);
    NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:_payData :@"gamePayData" :nil];
    NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
    NSDictionary *payIdData = [ULTools GetNSDictionaryFromDic:[self getPayInfoObj] :payId :nil];
    NSString *price = [ULTools GetStringFromDic:payIdData :@"price" :@""];
    [self payResult:payFailed :_payData :[price floatValue] / 100];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK withData:error.localizedFailureReason];
    _isPaying = NO;
}

#pragma mark - 购买请求结束回调
- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"%s:请求结束",__func__);
}

#pragma mark - SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"%s",__func__);
    dispatch_async(dispatch_get_main_queue(), ^{
        for(SKPaymentTransaction *tran in transactions){
                
                NSString *payDataStr = tran.payment.applicationUsername;
                NSDictionary *payData = [ULTools StringToDictionary:payDataStr];
                NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:payData :@"gamePayData" :nil];
                NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
                NSDictionary *payIdData = [ULTools GetNSDictionaryFromDic:[self getPayInfoObj] :payId :nil];
                NSString *price = [ULTools GetStringFromDic:payIdData :@"price" :@""];
                
                
                switch (tran.transactionState) {
                    case SKPaymentTransactionStatePurchased:
                        NSLog(@"%s,交易完成:%@",__func__,payDataStr);

                        //TODO 在补发的情景下如果客户端不能根据此消息直接发奖，那么只能区分补发接口了，但是目前还无法确定当前回调是补发回调还是正常回调
                        if(payData){//经测试补发情景下发送该消息也能正常补发。另外该回调在同一次支付请求时可能会回调多次，且第二次的透传字段变为了null，那么这里就通过null检索第二次无效回调
                            [self payResult:paySuccess :payData :[price floatValue] / 100];//直接返回成功
                        }
                        _isPaying = NO;
                        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                        
                        //TODO 暂时屏蔽校验功能。反馈存在多条漏单只补发一条的情况。
                        //购买到支付结果查询期间存在时间差，目前由于暂时屏蔽补单，那么也不会处理
        //                [self completeTransaction:tran];
                        
                        break;
                    case SKPaymentTransactionStatePurchasing:
                        NSLog(@"%s,商品添加进列表",__func__);
                        break;
                    case SKPaymentTransactionStateRestored:
                        NSLog(@"%s,已经购买过商品",__func__);
                        [self payResult:payFailed :payData :[price floatValue] / 100];
                        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                        _isPaying = NO;
                        
                        break;
                    case SKPaymentTransactionStateFailed:
                        NSLog(@"%s,交易失败",__func__);
                        [self payResult:payFailed :payData :[price floatValue] / 100];
                        _isPaying = NO;
                        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                        break;
                    default:
                        break;
                }
            }
    });
    
}

//对于异常的订单，如支付时crash，重新进入游戏会直接回调该函数

//交易结束,将收据发送给服务器让服务器去找appstore校验
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"%s",__func__);
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//    if (!receiptData) {
//        NSLog(@"%s:苹果返回的交易凭证为空，无法向服务器发起验证请求",__func__);
//        return;
//    }
    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *payData;
    if (_payData == nil) {
        NSLog(@"应用启动时调用");
        payData = [ULUserDefaults readDataFromUserDefault:@"ul_appstore_payData"];
        NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:payData :@"gamePayData" :nil];
        NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
        NSDictionary *payIdData = [ULTools GetNSDictionaryFromDic:[self getPayInfoObj] :payId :nil];
        NSString *price = [ULTools GetStringFromDic:payIdData :@"price" :@""];
        NSString *orderId = transaction.transactionIdentifier;
        
        PayResult *payResult = [[PayResult alloc] initWithPrice:price withOrderId:orderId withReceipt:encodeStr withPayData:payData];
        //将订单存储到本地
        [PayResultManager savePayResultToLocal:payResult];
        
        
        
        
        [self verifyTransaction:payResult:YES];
    }else{
        //临时存储当前订单，避免支付异常导致的支付数据丢失
        NSDictionary *gamePayData = [ULTools GetNSDictionaryFromDic:_payData :@"gamePayData" :nil];
        NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
        NSDictionary *payIdData = [ULTools GetNSDictionaryFromDic:[self getPayInfoObj] :payId :nil];
        NSString *price = [ULTools GetStringFromDic:payIdData :@"price" :@""];
        NSString *orderId = transaction.transactionIdentifier;
        
        PayResult *payResult = [[PayResult alloc] initWithPrice:price withOrderId:orderId withReceipt:encodeStr withPayData:_payData];
        //将订单存储到本地
        [PayResultManager savePayResultToLocal:payResult];
        
        
        [self verifyTransaction:payResult:NO];
    }
    
    
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


//指定连接失败数据发送给服务器检验失败后，进行重连，和超时处理，对用户进行提示
- (void)verifyTransaction :(PayResult *)payResult :(BOOL)isPrePay
{
    
    NSLog(@"%s",__func__);
    //请求地址
    NSString *callBackUrl = UL_APPSTORE_BUY_VERIFY_URL;
    NSString *isUseAppstoreSandboxUrl = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdK_pay_appstore_use_sandbox_url" :@"0"];
    if ([isUseAppstoreSandboxUrl isEqualToString:@"1"]) {
        callBackUrl = UL_APPSTORE_SANDBOX_VERIFY_URL;
    }
    
    NSURL *url = [NSURL URLWithString:callBackUrl];
    //设置请求地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    NSDictionary * paramsDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                payResult.receipt,@"receipt-data",
                                UL_APPSTORE_VERIFY_PASSWORD,@"password",nil];
    
    
    __block NSDictionary *payData = payResult.payData;
    NSString *price = payResult.price;
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:paramsDic
                                                          options:0
                                                            error:&error];
    
    if (!requestData) {
        NSLog(@"%s:请求参数格式错误，无法向服务器发起验证请求",__func__);
        if (!isPrePay) {
            [self payResult:payFailed :payData :[price floatValue] / 100];
            _isPaying = NO;
        }else{
            [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
        }
        return;
    }
    //请求体
    [request setHTTPBody:requestData];
    //超时时长
    request.timeoutInterval = 5;
    
    

    NSURLSession *session = [NSURLSession sharedSession];
    
    

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%s:校验失败:%@",__func__,error);
                __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"订单校验失败,请检查网络正常后重新启动游戏,我们将为你进行物品补发." withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    alert = nil;
                }];
                if (!isPrePay) {
                    [self payResult:payFailed :payData :[price floatValue] / 100];
                    self->_isPaying = NO;
                }else{
                    [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
                }
            }else{
                NSError *error;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (!jsonResponse) {
                    NSLog(@"%s:支付回调服务器返回结果为空",__func__);
                    if (!isPrePay) {
                        [self payResult:payFailed :payData :[price floatValue] / 100];
                        self->_isPaying = NO;
                    }else{
                        [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
                    }
                    
                }else{
                    int code = [[jsonResponse objectForKey:@"status"] intValue];
                    if (code == 0) {
                        NSLog(@"%s:参数校验成功",__func__);
                        
                        if (!isPrePay) {
                            [self payResult:paySuccess :payData :[price floatValue] / 100];
                            self->_isPaying = NO;
                        }else{
                            [ULModuleBaseSdk prePayResultCallBackWithCode:1 withMsg:@"补发成功" withPayData:payData];
                        }
                        //清除本地存储
                        [PayResultManager removePayResultFromLocal:payResult];
                    }else{
                        NSLog(@"%s:参数校验失败",__func__);
                        if (!isPrePay) {
                            [self payResult:payFailed :payData :[price floatValue] / 100];
                            self->_isPaying = NO;
                        }else{
                            [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
                        }
                    }
                }
                
                
            }
        });
        
    }];


    [task resume];
}




- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
    //TODO 释放函数目前不会调用
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    return nil;
}


- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo
{
    NSLog(@"%s",__func__);
    NSDictionary *payInfoJson = [ULTools GetNSDictionaryFromDic:basePayInfoDic :@"payInfo" :nil];
    if (!payInfoJson) {
        NSDictionary *channelPayInfo = [self getPayInfoObj];
        if (channelPayInfo) {
            [baseChannelInfo setValue:[self getPayInfoObj] forKey:@"payInfo"];
        }
        
    }else{
        NSDictionary *targetJson = [ULTools mergeDictionary :payInfoJson :[self getPayInfoObj]:NO];
        [baseChannelInfo setValue:targetJson forKey:@"payInfo"];
    }
    [ULSDKManager setBaseChannelInfo:baseChannelInfo];
    return nil;
}

- (NSDictionary *)getPayInfoObj
{
    if (!_applePayInfo) {
        _applePayInfo = [ULTools GetNSDictionaryFromDic:[ULConfig getConfigInfo] :@"s_sdk_pay_appstore_pay_info" :nil];
        NSDictionary *basePayInfo = [[self class] getBasePayInfo];
        if (!basePayInfo) {
            return _applePayInfo;
        }
        
        NSString *basePayInfoStr = [ULTools DictionaryToString:basePayInfo];
        NSMutableDictionary *basePayInfoJson = (NSMutableDictionary *)[ULTools StringToDictionary:basePayInfoStr];
        
        NSMutableArray *keyList = [NSMutableArray new];
        NSArray *basePayInfoKeys = [basePayInfoJson allKeys];
        for (NSString *key in basePayInfoKeys) {
            NSDictionary *member = [basePayInfoJson objectForKey:key];
            NSString *payPolicy = [ULTools GetStringFromDic:member :@"payPolicy" :@""];
            if ([payPolicy isEqualToString:@"2"]) {
                [keyList addObject:key];
            }
        }
        
        for (NSString *key in keyList) {
            [basePayInfoJson removeObjectForKey:key];
        }
        
        if (!_applePayInfo) {
            return basePayInfoJson;
        }
        
        if ([_applePayInfo allKeys].count < 1 || [[_applePayInfo allKeys][0] isEqualToString:@"0"]) {
            return basePayInfoJson;
        }
    }
    
    
    return _applePayInfo;
}


- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr
{
    NSLog(@"%s",__func__);
    return nil;
}


- (void)applicationDidBecomeActive {
    NSLog(@"%s",__func__);
}

- (void)applicationDidEnterBackground {
    NSLog(@"%s",__func__);
}

- (void)applicationDidReceiveMemoryWarning {
    NSLog(@"%s",__func__);
}

- (void)applicationWillEnterForeground {
    NSLog(@"%s",__func__);
}

- (void)applicationWillResignActive {
    NSLog(@"%s",__func__);
}

- (void)applicationWillTerminate {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    NSLog(@"%s",__func__);
    
}

- (void)onPayResult:(PayState )payState :(NSDictionary *)payData
{
    NSLog(@"%s",__func__);
    if (payState == paySuccess) {
        //上报支付统计数据
    }else if(payState == payFailed){
        
    }else if(payState == payCancel){
        
    }
}


@end
