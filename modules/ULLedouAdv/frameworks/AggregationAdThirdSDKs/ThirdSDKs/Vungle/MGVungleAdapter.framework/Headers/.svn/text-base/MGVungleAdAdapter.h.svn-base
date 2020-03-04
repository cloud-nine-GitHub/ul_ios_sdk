//
//  MGVungleAdAdapter.h
//  TestAdAggregation
//
//  Created by alan.xia on 2017/7/11.
//  Copyright © 2017年 com.idreamsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MGAdBaseAdapter/MGRewardVideoAdAdapterDelegate.h>
#import <MGAdBaseAdapter/MGInterstitialVideoAdAdapterDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGVungleAdAdapter : NSObject

@property (nonatomic, weak) id<MGRewardVideoAdAdapterDelegate>     rewardVideoDelegate;

@property (nonatomic, weak) id<MGInterstitialVideoAdAdapterDelegate>     interstitialVideoDelegate;

@property (nonatomic, strong) NSMutableDictionary  *videoPlacementIdDict;

@property (nonatomic, strong) NSMutableDictionary  *interstitialPlacementIdDict;


+ (instancetype)shareInstance;


- (void)startWithPlacementID:(NSString *)placementID;


- (void)loadAdWithPlacementID:(NSString *)placementID;


- (NSNumber *)getInitializeStatus;

- (NSNumber *)getCacheStatusWithPlacementID:(NSString *)placementID;


- (void)showAd:(UIViewController *)vc placementID:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
