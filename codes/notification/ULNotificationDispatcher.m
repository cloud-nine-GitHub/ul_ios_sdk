//
//  ULNotificationDispatcher.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//


/*
 
 
 这里需要封装消息，提供消息分发优先级，满足聚合需求
 提供注册、分发、移除消息函数；消息需要分x优先级，消息可暂停分发
 
 // 观察方式A:selector方式
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xxx) name:@"111" object:nil];
 // 观察方式B:block方式(queue参数决定你想把该block在哪一个NSOperationQueue里面执行)
 [[NSNotificationCenter defaultCenter] addObserverForName:@"111" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
 NSLog(@"block %d", ++count);
 }];
 
 // 发送方式A:手动定义NSNotification
 NSNotification *noti = [NSNotification notificationWithName:@"111" object:nil];
 [[NSNotificationCenter defaultCenter] postNotification:noti];
 // 发送方式B:自动定义NSNotification
 [[NSNotificationCenter defaultCenter] postNotificationName:@"111" object:nil userInfo:nil];
 
 
 
 1.对于不同的观察者注册统一条消息（消息名相同），本身在分发的时候就是谁先背注册就先调用谁
 
 **/

#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULNotificationListener.h"

static int const PRIORITY_NONE = -2;

@implementation ULNotificationDispatcher

static ULNotificationDispatcher *instance = nil;
static NSMutableDictionary *classAndPriorityDic = nil;//装载当前注册消息的class及其消息的优先级
static NSMutableDictionary *typeWithClassAndPriorityDic = nil;//装载当前消息类型和消息对应的class及优先级map
static NSMutableDictionary *typeWithPriorityArrayDic = nil;//装载当前消息的有序优先级数组
static NSMutableDictionary *typeWithClassArrayDic = nil;//装载当前消息的有序类数组

+ (instancetype)getInstance{
    if(!instance){
        instance = [[self alloc] init];
        typeWithClassAndPriorityDic = [[NSMutableDictionary alloc] init];
    }
    return instance;
}


- (void)addNotificationWithObserver:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority
{
    [self addNotificationWithObserver:classObj withName:notificationName withSelector:sel withPriority:priority withDispatchOnceFlag:NO withExtra:nil];
}

//添加透传参数字段支持
- (void)addNotificationWithObserver:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority withExtra:(NSObject *_Nullable)extra
{
    [self addNotificationWithObserver:classObj withName:notificationName withSelector:sel withPriority:priority withDispatchOnceFlag:NO withExtra:extra];
}


- (void)addNotificationWithObserverOnce:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority
{
    [self addNotificationWithObserver:classObj withName:notificationName withSelector:sel withPriority:priority withDispatchOnceFlag:YES withExtra:nil];
}

//添加透传参数字段支持
- (void)addNotificationWithObserverOnce:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority withExtra:(id _Nullable)extra
{
    [self addNotificationWithObserver:classObj withName:notificationName withSelector:sel withPriority:priority withDispatchOnceFlag:YES withExtra:extra];
}


- (void)addNotificationWithObserver:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority withDispatchOnceFlag:(BOOL )dispatchOnce withExtra:(id _Nullable)extra
{
    //消息不满足注册条件不执行注册
    if (priority < PRIORITY_NONE) {
        return;
    }
    
    NSMutableArray *array = [typeWithClassAndPriorityDic objectForKey:notificationName];
    if (array == nil) {
        array = [[NSMutableArray alloc]init];
        [typeWithClassAndPriorityDic setValue:array forKey:notificationName];
    }
    
    int insertIndex = -1;
    int count = (int )[array count];
    for (int i=0; i<count; i++) {
        ULNotificationListener *listener = array[i];
        id mClassObj = listener.callClassObj;
        int pri = listener.priority;
        NSString *name = listener.notificationName;
        if (classObj == mClassObj && priority == pri && [notificationName isEqualToString:name]) {//对于完全一模一样的消息没必要多次注册
            //该消息已经注册，避免重复注册
            return;
        }
        int mPriority = listener.priority;
        if (insertIndex == -1 && mPriority < priority) {
            insertIndex = i;
        }
        
    }
    ULNotificationListener *listener = [[ULNotificationListener alloc] initWithPriority:priority withNotificationName:notificationName withClassObj:classObj withDispatchOnce:dispatchOnce withExtra:extra];
    
    if (insertIndex != -1) {
        [array insertObject:listener atIndex:insertIndex];
    }else{
        [array addObject:listener];
    }
    
    //对象方法检测
    if ([classObj respondsToSelector:sel]) {
        //通知命名：名称+优先级 确保唯一
        [[NSNotificationCenter defaultCenter] addObserver:classObj selector:sel name:[NSString stringWithFormat:@"%@%d",notificationName,priority] object:classObj];
    }else{
        NSLog(@"%s%@%@",__func__,[classObj class],@" no such method,can't add observer");
    }
    
}



