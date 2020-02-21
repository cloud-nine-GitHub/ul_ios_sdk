//
//  ULDemoModule.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/27.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import "ULDemo.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSDKManager.h"

@interface ULDemo ()<ULILifeCycle>

@end

@implementation ULDemo



-(id)init
{
    if (self = [super init]) {
        NSLog(@"%s%@",__func__,@"构造函数!");
    }
    return self;
}


- (void)onInitModule {
    NSLog(@"%s",__func__);
    self->_priority = PAY_PRIORITY_UNKNOW;
    [self addListener];
}



- (void)addListener
{
    NSLog(@"%s",__func__);
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_OPEN_DEMO_PAY withSelector:@selector(mcOnOpenPay:) withPriority:PRIORITY_NONE];
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
    __block UIAlertController *alert = [ULTools showThreeBtnDialogWithTitle:@"温馨提示" withDesc:@"模拟ULDemo支付" withBtnOneText:@"模拟成功" withBtnTwoText:@"模拟失败" withBtnThreeText:@"模拟取消" withOneListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"支付成功");
        [self payResult:paySuccess :data];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    } withTwoListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"支付失败");
        [self payResult:payFailed :data];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_DEMO_PAY_CALLBACK withData:@"模拟测试失败"];
    } withThreeListener:^(UIAlertAction *_Nonnull action){
        NSLog(@"%s%@",__func__,@"支付取消");
        [self payResult:payCancel :data];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    }];
}




- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    return nil;
}


- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo
{
    NSLog(@"%s",__func__);
//    [baseChannelInfo setValue:@"1" forKey:@"test"];
//    [ULSDKManager setBaseChannelInfo:baseChannelInfo];
    return nil;
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
