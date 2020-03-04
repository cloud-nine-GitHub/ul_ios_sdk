//
//  AggregationAdsDataLogicManager.h
//  AggregationAdsComponent
//
//  Created by alan.xia on 2017/9/6.
//  Copyright © 2017年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AggregationAdKeySettings.h"
@class AggregationPrioritAdsInfo;
@class AggregationAdvertiserInfo;
@class AdsAggregationAreaInfo;


@interface AggregationAdsDataLogicManager : NSObject

+(AggregationAdsDataLogicManager *)sharedInstance;

-(NSArray*) getPrioritArray:(NSArray*)prioritArray
                     adType:(AggregationAdType)adType;

-(NSArray*) getGeneralArray:(NSArray*)generalArray
                     adType:(AggregationAdType)adType;

-(AggregationPrioritAdsInfo*) getPrioritPlatInfo:(NSArray*) dataArray
                                         blockId:(NSString*) blockId
                                        platType:(NSString*) platInfoName;

-(AggregationAdvertiserInfo*) getGeneralPlatInfo:(NSArray*) dataArray
                                         blockId:(NSString*) blockId
                                        platType:(NSString*) platInfoName;

-(AggregationPrioritAdsInfo*) getPrioritPlatInfo:(NSArray*) dataArray
                                        platType:(NSString*) platInfoName;

-(AggregationAdvertiserInfo*) getGeneralPlatInfo:(NSArray*) dataArray
                                        platType:(NSString*) platInfoName;

- (AggregationPrioritAdsInfo *)getPrioritThirdPlatformInfo:(NSString *)thirdPlatformName
                                                 dataArray:(NSArray *)dataArray;

- (AggregationAdvertiserInfo *)getGeneralThirdPlatformInfo:(NSString *)thirdPlatformName
                                                 dataArray:(NSArray *)dataArray;

-(NSArray*) getPrioritInfo:(NSArray*)dataArray
                   blockId:(NSString*)blockId
                    adType:(AggregationAdType)adType;

-(NSArray*) getAllPrioritInfo:(NSArray*)dataArray
                   blockId:(NSString*)blockId
                    adType:(AggregationAdType)adType;

-(NSArray*) getGeneralInfo:(NSArray*)dataArray
                   blockId:(NSString*)blockId
                    adType:(AggregationAdType)adType;

-(NSArray*) getAllGeneralInfo:(NSArray*)dataArray
                   blockId:(NSString*)blockId
                    adType:(AggregationAdType)adType;

-(BOOL) isHasTheBlockId:(NSArray *)dataArray  blockId:(NSString*) blockId;

-(AdsAggregationAreaInfo*) getBlockConfig:(NSArray *)dataArray  blockId:(NSString*) blockId;

-(BOOL) isHasRate:(NSArray*)dataArray  blockId:(NSString*)blockId;

-(BOOL) getProbabilityRange:(NSArray *)dataArray blockId:(NSString*)blockId;

-(void) savePlatformShowLimit:(NSArray*)dataArray adType:(AggregationAdType)adType;

-(BOOL) isLimitAdWithBlockId:(NSString *)blockid;

-(BOOL) isLimitAdWithPlatformName:(NSString*)platformName
                           adType:(AggregationAdType)adType
                       configType:(AggregationAdConfigType)configType;

-(BOOL) isServerConfiged:(NSString*)blockid
                  adName:(NSString*)adName
           blockidConfig:(NSMutableArray*)dataList;

@end
