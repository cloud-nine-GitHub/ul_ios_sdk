//
//  ULAdvBean.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/1/20.
//  Copyright © 2020 ul_mac04. All rights reserved.
//



#import "ULAdvBean.h"

@implementation ULAdvBean


-(id)initWithModule:(NSString *)module andType:(NSString *)type andRewardTag:(NSString *)rewardTag andParams:(NSArray *)params andParamProbabilities:(NSArray *)paramsProbabilities
{
    if (self = [super init]) {
        _module = module;
        _type = type;
        _rewardTag = rewardTag;
        _params = params;
        _paramsProbability = paramsProbabilities;
    }
    return self;
}

-(id)initWithModule:(NSString *)module andType:(NSString *)type andRewardTag:(NSString *)rewardTag andParams:(NSArray *)params andParamProbabilities:(NSArray *)paramsProbabilities andPriority:(int)priority
{
    if (self = [super init]) {
        _module = module;
        _type = type;
        _rewardTag = rewardTag;
        _params = params;
        _paramsProbability = paramsProbabilities;
        _priority = priority;
    }
    return self;
}

-(id)initWithModule:(NSString *)module andType:(NSString *)type andRewardTag:(NSString *)rewardTag andParams:(NSArray *)params andParamProbabilities:(NSArray *)paramsProbabilities andPriority:(int)priority andLevel:(int)level
{
    if (self = [super init]) {
        _module = module;
        _type = type;
        _rewardTag = rewardTag;
        _params = params;
        _paramsProbability = paramsProbabilities;
        _priority = priority;
        _level = level;
    }
    return self;
}


@end
