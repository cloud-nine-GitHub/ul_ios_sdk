//
//  PayResultManager.m
//  demo
//
//  Created by 一号机雷兽 on 2019/9/23.
//  Copyright © 2019 一号机雷兽. All rights reserved.
//

#import "PayResultManager.h"
#import "NSQueue.h"
#import "ULTools.h"
#import "ULUserDefaults.h"
#import "ULTimer.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULModuleBase.h"
#import "ULModuleBaseSdk.h"
#import "ULAppstore.h"
#import "ULConfig.h"




@interface PayResultManager ()



@end

@implementation PayResultManager

static NSQueue *queue;


+ (void)initManager
{
    NSLog(@"%s",__func__);
    queue = [[NSQueue alloc] init];
    NSArray *localPayResultArray = [self getPayResultFromLocal];
    if (localPayResultArray && [localPayResultArray count] > 0) {
        //开启线程进行本地订单校验
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(verifyLocalReceipts) object:nil];
        thread.name = @"ul_appstore_local_receipts_verify_thread";
        [thread start];
        
        
    }else{
        //do nothing
    }
    
}

+ (void)verifyLocalReceipts
{
    NSLog(@"%s",__func__);
    NSArray *localPayResultArray = [self getPayResultFromLocal];
    for (NSString *localPayResultStr in localPayResultArray) {
        NSDictionary *localPayResultDic = [ULTools StringToDictionary:localPayResultStr];
        NSString *price = [ULTools GetStringFromDic:localPayResultDic :@"price" :@""];
        NSString *orderId = [ULTools GetStringFromDic:localPayResultDic :@"orderId" :@""];
        NSString *receipt = [ULTools GetStringFromDic:localPayResultDic :@"receipt" :@""];
        NSString *payDataStr = [ULTools GetStringFromDic:localPayResultDic :@"payData" :@""];
        NSDictionary *payData = [ULTools StringToDictionary:payDataStr];
        PayResult *payResult = [[PayResult alloc]initWithPrice:price withOrderId:orderId withReceipt:receipt withPayData:payData];
        
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
                                    receipt,@"receipt-data",
                                    UL_APPSTORE_VERIFY_PASSWORD,@"password",nil];
        
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:paramsDic
                                                              options:0
                                                                error:&error];
        
        if (!requestData) {
            NSLog(@"%s:请求参数格式错误，无法向服务器发起验证请求",__func__);
            [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
            
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

                    [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
                    
                }else{
                    NSError *error;
                    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    if (!jsonResponse) {
                        NSLog(@"%s:支付回调服务器返回结果为空",__func__);
                        [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
                        
                    }else{
                        int code = [[jsonResponse objectForKey:@"status"] intValue];
                        if (code == 0) {
                            NSLog(@"%s:参数校验成功",__func__);
                            [ULModuleBaseSdk prePayResultCallBackWithCode:1 withMsg:@"补发成功" withPayData:payData];
                            //清除本地存储
                            [self removePayResultFromLocal:payResult];
                        }else{
                            NSLog(@"%s:参数校验失败",__func__);
                            [ULModuleBaseSdk prePayResultCallBackWithCode:-1 withMsg:@"补发失败" withPayData:payData];
                        }
                    }
                    
                    
                }
            });
            
        }];


        [task resume];
    }

}


