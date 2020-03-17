//
//  ULAccountTask.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/23.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

/**
 在线时长：
 取“UIApplicationDidBecomeActiveNotification”和“UIApplicationWillResignActiveNotification”两个系统消息之间的时长差值。iOS退到后台无论多长时间再回到前端都视为一次新启动。
 
 */

#import "ULAccountTask.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULCmd.h"
#import "ULAccountSQLiteManager.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULTimer.h"
#import "ULConfig.h"
#import "ULAccountBean.h"
#import "ULGetDeviceId.h"
#import "ULAccountType.h"
#import "ULSDKManager.h"
#import "ULCop.h"

static NSString *const UL_ACCOUNT_TASK_WRITE_THREAD = @"ul_account_task_write_thread";
static NSString *const UL_ACCOUNT_TASK_THREAD = @"ul_account_task_thread";
static int const UL_ACCOUNT_DATA_THRESHOLD = 100;
static int const UL_ACCOUNT_TIMER_LOOP_TIME = 20;
static NSString *const UL_ACCOUNT_TIMER_NAME = @"ul_account_timer";
static NSString *const UL_ACCOUNT_AAR_DEFAULT_URL = @"http://192.168.1.246:6011/batchuploaddata";

@interface ULAccountTask ()<ULILifeCycle>

@property(nonatomic,strong)NSString *isCloseAccount;
@property(nonatomic,strong)NSThread *upDataWriteThread,*upDataReadThread;
@property(nonatomic,assign)BOOL isSqliteOpened,isTableCreated;
@property(nonatomic,strong)NSTimer *accountTimer;
@property(nonatomic,strong)NSString *accountAddr;
@property(nonatomic,strong)NSString *activeTime,*resignActiveTime,*gameStartTime;
@property(nonatomic,strong)NSString *gameLevelStartTime,*gameLevelCompleteTime;
@property(nonatomic,assign)BOOL isWriteThreadInitFinish,isReadThreadInitFinish;
@property(nonatomic,strong)NSMutableArray *cacheList;
@property(nonatomic,assign)BOOL isSaveDataToSqliteFirstCall;
@property(nonatomic,strong)dispatch_queue_t writeQueue,readQueue;
@end

@implementation ULAccountTask

- (void)onInitModule {
    NSLog(@"%s",__func__);
    _isCloseAccount = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_sdk_close_account_system" :@"0"];
    if([_isCloseAccount isEqualToString:@"1"]){
        NSLog(@"%s:统计功能关闭",__func__);
        return;
    }
    _cacheList = [NSMutableArray new];
    
    
    _accountAddr = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_common_account_addr" :@"0"];
    if ([_accountAddr isEqualToString:@"0"]) {
        _accountAddr = UL_ACCOUNT_AAR_DEFAULT_URL;
    }
    [self addListener];
    
    
    
    //打开数据库和表
    [[ULAccountSQLiteManager getInstance]openDB];
    [[ULAccountSQLiteManager getInstance]createTable];
    
    
    
    
    //应用启动统计
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:[NSString stringWithFormat:@"%d",ULA_GAME_BASE_INFO]];
    [array addObject:@"gameStart"];
    [self upData:array];
    
    //[self createTimer];
}

- (void)addListener
{
    NSLog(@"%s",__func__);
    //提供外部调用消息，外部数据通过统一入口处理后再做上报
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_ACCOUNT_UP_DATA withSelector:@selector(onUpData:) withPriority:PRIORITY_NONE];
    //注册数据存储消息
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_ACCOUNT_WRITE_DATA withSelector:@selector(saveDataToSqlite:) withPriority:PRIORITY_NONE];
    //注册数据读取消息
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_ACCOUNT_READ_DATA withSelector:@selector(getDataFromSqlite:) withPriority:PRIORITY_NONE];
}

//数据存储消息回调
- (void)saveDataToSqlite:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    dispatch_queue_t writeQueue = dispatch_queue_create("ul_account_task_thread_write_queue", DISPATCH_QUEUE_SERIAL);
    // 异步串行队列
    dispatch_async(writeQueue, ^{
        NSLog(@"%s",__func__);
        NSDictionary *userInfo = notification.userInfo;
        NSString *data = userInfo[@"data"];
        
        //TODO 数据存入失败的情况
        [[ULAccountSQLiteManager getInstance] insertData:data];
        
        
        long dataCount = [[ULAccountSQLiteManager getInstance]getCountNumFromSqlite];
        NSLog(@"%s:当前数据库中数据总条数:%ld",__func__,dataCount);
        if (dataCount >= UL_ACCOUNT_DATA_THRESHOLD) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //超过指定数据量直接上报
                [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_ACCOUNT_READ_DATA withData:nil];
            });
        }
        [self createTimer];
        
    });
    
}


