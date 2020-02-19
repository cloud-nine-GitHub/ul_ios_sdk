//
//  ULAdvBean.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/1/20.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

/**

广告对象实体类

*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULAdvBean : NSObject
{
    NSString *_module;  //广告模块/渠道
    NSString *_type;    //广告类型
    NSString *_rewardTag;   //奖励类型
    NSArray *_params;   //参数数组
    NSArray *_paramsProbability;    //参数概率数组
    int _priority;  //展示优先级,根据配置数组角标决定
    int _level; //显示等级
    
}


@property (nonatomic,strong) NSString *module;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *rewardTag;
@property (nonatomic,strong) NSArray *params;
@property (nonatomic,strong) NSArray *paramsProbability;
@property (nonatomic,assign) int priority;
@property (nonatomic,assign) int level;


-(id)initWithModule:(NSString *)module andType:(NSString *)type andRewardTag:(NSString *)rewardTag andParams:(NSArray *)params andParamProbabilities:(NSArray *)paramsProbabilities;
-(id)initWithModule:(NSString *)module andType:(NSString *)type andRewardTag:(NSString *)rewardTag andParams:(NSArray *)params andParamProbabilities:(NSArray *)paramsProbabilities andPriority:(int)priority;
-(id)initWithModule:(NSString *)module andType:(NSString *)type andRewardTag:(NSString *)rewardTag andParams:(NSArray *)params andParamProbabilities:(NSArray *)paramsProbabilities andPriority:(int)priority andLevel:(int)level;

@end

NS_ASSUME_NONNULL_END
