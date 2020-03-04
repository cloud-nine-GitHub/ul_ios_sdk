//
//  DebugViewModule.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/17.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DebugViewInvokeProtocol.h"



/*
 公共模块，保存了各种广告形式的子模块
 公共逻辑代码
 */
@interface DebugViewModule : NSObject

//@property (nonatomic,strong) ;

+(DebugViewModule *)sharedInstance;

- (id)createService:(Protocol *)proto;

-(void)registService:(Protocol*)proto
           implClass:(Class)classImpl;

-(void)showAllConfigBids:(id<DebugViewSubModuleProtocol>) delegate;

-(void)showDetailTestView:(NSString*)bid
                       vc:(UIViewController*)vc
                 delegate: (id<DebugViewSubModuleProtocol>) delegate;

-(void) navigateDetailTestView:(NSString*)blockid
                      parentVC:(UIViewController*)rootVC;

@end
