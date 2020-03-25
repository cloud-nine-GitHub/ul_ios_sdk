//
//  ULNativeAdvItemCacher.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/16.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULNativeAdvItemCacher.h"
#import "ULCop.h"
#import "ULConfig.h"
#import "ULTools.h"
#import "ULQueue.h"




static const int UL_NATIVE_RESPONSE_CACHE_DEFAULT_TIME = 15 * 1000;
static const int UL_NATIVE_RESPONSE_CACHE_MIN_TIME = 0;
static const int UL_NATIVE_RESPONSE_CACHE_MAX_TIME = 30 * 1000;



@interface ULNativeAdvItemCacher ()<ULINativeAdvItemCallback>

@property (nonatomic,assign) int responseCacheTimeout;
@property (nonatomic,strong) id <ULINativeAdvItemProvider> nativeAdvItemProvider;
//参数-item存储map
@property (nonatomic,strong) NSMutableDictionary *nativeAdvItemMap;
//原生response缓存队列
@property (nonatomic,strong) NSMutableDictionary *nativeResponseCacheQueueMap;
//参数-正在使用的response存储map(点击或超时后失效)
@property (nonatomic,strong) NSMutableDictionary *nativeResponseUsingMap;
@property (nonatomic,strong) NSMutableDictionary *nativeResponseUsingTimeoutMap;

@property (nonatomic,strong) NSMutableDictionary *requestingMap;
@property (nonatomic,strong) NSMutableDictionary *nativeAdvCallbackQueueMap;

@property (nonatomic,strong) NSMutableDictionary *randomParamAdvTagMap;
@property (nonatomic,strong) id <ULINativeAdvItemCallback> advCallback;

@property (nonatomic,strong) NSMutableDictionary *nativeCallBackJsonMap;
@property (nonatomic,strong) NSMutableDictionary *nativeItemParamsMap;

@end

@implementation ULNativeAdvItemCacher

-(id)initWithProvider:(id <ULINativeAdvItemProvider>)provider
{
    if (self = [super init]) {
        NSString *timeout = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_sdk_adv_native_response_cache_timeout" :@""];//单位毫秒
        int timeoutInt;
        if ([timeout isEqualToString:@""]) {
            timeoutInt = UL_NATIVE_RESPONSE_CACHE_DEFAULT_TIME;
        }else{
            @try {
                timeoutInt = [timeout intValue];//配置错误，非数字类型
            } @catch (NSException *exception) {
                timeoutInt = UL_NATIVE_RESPONSE_CACHE_DEFAULT_TIME;
            }
            
            if (timeoutInt < UL_NATIVE_RESPONSE_CACHE_MIN_TIME) {
                timeoutInt = UL_NATIVE_RESPONSE_CACHE_MIN_TIME;
            }else if (timeoutInt > UL_NATIVE_RESPONSE_CACHE_MAX_TIME){
                timeoutInt = UL_NATIVE_RESPONSE_CACHE_MAX_TIME;
            }
                
        }
        _responseCacheTimeout = timeoutInt;
        NSLog(@"%s%@",__func__,[[NSString alloc]initWithFormat:@"%@%d%@", @"原生缓存时间:",_responseCacheTimeout,@"s"]);
        [self init:provider];
    }
    return self;
}

- (void)init :(id <ULINativeAdvItemProvider>)provider
{
    _nativeAdvItemProvider = provider;
    _nativeAdvItemMap = [NSMutableDictionary new];
    _nativeResponseCacheQueueMap = [NSMutableDictionary new];
    _nativeResponseUsingMap = [NSMutableDictionary new];
    _nativeResponseUsingTimeoutMap = [NSMutableDictionary new];
    _requestingMap = [NSMutableDictionary new];
    _nativeAdvCallbackQueueMap = [NSMutableDictionary new];
    _randomParamAdvTagMap = [NSMutableDictionary new];
    _nativeCallBackJsonMap = [NSMutableDictionary new];
    _nativeItemParamsMap = [NSMutableDictionary new];
    _advCallback = self;
}

- (void)onGetItemSuccessed:(NSMutableDictionary *)gameJson :(id )response :(NSString *)advParam
{
    //当前返回的response放入队列并yy投入使用
    ULQueue *cacheQueue = [self getNativeResponseCacheQueue:advParam];
    [cacheQueue enQueue:response];
    
    id requestingFlag = [_requestingMap objectForKey:advParam];
    if (requestingFlag && [requestingFlag boolValue]) {
        [_requestingMap removeObjectForKey:advParam];
        
        [self tryGetItem:advParam :gameJson];
    }
}

