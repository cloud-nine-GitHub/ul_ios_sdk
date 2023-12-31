//
//  VideoAdGlobalConfig.h
//  TestVideoAdAggregation
//
//  Created by star.liao on 16/5/20.
//  Copyright © 2016年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AggregationAdGlobalConfig : NSObject

@property(nonatomic,assign) BOOL supportNetwork;
@property(nonatomic,assign) double lifeCycle;

@property(nonatomic,assign) BOOL isUseTemplate;
@property(nonatomic,assign) int templateShowTime;
@property(nonatomic,strong) NSString* templateUrl;

@property(nonatomic,strong) NSString* icon;
@property(nonatomic,strong) NSString* appName;
@property(nonatomic,strong) NSString* appDesc;

@property(nonatomic,assign) int interval;

//适用于开屏
//关闭按钮出现时间(单位毫秒)
@property(nonatomic,assign) int viewDelay;
//悬浮窗关闭按钮,1表示出现，0表示不出现
@property(nonatomic,assign) int isShowView;

-(instancetype) init;

@end
