//
//  ULCop.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/29.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import "ULCop.h"
#import "ULTools.h"
#import "ULConfig.h"
#import "ULTimer.h"
#import "ULSDKManager.h"
#import "ULCmd.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"


static NSString *const UL_COP_TIMER_NAME = @"getCopTimer";
static NSString *const UL_COP_THREAD_NAME = @"getCopThread";
static int const UL_COP_TIMER_LOOP_TIME = 30;

@implementation ULCop

static ULCop* instance=nil;
static NSDictionary* copInfoDic = nil;
static NSThread *copRequestThread = nil;


+ (instancetype)getInstance{
    if(!instance){
        instance = [[self alloc] init];
    }
    return instance;
}

+ (void)initCopInfo{
    NSLog(@"%s",__func__);
    //是否读cop配置
    NSString *isUseCop = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_close_cop" :@"0"];
    if ([isUseCop isEqualToString:@"1"]) {
        NSLog(@"%s%@",__func__,@"cop is unavailable!");
        return;
    }
    [self createGetCopThread];
}

+ (void)createGetCopThread
{
    //创建线程
    copRequestThread = [[NSThread alloc]initWithTarget:self selector:@selector(createTimer:) object:nil];
    copRequestThread.name = UL_COP_THREAD_NAME;
    copRequestThread.qualityOfService = NSQualityOfServiceDefault;
    [copRequestThread start];
}

+ (void)createTimer:(NSThread *)thread
{
    NSTimer *timer = [[ULTimer getInstance] createTimerWithName:UL_COP_TIMER_NAME withTarget:self withTime:UL_COP_TIMER_LOOP_TIME withSel:@selector(doRequestCop) withUserInfo:nil withRepeat:YES];
    //立即执行
    [timer fire];
    //线程中创建的timer需要添加到runloop中
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runloop run];
    
}



+ (void)doRequestCop
{
    NSString *copRequestUrl = [self getRequestUrl:[ULConfig getConfigInfo]];
    
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString:copRequestUrl];
    
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
        NSLog(@"cop请求网络响应：response：%@",response);
        if (!error) {
            if (!data) {
                NSLog(@"%s%@",__func__,@"copInfoString return nil");
                return ;
            }
            //根据返回的二进制数据，生成字符串！NSUTF8StringEncoding：编码方式
            NSString *copInfoStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%s%@%@",__func__,@"copInfoString Is : ",copInfoStr);
            NSDictionary *copObject = [ULTools StringToDictionary:copInfoStr];
            int code = [ULTools GetIntFromDic:copObject :@"code" :0];
            [self setCopJsonObject:copObject];
            [self returnCopInfo:copInfoStr];
            //停止定时器
            [self performSelector:@selector(cancelThreadTimer) onThread:copRequestThread withObject:nil waitUntilDone:YES];
            //初始化广告
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_MANAGER_INIT_ADV withData:nil];
            });
            
//            //关闭线程
//            if([copRequestThread isFinished]&& [copRequestThread isCancelled]){
//                [copRequestThread cancel];
//                [NSThread exit];
//            }
        }else{
            NSLog(@"%s%@%@",__func__,@"cop request error : ",error);
            
        }
        
        
    }
                                    ];
    
    //5.执行任务
    [dataTask resume];
}

+ (void)cancelThreadTimer
{
    
    [[ULTimer getInstance]destroyTimerWithName:UL_COP_TIMER_NAME];
    
}


+ (NSString *)getRequestUrl :(NSDictionary *)config
{
    NSString *copAddr = [ULTools GetStringFromDic:config :@"s_common_cop_addr" :@"http://copv6.ultralisk.cn/getdata/"];
    NSString *copGameId = [ULTools GetStringFromDic:config :@"s_common_cop_game_id" :@"-1"];
    NSString *copChannelId = [ULTools GetStringFromDic:config :@"s_common_cop_channel_id" :@"-1"];
    NSString *versionName = [ULTools GetStringFromDic:config :@"s_common_cop_version" :@"-1"];
    //TODO ios这边的下列待定
    NSString *signmd5 = @"";
    NSString *imsi = @"";
    NSString *iccid = @"";
    NSString *deviceCode = @"";
    NSString *device = @"";
    NSString *systemVersion = @"";
    
    NSString *requestUrl = [[NSString alloc]initWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",copAddr,@"?gameid=",copGameId,@"&version=",versionName,@"&signmd5=",signmd5,@"&qudao=",copChannelId,@"&uid=",deviceCode,@"&os=ios-",systemVersion,@"&devices=",device,@"&imsi=",imsi,@"&iccid=",iccid];
    
    NSLog(@"%s%@%@",__func__,@"cop请求地址:",requestUrl);
    
    return requestUrl;
}


+ (NSDictionary*)getCopInfo{
    return copInfoDic;
}


+ (void)setCopJsonObject:(NSDictionary *)json
{
    copInfoDic = json;
}

+ (NSString *)getCopInfoString
{
    if (!copInfoDic) {
        return @"{}";
    }
    return [ULTools DictionaryToString:copInfoDic];
}


+ (void)returnCopInfo:(NSString *)copInfoStr
{
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:copInfoStr forKey:@"copInfo"];
    
    NSDictionary *cop = [ULTools StringToDictionary:copInfoStr];
    //是否显示互动广告按钮
    NSString *url = [ULTools GetStringFromDic:cop :@"s_sdk_adv_h5_url" :@""];
    if (![url isEqualToString:@""]) {
        [json setValue:[NSNumber numberWithBool:true] forKey:@"isShowUrlAdIcon"];
    }else{
        [json setValue:[NSNumber numberWithBool:false] forKey:@"isShowUrlAdIcon"];
    }
    //是否显示互推更多游戏按钮
    NSString *urlMoreGame = [ULTools GetStringFromDic:cop :@"s_sdk_ul_more_game_url" :@""];
    if (![urlMoreGame isEqualToString:@""]) {
        [json setValue:[NSNumber numberWithBool:true] forKey:@"isULMoreGame"];
    }else{
        [json setValue:[NSNumber numberWithBool:false] forKey:@"isULMoreGame"];
    }
    //是否显示互推按钮
    NSString *inner = [ULTools GetStringFromDic:cop :@"s_sdk_inner_promotion_data" :@""];
    if (inner && ![inner isEqualToString:@""]) {
        [json setValue:[NSNumber numberWithBool:true] forKey:@"isShowUlInnerPromotionIcon"];
    }else{
        [json setValue:[NSNumber numberWithBool:false] forKey:@"isShowUlInnerPromotionIcon"];
    }
    [ULSDKManager JsonRpcCall:REMSG_CMD_COPINFO :json];
}

@end
