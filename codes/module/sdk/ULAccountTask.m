//
//  ULAccountTask.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/23.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULAccountTask.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULCmd.h"
#import "ULAccountSQLiteManager.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULTimer.h"
#import "ULConfig.h"

static NSString *const UL_ACCOUNT_TASK_WRITE_THREAD = @"ul_account_task_write_thread";
static NSString *const UL_ACCOUNT_TASK_READ_THREAD = @"ul_account_task_read_thread";
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


@end

@implementation ULAccountTask

- (void)onInitModule {
    NSLog(@"%s",__func__);
    _isCloseAccount = [ULTools getCopOrConfigStringWithKey:@"s_sdk_close_account_system" withDefaultString:@"0"];
    if([_isCloseAccount isEqualToString:@"1"]){
        NSLog(@"%s:统计功能关闭",__func__);
        return;
    }
    
    _accountAddr = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_common_account_addr" :@"0"];
    if ([_accountAddr isEqualToString:@"0"]) {
        _accountAddr = UL_ACCOUNT_AAR_DEFAULT_URL;
    }
    [self addListener];
    //创建工作线程
    [self createTaskThread];
    
}

- (void)addListener
{
    NSLog(@"%s",__func__);
    
}


- (void)createTaskThread
{
    NSLog(@"%s",__func__);
    //创建线程
    _upDataWriteThread = [[NSThread alloc]initWithTarget:self selector:@selector(upDataWrite:) object:nil];
    _upDataWriteThread.name = UL_ACCOUNT_TASK_WRITE_THREAD;
    _upDataWriteThread.qualityOfService = NSQualityOfServiceDefault;
    [_upDataWriteThread start];
    
    _upDataReadThread = [[NSThread alloc]initWithTarget:self selector:@selector(upDataRead:) object:nil];
    _upDataReadThread.name = UL_ACCOUNT_TASK_READ_THREAD;
    _upDataReadThread.qualityOfService = NSQualityOfServiceDefault;
    [_upDataReadThread start];
}

//以写入第一条数据作为工作启动机制
- (void)upDataWrite:(NSThread *)thread
{
    NSLog(@"%s",__func__);
    //判断数据库是否打开
    if(!_isSqliteOpened){
        _isSqliteOpened = [[ULAccountSQLiteManager getInstance]openDB];
    }
    //判断数据库相应的表是否已经创建
    if (!_isTableCreated) {
        _isTableCreated = [[ULAccountSQLiteManager getInstance]createTable];
    }
    //注册数据存储消息
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_ACCOUNT_WRITE_DATA withSelector:@selector(saveDataToSqlite:) withPriority:PRIORITY_NONE];
}


- (void)saveDataToSqlite:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    NSDictionary *userInfo = notification.userInfo;
    NSString *data = userInfo[@"data"];
    //TODO 数据存入失败的情况
    [[ULAccountSQLiteManager getInstance] insertData:data];
    //创建一个timer,定时上报数据
    [self createTimer];
    long dataCount = [[ULAccountSQLiteManager getInstance]getCountNumFromSqlite];
    if (dataCount >= UL_ACCOUNT_DATA_THRESHOLD) {
        //超过指定数据量直接上报
        [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_ACCOUNT_READ_DATA withData:nil];
    }
}

- (void)createTimer
{
    NSLog(@"%s",__func__);
    NSTimer *timer = [[ULTimer getInstance] createTimerWithName:UL_ACCOUNT_TIMER_NAME withTarget:self withTime:UL_ACCOUNT_TIMER_LOOP_TIME withSel:@selector(sendMsgToReadThread:) withUserInfo:nil withRepeat:YES];
    //立即执行
    [timer fire];
    //线程中创建的timer需要添加到runloop中
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runloop run];
}


- (void)sendMsgToReadThread:(NSTimer *)timer
{
    NSLog(@"%s",__func__);
    [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_ACCOUNT_READ_DATA withData:nil];
}


- (void)upDataRead:(NSThread *)thread
{
    NSLog(@"%s",__func__);
    //注册数据读取消息
    [[ULNotificationDispatcher getInstance]addNotificationWithObserver:self withName:UL_NOTIFICATION_ACCOUNT_READ_DATA withSelector:@selector(getDataFromSqlite:) withPriority:PRIORITY_NONE];
    
}


- (void)getDataFromSqlite:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    //获取数据
    NSString *data = @"";
    [self requestPost:data];
    
}


- (void)requestPost :(NSString *)data
{
    //请求地址
    NSURL *url = [NSURL URLWithString:_accountAddr];
    //设置请求地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    NSDictionary * paramsDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                data,@"updata",nil];
    
    //设置请求参数
    request.HTTPBody = [[self getRequestParams: paramsDic] dataUsingEncoding:NSUTF8StringEncoding];
    //关于parameters是NSDictionary拼接后的NSString.关于拼接看后面拼接方法说明
    
    
    //设置请求session
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    //设置网络请求的返回接收器
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%s 数据上报异常:error = %@",__func__,error);
                //数据重新存储
            }else
            {
                NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                if(![result isEqualToString:@"Successful"]){
                    
                    //数据重新存储
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


- (void)megadataAccount :(NSDictionary *)data
{
    
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
}

- (void)applicationDidEnterBackground {
    //开启后台任务,进行数据上报，测试只有3分钟
    UIApplication *application = [UIApplication sharedApplication];
    NSLog(@"%s:可持续后台运行时间：%f",__func__,application.backgroundTimeRemaining);
    __block UIBackgroundTaskIdentifier taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"%s",__func__);
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
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


@end