- (void)createTimer
{
    NSLog(@"%s",__func__);
    if (_accountTimer) {
        return;
    }
    _accountTimer = [[ULTimer getInstance] createTimerWithName:UL_ACCOUNT_TIMER_NAME withTarget:self withTime:UL_ACCOUNT_TIMER_LOOP_TIME withSel:@selector(sendMsgToReadThread:) withUserInfo:nil withRepeat:YES];
    //立即执行
    [_accountTimer fire];
    //线程中创建的timer需要添加到runloop中
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:_accountTimer forMode:NSRunLoopCommonModes];
    [runloop run];
}


- (void)sendMsgToReadThread:(NSTimer *)timer
{
    NSLog(@"%s",__func__);
    dispatch_async(dispatch_get_main_queue(), ^{
        //定时上报数据
        [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_ACCOUNT_READ_DATA withData:nil];
    });
    
}


//数据读取消息回调
- (void)getDataFromSqlite:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    dispatch_queue_t readQueue = dispatch_queue_create("ul_account_task_thread_read_queue", DISPATCH_QUEUE_SERIAL);
    // 异步串行队列
    dispatch_async(readQueue, ^{
        NSLog(@"%s",__func__);
        //获取数据
        //把数组对象转成json字符串存起来
        NSMutableArray *upDataBeanList = [[ULAccountSQLiteManager getInstance] getCountUpData];
        
        if(upDataBeanList.count == 0){
            NSLog(@"%s:数据库中暂无可上报数据",__func__);
            return;
        }
        
        NSMutableArray *jsonArray = [NSMutableArray new];
        
        for (ULAccountBean *bean in upDataBeanList) {
            NSString *upDataStr = bean.upData;
            NSLog(@"%s:bean.updata = %@",__func__,upDataStr);
            [jsonArray addObject:upDataStr];
            
        }
        
        
        //删除某个id之前的全部数据
        ULAccountBean *lastBean = [upDataBeanList lastObject];
        long number = lastBean.upDataId;
        [[ULAccountSQLiteManager getInstance]deleteData:number];
        
        [self requestPost:jsonArray];
    });
    
    
}


//数据上报消息回调
- (void)onUpData:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    NSDictionary *userInfo = notification.userInfo;
    NSArray *array = userInfo[@"data"];
    [self upData:array];
}

//缓存数据将在下次上报过程中加入
- (void)upData:(NSArray *)array
{
    NSLog(@"%s",__func__);
    //    if (!_isWriteThreadInitFinish) {//写入线程还未初始化完
    //        [self cacheData:array];
    //        return;
    //    }
    //检查缓存数据
    //    if (_cacheList.count > 0) {
    //        //缓存本次数据
    //        [self cacheData:array];
    //        //上报缓存数据
    //        [self postCacheData:_cacheList];
    //        return;
    //    }
    
    NSMutableDictionary *json = [self assembleJsonData:array];
    NSLog(@"%s%@",__func__,[ULTools DictionaryToString:json]);
    NSString *jsonStr = [ULTools DictionaryToString:json];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_WRITE_DATA withData:jsonStr];
}

- (void)cacheData :(NSArray *)array
{
    NSLog(@"%s",__func__);
    if (![_cacheList containsObject:array]) {
        [_cacheList addObject:array];
    }
}

- (void)postCacheData :(NSArray *)array
{
    for (NSArray *arr in array) {
        NSMutableDictionary *json = [self assembleJsonData:arr];
        NSString *jsonStr = [ULTools DictionaryToString:json];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_WRITE_DATA withData:jsonStr];
    }
    [_cacheList removeAllObjects];
}



