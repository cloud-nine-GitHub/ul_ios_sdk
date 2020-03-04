//
//  AdGlobalConfig.h
//  AdxAdsComponent
//
//  Created by star.liao on 2017/3/30.
//  Copyright © 2017年 com.idreamsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDKCommonModule/JSONModel.h>

@interface AdGlobalConfig : JSONModel

@property(nonatomic,strong) NSString* lifeCycle;
@property(nonatomic,assign) int supportNetworkType;
@property(nonatomic,assign) BOOL isUseTemplate;
@property(nonatomic,assign) int templateShowTime;
@property(nonatomic,strong) NSString* templateUrl;
@property(nonatomic,strong) NSString* icon;
@property(nonatomic,strong) NSString* appName;
@property(nonatomic,strong) NSString* appDesc;
@property(nonatomic,assign) int interval;

-(NSString*) objDescription;

@end
