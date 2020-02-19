//
//  ULCheckManager.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/13.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

/**
 检测管理类
 */
#import "ULCheckManager.h"

@protocol ULCheckResultProtocol <NSObject>

- (void)checkSuccess:(id)condition;
- (void)checkFailed:(id)condition;

@end


@implementation ULCheckManager

/*
 单条件检测
 **/
+ (BOOL)checkConditionString:(NSString *)condition :(id<ULICheck> )check
{
    return [check checkResult:condition];
}


/*
 单集合多条件检测 and
 **/
+ (BOOL)checkConditionListByAnd:(NSMutableArray *)list :(id<ULICheck> )check
{
    int i = 0;
    for (id conditionItem in list) {
        if ([check checkResult:conditionItem]) {
            i++;
        }
    }
    if (i == list.count) {
        return YES;
    }
    return NO;
}


/*
 单集合多条件检测 or
 **/
+ (BOOL)checkConditionListByOr:(NSMutableArray *)list :(id<ULICheck> )check
{
    for (id conditionItem in list) {
        if ([check checkResult:conditionItem]) {
            return YES;
        }
    }

    return NO;
}

@end