//拼装json数据
- (NSMutableDictionary *)assembleJsonData:(NSArray *)array
{
    NSMutableDictionary *json = [NSMutableDictionary new];
    NSString *copGameId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cop_game_id" :@""];
    NSString *accountId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_common_account_id" :@""];
    NSString *copChannelId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cop_channel_id" :@""];
    NSString *copVersion = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_cop_version" :@""];
    NSString *channelName = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_channel_name" :@""];
    
    NSMutableArray *jsonArray = [NSMutableArray new];
    NSString *accountIdAndTypeId = [[NSString alloc] initWithFormat:@"%@%@%@",accountId,@"-",array[0]];
    [json setValue:accountIdAndTypeId forKey:@"typeid"];
    //基础数据
    NSString *upDataTime = [ULTools getCurrentTimes];
    [jsonArray addObject:upDataTime];//数据生成时间
    NSString *deviceId = [[NSString alloc] initWithFormat:@"%@%@%@",[ULGetDeviceId getUniqueDeviceId],@"_",copChannelId];
    [jsonArray addObject:deviceId];//唯一设备吗
    [jsonArray addObject:@""];//签名
    
    switch ([array[0] intValue]) {
        case ULA_GAME_BASE_INFO:
            _gameStartTime = upDataTime;
            [jsonArray addObject:[ULTools getIMSI]];//IMSI //TODO
            [jsonArray addObject:[ULTools getICCID]];//ICCID //TODO
            [jsonArray addObject:[ULTools getCurrentAppName]];//游戏名称
            [jsonArray addObject:copGameId];//gameId
            [jsonArray addObject:[ULTools getProvidersName]];//运营商
            [jsonArray addObject:copChannelId];//渠道id
            [jsonArray addObject:copVersion];//cop版本
            [jsonArray addObject:[ULTools getCurrentPhoneVersion]];//ios版本
            [jsonArray addObject:array[1]];//统计类型
            [jsonArray addObject:[ULTools getIMEI]];//IMEI //TODO
            [jsonArray addObject:[ULConfig getUlsdkVersion]];//sdk版本号
            [jsonArray addObject:[ULTools platformString]];//设备型号
            break;
        case ULA_GAME_PAY_INFO:
            [jsonArray addObject:array[1]];//支付渠道
            [jsonArray addObject:array[2]];//支付类型
            [jsonArray addObject:array[3]];//支付金额
            [jsonArray addObject:array[4]];//支付结果/统计类型
            [jsonArray addObject:copVersion];//cop版本
            [jsonArray addObject:[ULConfig getUlsdkVersion]];//sdk版本号
            break;
        case ULA_GAME_ADV_INFO:
            [jsonArray addObject:array[1]];//广告渠道
            [jsonArray addObject:array[2]];//广告类型
            [jsonArray addObject:array[3]];//展示结果/买点请求/广告请求
            [jsonArray addObject:array[4]];//失败原因
            [jsonArray addObject:copVersion];//cop版本
            [jsonArray addObject:[ULConfig getUlsdkVersion]];//sdk版本号
            [jsonArray addObject:array[5]];//advGroupId
            [jsonArray addObject:array[6]];//advId
            [jsonArray addObject:array[7]];//广告买点信息
            [jsonArray addObject:array[8]];//原生广告内容标题
            [jsonArray addObject:array[9]];//原生广告参数
            break;
        case ULA_GAME_COP_REQUEST:
            [jsonArray addObject:array[1]];//统计类型
            [jsonArray addObject:array[2]];//请求结果
            [jsonArray addObject:copVersion];//cop版本
            [jsonArray addObject:[ULConfig getUlsdkVersion]];//sdk版本号
            [jsonArray addObject:array[3]];//cop请求失败原因
            [jsonArray addObject:array[4]];//返回的json字段
            break;
        case ULA_GAME_USER_EVENT:
            for (int i = 1; i < array.count; i++) {
                [jsonArray addObject:array[i]];
            }
            [jsonArray addObject:copVersion];//cop版本
            [jsonArray addObject:[ULConfig getUlsdkVersion]];//sdk版本号
            [jsonArray addObject:channelName];//渠道信息
            break;
        case ULA_GAME_USER_ONLINE_TIME:
            [jsonArray addObject:array[1]];//与用户活跃表关联的唯一标示
            [jsonArray addObject:array[2]];//在线时长
            [jsonArray addObject:copVersion];//cop版本
            [jsonArray addObject:[ULConfig getUlsdkVersion]];//sdk版本号
            break;
    }
    
    [json setValue:jsonArray forKey:@"updata"];
    
    return json;
}