#pragma mark 存
//存储支付凭证，避免连接支付回调服务器失败时出现调单情况
+ (void)savePayResultToLocal: (PayResult *)payResult
{
    NSLog(@"%s:将未发货订单保存在本地:%@",__func__,payResult);
    NSString *payDataStr = @"";
    if (payResult.payData) {
        payDataStr = [ULTools DictionaryToString:payResult.payData];
    }
    
    //do something
    NSDictionary * payResultJson = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    payResult.receipt,@"receipt",
                                    payResult.price,@"price",
                                    payResult.orderId,@"orderId",
                                    payDataStr,@"payData",nil];
    
    NSString *payResultJsonStr = [ULTools DictionaryToString:payResultJson];
    //应该根据用户userid来存储订单号数组，且订单id不能重复
    //先取数组
    NSMutableArray *localPayResultArray = [ULUserDefaults readDataFromUserDefault:@"ul_appstore_receipts"];
    if (!localPayResultArray) {
        NSLog(@"%s,没有存储未处理的订单",__func__);
        //直接存储
        localPayResultArray = [NSMutableArray new];
        [localPayResultArray addObject:payResultJsonStr];
        NSMutableDictionary *payResultDic = [NSMutableDictionary new];
        [payResultDic setValue:localPayResultArray forKey:@"ul_appstore_receipts"];
        [ULUserDefaults writeDataToUserDefault:payResultDic];
    }else{
        NSLog(@"%s,存在存储未处理的订单",__func__);
        
        for (int i = 0; i < [localPayResultArray count]; i++) {
            NSString *localPayResultStr = localPayResultArray[i];
            NSDictionary *localPayResultDic = [ULTools StringToDictionary:localPayResultStr];
            NSString *mOrder = [ULTools GetStringFromDic:localPayResultDic :@"orderId" :@""];
            if ([mOrder isEqualToString:payResult.orderId]) {
                NSLog(@"%s,不存储重复订单",__func__);
                return;
            }
        }
        
        NSMutableArray *array = [NSMutableArray new];
        for (NSString *s in localPayResultArray) {
            [array addObject:s];
        }
        
        //插入数组
        [array addObject:payResultJsonStr];
        NSMutableDictionary *payResultDic = [NSMutableDictionary new];
        [payResultDic setValue:array forKey:@"ul_appstore_receipts"];
        [ULUserDefaults writeDataToUserDefault:payResultDic];
    }
    
}

#pragma mark 取
//获取存储的支付凭据
+ (NSArray *)getPayResultFromLocal
{
    NSLog(@"%s:获取本地所有校验订单",__func__);
    NSMutableArray *localPayResultArray = [ULUserDefaults readDataFromUserDefault:@"ul_appstore_receipts"];
    if (!localPayResultArray) {
        return nil;
    }
    return localPayResultArray;
}

#pragma mark 删
//校验成功后需要将本地存储的该条订单删除
+ (void)removePayResultFromLocal: (PayResult *)payResult
{
    NSLog(@"%s:移除存储在本地的该条订单:%@",__func__,payResult);
    NSMutableArray *localPayResultArray = [ULUserDefaults readDataFromUserDefault:@"ul_appstore_receipts"];
    if (!localPayResultArray) {
        return;
    }
    
    //拷贝数组元素至可变数组中
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *localPayResultStr in localPayResultArray) {
        [array addObject:localPayResultStr];
        
    }
    
    
    for (NSString *localPayResultStr in localPayResultArray) {
        NSDictionary *localPayResultDic = [ULTools StringToDictionary:localPayResultStr];
        NSString *mOrder = [ULTools GetStringFromDic:localPayResultDic :@"orderId" :@""];
        if ([mOrder isEqualToString:payResult.orderId]) {
            [array removeObject:localPayResultStr];
            //按理说不会存在重复订单，这里直接break
            break;
        }
    }
    //重新写入，更新数据
    NSMutableDictionary *payResultDic = [NSMutableDictionary new];
    [payResultDic setValue:array forKey:@"ul_appstore_receipts"];
    [ULUserDefaults writeDataToUserDefault:payResultDic];
}








- (void)refreshPayResultQueue:(PayResult *)payResult
{
    NSLog(@"PayResultManager----refreshPayResultQueue:将未发货订单加入队列:%@",[payResult toString]);
    [queue enqueue:payResult];
}


- (void)doTimerTask
{
    int size = [queue count];
    if(size > 0){
        NSLog(@"队列中存在未发货订单:%d 条",size);
        PayResult *payResult = [queue dequeue];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(verifyTransaction:) object:payResult];
        //thread.name = @"verifyTransactionThread";
        [thread start];
        //[self verifyTransaction:payResult];
    }else{
        NSLog(@"队列中没有未发货订单----do nothing");
    }
}




@end
