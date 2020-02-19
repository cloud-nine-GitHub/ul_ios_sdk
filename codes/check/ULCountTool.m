//
//  ULCountTool.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/13.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULCountTool.h"
#import "ULUserDefaults.h"
#import "ULTools.h"
/**
 计数工具类
 */

@interface ULCountTool ()

@property(strong,nonatomic) NSMutableDictionary *countMaxMap;
@property(strong,nonatomic) NSMutableDictionary *countMap;
@property(strong,nonatomic) NSMutableDictionary *countTimeMap;

@end


@implementation ULCountTool

static ULCountTool *instance = nil;

+ (instancetype)getInstance{
    if(!instance){
        instance = [[self alloc] init];
        
    }
    return instance;
}


-(id)init
{
    if (self = [super init]) {
        _countMap = [NSMutableDictionary new];
        _countMaxMap = [NSMutableDictionary new];
        _countTimeMap = [NSMutableDictionary new];
    }
    return self;
}


- (void)setMax:(NSString *)key :(int )max
{
    [self postStoreAndCacheValueInt:_countMaxMap :key :max];
}


- (void)post:(NSString *)key :(int)count
{
    int max = [self getStoreOrCacheValueInt:_countMaxMap :key];
    if (max == 0) {
        //未设置上限，不做存档
        return;
    }
    int val = [self getStoreOrCacheValueIntEveryDay:key];
    int p = val + count;
    [self postStoreAndCacheValueInt:_countMap :key :p];
}


- (BOOL)checkOverload:(NSString *)key
{
    int p = [self getStoreOrCacheValueIntEveryDay:key];
    int max = [self getStoreOrCacheValueInt:_countMaxMap :key];
    if (max <= 0) {
        //未设置上限，默认没有超过
        return NO;
    }
    return p >= max;
}


- (int)getStoreOrCacheValueIntEveryDay:(NSString *)key
{
    int val = [self getStoreOrCacheValueInt:_countMap :key];
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *nowDate = [NSDate date];
    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
    int now = [nowDateString intValue];
    int cacheData = [self getStoreOrCacheValueInt:_countTimeMap :key];
    if (now != cacheData) {//不是用一天，清零
        val = 0;
        [self postStoreAndCacheValueInt:_countMap :key :val];
        [self postStoreAndCacheValueInt:_countTimeMap :key :now];
    }
    return val;
}


- (int)getStoreOrCacheValueInt:(NSMutableDictionary *)map :(NSString *)key
{
    int value = 0;
    id i = [map objectForKey:key];
    if (i) {
        value = [i intValue];
    }else{
        value = [[self getStoreValue:key] intValue];
        [map setValue:[NSNumber numberWithInt:value] forKey:key];
    }
    return value;
}


- (void)postStoreAndCacheValueInt:(NSMutableDictionary *)map :(NSString *)key :(int )value
{
    [map setValue:[NSNumber numberWithInt:value] forKey:key];
    [self postStoreValue:key :[NSString stringWithFormat:@"%d",value]];
}


- (void)postStoreValue:(NSString *)key :(NSString *)value
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:value forKey:key];
    [ULUserDefaults writeDataToUserDefault:data];
}


- (NSString *)getStoreValue:(NSString *)key
{
    id value = [ULUserDefaults readDataFromUserDefault:key];
    if (!value) {
        return @"0";
    }
    return (NSString *)value;
}

@end