- (void)requestPost :(NSArray *)jsonArray
{
    
    NSMutableArray *upArray = [NSMutableArray new];
    
    for (NSString *s in jsonArray) {
        NSDictionary *upDataJson = [ULTools StringToDictionary:s];
        if (upDataJson) {
            [upArray addObject:upDataJson];
        }
        
        
    }
    
    //将数据数组转为字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:upArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonArrayStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%s：上报数据:%@",__func__,jsonArrayStr);
    //请求地址
    NSURL *url = [NSURL URLWithString:_accountAddr];
    //设置请求地址
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    //设置请求头格式
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%s：上报数据:%@",__func__,jsonArrayStr);
    jsonArrayStr = [ULTools encodeToPercentEscapeString:jsonArrayStr];//包含；字符会被截断，此处进行转码
    NSString *requestData = [[NSString alloc] initWithFormat:@"%@=%@",@"updata",jsonArrayStr];
    //设置请求参数
    [request setHTTPBody:[requestData dataUsingEncoding:NSUTF8StringEncoding]];
    //超时时长
    //request.timeoutInterval = 5;
    
    
    //设置请求session
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    //设置网络请求的返回接收器
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%s 数据上报异常:error = %@",__func__,error);
                //数据重新存储
                for (NSString *str in jsonArray) {
                    NSLog(@"%s:数据上报失败重新存入 = %@",__func__,str);
                    [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_ACCOUNT_WRITE_DATA withData:str];
                }
                
            }else
            {
                NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                if(![result isEqualToString:@"Successful"]){
                    
                    //数据重新存储
                    for (NSString *str in jsonArray) {
                        [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_ACCOUNT_WRITE_DATA withData:str];
                    }
                }else{
                    NSLog(@"%s:数据上报成功",__func__);
                }
                
            }
        });
        
        
    }];
    //开始请求
    [dataTask resume];
}







//网络请求参数拼接：存在目前已知问题 1.字符串过长会出现被截取的情况 2.字符串中出现空格
- (NSString *)getRequestParams :(NSDictionary *)parameters
{
    //创建可变字符串来承载拼接后的参数
    NSMutableString *parameterString = [NSMutableString new];
    //获取parameters中所有的key
    NSArray *parameterArray = parameters.allKeys;
    for (int i = 0;i < parameterArray.count;i++) {
        //根据key取出所有的value
        id value = parameters[parameterArray[i]];
        //把parameters的key 和 value进行拼接
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",parameterArray[i],value];
        if (i == parameterArray.count || i == 0) {
            //如果当前参数是最后或者第一个参数就直接拼接到字符串后面，因为第一个参数和最后一个参数不需要加 “&”符号来标识拼接的参数
            [parameterString appendString:keyValue];
        }else
        {
            //拼接参数， &表示与前面的参数拼接
            [parameterString appendString:[NSString stringWithFormat:@"&%@",keyValue]];
        }
    }
    return parameterString;
}


- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    NSDictionary *json = [ULTools StringToDictionary: param];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_MEGADATASERVER]) {
        [self megadataAccount:data];
    }
    return nil;
}


