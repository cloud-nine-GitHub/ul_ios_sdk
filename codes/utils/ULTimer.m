//
//  ULTimer.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/11.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULTimer.h"

@implementation ULTimer

static NSMutableDictionary *timerMap = nil;

static ULTimer* instance = nil;

+ (instancetype)getInstance{
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
    
}


-(id)init
{
    if (self = [super init]) {
        NSLog(@"%s%@",__func__,@"构造函数!");
        if (!timerMap) {
            timerMap = [NSMutableDictionary new];
        }
    }
    return self;
}




//timer创建时直接执行，每个timer对象对应一个标示
- (void)startTimerWithName:(NSString *)timerLogo withTarget:(id )target withTime:(float )time withSel:(SEL )selector withUserInfo:(id _Nullable)userInfo withRepeat:(BOOL )isRepeat
{
    NSTimer *timer = [timerMap objectForKey:timerLogo];
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:time target:target selector:selector userInfo:userInfo repeats:isRepeat];
        [timerMap setValue:timer forKey:timerLogo];
    }else{
        //销毁原来的timer重新创建
        [timerMap removeObjectForKey:timerLogo];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:time target:target selector:selector userInfo:userInfo repeats:isRepeat];
    }
}

- (NSTimer *)createTimerWithName:(NSString *)timerLogo withTarget:(id )target withTime:(float )time withSel:(SEL )selector withUserInfo:(id _Nullable)userInfo withRepeat:(BOOL )isRepeat
{
    NSTimer *timer = [timerMap objectForKey:timerLogo];
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:time target:target selector:selector userInfo:userInfo repeats:isRepeat];
        [timerMap setValue:timer forKey:timerLogo];
    }else{
        //销毁原来的timer重新创建
        [timerMap removeObjectForKey:timerLogo];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:time target:target selector:selector userInfo:userInfo repeats:isRepeat];
    }
    return timer;
}

//销毁timer
- (void)destroyTimerWithName:(NSString *)timerLogo
{
    NSTimer *timer = [timerMap objectForKey:timerLogo];
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

//判断是否存在超时任务
-(BOOL)hasTimerWithName:(NSString *)timerLogo
{
    NSTimer *timer = [timerMap objectForKey:timerLogo];
    if (timer) {
        return YES;
    }
    return NO;
}

//暂停timer
- (void)stopTimerWithName:(NSString *)timerLogo
{
    NSTimer *timer = [timerMap objectForKey:timerLogo];
    if (timer && [timer isValid]) {
        [timer setFireDate:[NSDate distantFuture]];
    }
}


//重启timer
- (void)restartTimerWithName:(NSString *)timerLogo
{
    NSTimer *timer = [timerMap objectForKey:timerLogo];
    if (timer && [timer isValid]) {
        [timer setFireDate:[NSDate distantPast]];
    }
}

@end