- (void)onGetItemFailed:(NSMutableDictionary *)gameJson :(id )response :(NSString *)advParam :(id )error
{
    id requestingFlag = [_requestingMap objectForKey:advParam];
    if (requestingFlag && [requestingFlag boolValue]) {
        [_requestingMap removeObjectForKey:advParam];
        
        [self callFailed:advParam :error];
    }
}

- (ULQueue *)getNativeResponseCacheQueue: (NSString *)advParam
{
    ULQueue *queue = [_nativeResponseCacheQueueMap objectForKey:advParam];
    if (!queue) {
        queue =  [[ULQueue alloc]init];
        [_nativeResponseCacheQueueMap setValue:queue forKey:advParam];
    }
    return queue;
}

- (ULQueue *)getCallbackQueue :(NSString *)advParam
{
    ULQueue *queue = [_nativeAdvCallbackQueueMap objectForKey:advParam];
    if (!queue) {
        queue =  [[ULQueue alloc]init];
        [_nativeAdvCallbackQueueMap setValue:queue forKey:advParam];
    }
    return queue;
}

- (void)getAdvItem :(NSString *)advId :(NSString *)paramString :(NSDictionary *)gameJson :(CacheCallback) callback
{
    [_randomParamAdvTagMap setValue:paramString forKey:advId];
    //TODO 字典不能将对象作为key
    [_nativeCallBackJsonMap setValue:gameJson forKey:@""];
    
    ULQueue *queue = [self getCallbackQueue:paramString];
    [queue enQueue:callback];
    
    [self tryGetItem:paramString :gameJson];
}

- (void)tryGetItem:(NSString *)paramString :(NSDictionary *)gameJson
{
    id response = [_nativeResponseUsingMap objectForKey:paramString];
    id timeoutTick = [_nativeResponseUsingTimeoutMap objectForKey:paramString];
    if (response && (timeoutTick && [timeoutTick longValue] < [[ULTools getNowTimeTimestamp] longLongValue])) {
        //
    }
    if(!response || (!timeoutTick && [timeoutTick longValue] < [[ULTools getNowTimeTimestamp] longLongValue])){
        response = [[self getNativeResponseCacheQueue:paramString] deQueue];
        
        if (!response) {
            id requestingFlag = [_requestingMap objectForKey:paramString];
            if (requestingFlag && [requestingFlag boolValue]) {
                return;
            }
            [_requestingMap setValue:[NSNumber numberWithBool:true] forKey:paramString];
            
            id <ULINativeAdvItem> advItem = [_nativeAdvItemMap objectForKey:paramString];
            if (!advItem) {
                //TODO 需要判断当前的vc是否为nil吗？
                advItem = [_nativeAdvItemProvider getItem:paramString :_advCallback];
                [_nativeAdvItemMap setValue:advItem forKey:paramString];
            }
            
            [advItem load:gameJson];
            return;
        }else{
            [_nativeResponseUsingMap setValue:response forKey:paramString];
            [_nativeResponseUsingTimeoutMap setValue:[NSString stringWithFormat:@"%lld",[[ULTools getNowTimeTimestamp] longLongValue] + _responseCacheTimeout] forKey:paramString];
            
            [_nativeItemParamsMap setValue:response forKey:paramString];
        }
    }
    
    [self callSuccess:paramString :response];
}

- (void)callSuccess:(NSString *)advParam :(id)response
{
    ULQueue *queue = [self getCallbackQueue:advParam];
    while (true) {
        CacheCallback callback = [queue deQueue];
        if (!callback) {
            break;
        }
        NSDictionary *gameJson = [_nativeCallBackJsonMap objectForKey:callback];
        [_nativeCallBackJsonMap removeObjectForKey:callback];
        callback(gameJson,response,nil);
    }
}

- (void)callFailed:(NSString *)advParam :(id)error
{
    ULQueue *queue = [self getCallbackQueue:advParam];
    while (true) {
        CacheCallback callback = [queue deQueue];
        if (!callback) {
            break;
        }
        NSDictionary *gameJson = [_nativeCallBackJsonMap objectForKey:callback];
        [_nativeCallBackJsonMap removeObjectForKey:callback];
        callback(gameJson,nil,error);
    }
}

- (id)pollUsingItem :(NSString *)advId
{
    NSString *paramString = [_randomParamAdvTagMap objectForKey:advId];
    if (!paramString) {
        return nil;
    }
    id obj = [_nativeResponseUsingMap objectForKey:paramString];
    [_nativeResponseUsingMap removeObjectForKey:paramString];
    return obj;
}



@end


