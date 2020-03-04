//
//  DebugViewInvokeProtocol.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/17.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import ".h"
@class MobGiAdsBlockIdsDisplayModel;
@protocol DebugViewSubModuleProtocol;
#import "DebugViewModule.h"
#import "NetworkAdStateDisplayModel.h"

typedef BOOL(^AdStateGetBlock)(NSString*,NSString*);

//子模块实现的协议，是否是单例
@protocol DebugViewSubModuleProtocol <NSObject>

@optional

+(BOOL) isSingleton;
+(id)sharedInstance;

@end

/*
 供具体的广告形式实现类来调用，传送数据，监控回调状态
 
 */

@protocol DebugViewInvokeProtocol <DebugViewSubModuleProtocol>

@optional

-(void) initWithDelegate:(id)delegate;

-(void)showAdForAdName:(NSString*)adName
                    vc:(UIViewController*)vc;

//获取子模块的协议名
-(Protocol*)getSubProtoclName;

-(NSString*)getAdTypeName;

-(NSMutableArray<NetworkAdStateDisplayModel*>*)generateBlockidDetailStateCellDatas:(NSString*)bid;

//以下协议定义需要访问其它模块的方法
-(void)registAdStateReadySelector:(BOOL(^)(NSString*,NSString*))callBack;

-(void)registAdShowBlock:(BOOL(^)(NSString*,NSString*,UIViewController*))adShowBlock;

@required

-(NSMutableArray<MobGiAdsBlockIdsDisplayModel*>*) generateCellDatas;

@end
