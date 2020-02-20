//
//  ULCdk.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/19.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULCdk.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULCmd.h"
#import "ULTools.h"
#import "ULConfig.h"
#import "ULSDKManager.h"

static NSString *const USE_CDKEY_DEFAULT_URL = @"https://cdkey.ultralisk.cn/commoncdk/usecdk";

@implementation ULCdk



- (void)onInitModule
{
    NSLog(@"%s",__func__);

}

- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}

- (void)addListener
{
    NSLog(@"%s",__func__);
    
}



- (void)useCdkey:(NSDictionary *)data
{
    NSString *useId = [ULTools GetStringFromDic:data :@"userId" :@""];
    NSString *cdkStr = [ULTools GetStringFromDic:data :@"cdkStr" :@""];
    
    NSString *cdkChannelId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cdk_channel_id" :@"0"];
    NSString *cdkAppId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cdk_app_id" :@"0"];
    NSString *cdkUrl = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cdk_url" :USE_CDKEY_DEFAULT_URL];
    
    NSString *requestUrl = [[NSString alloc]initWithFormat:@"%@%@%@%@%@%@%@%@%@",cdkUrl,@"?userId=",useId,@"&cdkStr=",cdkStr,@"&appId=",cdkAppId,@"&channelId=",cdkChannelId];
    
    NSLog(@"%s%@%@",__func__,@"cdk请求地址:",requestUrl);
    
    
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString:requestUrl];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //response ： 响应：服务器的响应
        //data：二进制数据：服务器返回的数据。（就是我们想要的内容）
        //error：链接错误的信息
        NSMutableDictionary *cdkInfoObj = [NSMutableDictionary new];
        if (!error) {
            if (!data) {
                NSLog(@"%s%@",__func__,@"copInfoString return nil");
                [cdkInfoObj setValue:[NSNumber numberWithInt:0] forKey:@"code"];
                [cdkInfoObj setValue:@"cdk兑换失败" forKey:@"message"];
                return ;
            }
            //根据返回的二进制数据，生成字符串！NSUTF8StringEncoding：编码方式
            NSString *cdkInfoStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%s%@%@",__func__,@"cdkInfoString Is : ",cdkInfoStr);
            cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
            cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
            cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"\"0\"" withString:@"1"];
            cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"\"1\"" withString:@"1"];
            cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"\"-1\"" withString:@"0"];
            cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"data" withString:@"message"];
            NSLog(@"%s%@%@",__func__,@"cdkInfoString 2 Is : ",cdkInfoStr);
            cdkInfoObj = (NSMutableDictionary *)[ULTools StringToDictionary:cdkInfoStr];
            int code = [ULTools GetIntFromDic:cdkInfoObj :@"code" :-1];
            if (code == 1) {
                cdkInfoStr = [cdkInfoStr stringByReplacingOccurrencesOfString:@"message" withString:@"data"];
                cdkInfoObj = (NSMutableDictionary *)[ULTools StringToDictionary:cdkInfoStr];
            }
        }else{
            NSLog(@"%s%@%@",__func__,@"cdk request error : ",error);
            [cdkInfoObj setValue:[NSNumber numberWithInt:0] forKey:@"code"];
            [cdkInfoObj setValue:@"cdk兑换失败" forKey:@"message"];
        }
        [ULSDKManager JsonRpcCall:REMSG_CMD_USECDKEY :cdkInfoObj];
    }];
    
    //5.执行任务
    [dataTask resume];
    
    
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    NSDictionary *json = [ULTools StringToDictionary: param];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_USECDKEY]) {
        [self useCdkey:data];
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
    return nil;
    
}


@end
