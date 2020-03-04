//
//  NetworkAdStateDisplayModel.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/18.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkAdStateDisplayModel : NSObject

@property (nonatomic,assign) BOOL isInstalled;
@property (nonatomic,assign) BOOL isConfigForServer;
@property (nonatomic,strong) NSString *networkName;
@property (nonatomic,assign) BOOL isAdReady;


-(instancetype) initWithInstallState:(BOOL)isInstalled
                         configState:(BOOL)configState
                         networkName:(NSString*)networkName
                             adState:(BOOL)adState;

@end