- (BOOL)postNotificationWithName :(NSString *)notificationName withData:(id _Nullable)data
{
    ULNotification *notification = [[ULNotification alloc]initWithNotificationName:notificationName withData:data];
    return [self postNotification:notification];
    
}




- (BOOL) postNotification:(ULNotification *)notification
{
    BOOL flag = NO;
    NSMutableArray *array = [typeWithClassAndPriorityDic objectForKey:notification.name];
    if (array == nil) {
        return flag;
    }
    
    int count = (int )array.count;
    
    if (count == 0) {
        return flag;
    }
    
    for (int i = 0; i < count; i++) {
        ULNotificationListener *listener = array[i];
        id mClassObj = listener.callClassObj;
        
        if (listener.hasDispatched) {
            continue;
        }
        
        if (listener.dispatchOnce) {
            listener.hasDispatched = true;
        }
        
        id extra = listener.extra;
        if (!extra) {
            extra = @"";
        }
        
        id data = notification.data;
        if (!data) {
            data = @"";
        }
        
        if (mClassObj != nil) {
            //该字典创建方式无法使用nil作为参数（会导致crash）
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%d",notification.name,listener.priority] object:mClassObj userInfo:@{
                @"data":data,
                @"extra":extra,
                @"notification":notification
            }];
            flag = YES;
        }
        
        if(notification->_isStopDispatchNotification){//停止消息继续分发
            break;
        }
        
    }
    
    NSMutableArray *dispatchedArray = [NSMutableArray new];
    
    //已经分发的消息需要移除
    for (id item in array) {
        ULNotificationListener *listener = item;
        if (listener.hasDispatched) {
            [dispatchedArray addObject:listener];
        }
    }
    
    for (id item in dispatchedArray) {
        ULNotificationListener *listener = item;
        [array removeObject:listener];
        [[NSNotificationCenter defaultCenter] removeObserver:listener.callClassObj name:notification.name object:listener.callClassObj];
    }
    
    if (array.count ==0) {
        [typeWithClassAndPriorityDic removeObjectForKey:notification.name];
    }
    
    return flag;
}




//移除当前类型中指定消息
- (void)removeNotificationWithName :(NSString *)notificationName withListener:(ULNotificationListener *)listener
{
    NSMutableArray *array = typeWithClassAndPriorityDic[notificationName];
    if (array == nil) {
        return;
    }
    if ([array containsObject:listener]) {
        [array removeObject:listener];
    }
    if (array.count == 0) {
        [typeWithClassAndPriorityDic removeObjectForKey:notificationName];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@%d",notificationName,listener.priority] object:listener.callClassObj];
}

//移除当前类型中所有消息
- (void)removeNotificationWithName :(NSString *)notificationName
{
    NSMutableArray *array = typeWithClassAndPriorityDic[notificationName];
    if (array == nil) {
        return;
    }
    for (id item in array) {
        ULNotificationListener *listener = item;
        [array removeObject:listener];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@%d",notificationName,listener.priority] object:listener.callClassObj];
    }
    if (array.count == 0) {
        [typeWithClassAndPriorityDic removeObjectForKey:notificationName];
    }
    
}



@end