- (void)megadataAccount :(NSArray *)data
{
    
    NSLog(@"%s",__func__);
    if([_isCloseAccount isEqualToString:@"1"]){
        NSLog(@"%s:统计功能关闭",__func__);
        NSMutableDictionary *json = [NSMutableDictionary new];
        [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
        [json setValue:@"failed" forKey:@"message"];
        [ULSDKManager JsonRpcCall:REMSG_CMD_MEGADATASERVER :json];
        return;
    }
    
    //是否关闭自定义数据上传，默认不关闭
    NSString *isCloseCustomData = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_sdk_account_close_custom" :@"0"];
    if ([isCloseCustomData isEqualToString:@"1"]) {
        NSMutableDictionary *json = [NSMutableDictionary new];
        [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
        [json setValue:@"failed" forKey:@"message"];
        [ULSDKManager JsonRpcCall:REMSG_CMD_MEGADATASERVER :json];
        return;
    }
    
    if (!data || data.count == 0) {
        NSMutableDictionary *json = [NSMutableDictionary new];
        [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
        [json setValue:@"failed" forKey:@"message"];
        [ULSDKManager JsonRpcCall:REMSG_CMD_MEGADATASERVER :json];
    }else{
        NSMutableDictionary *json = [NSMutableDictionary new];
        [json setValue:[NSNumber numberWithInt:1] forKey:@"code"];
        [json setValue:@"success" forKey:@"message"];
        [ULSDKManager JsonRpcCall:REMSG_CMD_MEGADATASERVER :json];
    }
    
    NSMutableArray *strArray = [NSMutableArray new];
    NSString *actionTypeStr = data[0];
    if ([actionTypeStr isEqualToString:@"gameLevelStart"]) {//关卡开始
        NSDate *datenow = [NSDate date];//当前时间戳，单位s
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        _gameLevelStartTime = timeSp;
    }
    if ([actionTypeStr isEqualToString:@"gameLevelComplete"]) {//关卡结束
        NSDate *datenow = [NSDate date];//当前时间戳，单位s
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        _gameLevelCompleteTime = timeSp;
        long complete = [_gameLevelCompleteTime longLongValue] - [_gameLevelStartTime longLongValue];//通关时间
        
        [strArray addObject:[NSString stringWithFormat:@"%d",ULA_GAME_USER_EVENT]];
        for (int i = 0; i < data.count; i++) {
            //TODO 需要验证ios这边传过来的数组字符串是否也是异常
            //            @try {//传过来是字符类型，那么会""test""是这种的形式
            //                strArray[i + 1] = [data[i] substringWithRange:NSMakeRange(1,[data[i] length]-1)];
            //            } @catch (NSException *e) {//传过来的是非字符类型则不做去""处理
            //                [strArray addObject:data[i]];
            //            }
            [strArray addObject:data[i]];
        }
        [strArray addObject:[NSString stringWithFormat:@"%ld",complete]];
        [self upData:strArray];
        return;
    }
    [strArray addObject:[NSString stringWithFormat:@"%d",ULA_GAME_USER_EVENT]];
    for (int i = 0; i < data.count; i++) {
        //TODO 需要验证ios这边传过来的数组字符串是否也是异常
        //        @try {//传过来是字符类型，那么会""test""是这种的形式
        //            strArray[i + 1] = [data[i] substringWithRange:NSMakeRange(1,[data[i] length]-1)];
        //        } @catch (NSException *e) {//传过来的是非字符类型则不做去""处理
        //            [strArray addObject:data[i]];
        //        }
        [strArray addObject:data[i]];
    }
    [self upData:strArray];
    
    
    
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


- (void)applicationDidBecomeActive {
    NSLog(@"%s",__func__);
    if([_isCloseAccount isEqualToString:@"1"]){
        NSLog(@"%s:统计功能关闭",__func__);
        return;
    }
    NSDate *datenow = [NSDate date];//当前时间戳，单位s
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    _activeTime = timeSp;
}

- (void)applicationDidEnterBackground {
    //开启后台任务,进行数据上报，测试只有3分钟
    //    UIApplication *application = [UIApplication sharedApplication];
    //    NSLog(@"%s:可持续后台运行时间：%f",__func__,application.backgroundTimeRemaining);
    //    __block UIBackgroundTaskIdentifier taskId = [application beginBackgroundTaskWithExpirationHandler:^{
    //        NSLog(@"%s",__func__);
    //        [[UIApplication sharedApplication] endBackgroundTask:taskId];
    //        taskId = UIBackgroundTaskInvalid;
    //    }];
}

- (void)applicationDidReceiveMemoryWarning {
    NSLog(@"%s",__func__);
}

- (void)applicationWillEnterForeground {
    NSLog(@"%s",__func__);
}

- (void)applicationWillResignActive {
    NSLog(@"%s",__func__);
    if([_isCloseAccount isEqualToString:@"1"]){
        NSLog(@"%s:统计功能关闭",__func__);
        return;
    }
    NSDate *datenow = [NSDate date];//当前时间戳，单位s
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    _resignActiveTime = timeSp;
    long onlineTime = [_resignActiveTime longLongValue]-[_activeTime longLongValue];
    NSLog(@"%s:本次在线时长:%ld",__func__,onlineTime);
    [self upData:@[[NSString stringWithFormat:@"%d",ULA_GAME_USER_ONLINE_TIME],_gameStartTime,[NSString stringWithFormat:@"%ld",onlineTime]]];
    
    //停止定时器
    //[self performSelector:@selector(cancelThreadTimer) onThread:_upDataWriteThread withObject:nil waitUntilDone:YES];
}


- (void)cancelThreadTimer
{
    
    [[ULTimer getInstance]destroyTimerWithName:UL_ACCOUNT_TIMER_NAME];
    
}

- (void)applicationWillTerminate {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    NSLog(@"%s",__func__);
}





@end
