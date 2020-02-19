//
//  ULUserDefaults.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/13.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULUserDefaults.h"
/**
 NSUserDefaults用来存储 用户设置 系统配置等一些小的数据。
 支持的数据类型有NSString、 NSNumber、NSDate、 NSArray、NSDictionary、BOOL、NSInteger、NSFloat等系统定义的数据类型
 其他类型需要先归档(转为NSData)再进行存储
 */
@implementation ULUserDefaults

+ (void)writeDataToUserDefault:(NSMutableDictionary *)targetData
{
    if (!targetData) {
        return;
    }
    //获取对象
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //遍历字典存储数据
    NSArray *keys = [targetData allKeys];
    for (NSString *key in keys) {
        id value = [targetData objectForKey:key];
        [userDefault setObject:value forKey:key];
    }
    //立即写入数据
    [userDefault synchronize];
}


+ (id)readDataFromUserDefault:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id value = [userDefault objectForKey:key];
    return value;
}

+ (void)removeDataFromUserDefault:(NSString *)key
{
    //获取对象
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
}

@end
