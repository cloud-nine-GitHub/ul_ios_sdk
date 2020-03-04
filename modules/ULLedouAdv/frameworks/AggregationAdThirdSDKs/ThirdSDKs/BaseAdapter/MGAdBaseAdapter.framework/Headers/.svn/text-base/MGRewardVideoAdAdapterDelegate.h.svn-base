//
//  MGRewardVideoAdAdapterDelegate.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/6/12.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGRewardVideoAdAdapterDelegate <NSObject>

@optional

- (void)rewardVideoAdInitializeSuccess;

- (void)rewardVideoAdInitializeFailed:(NSError *)error;

- (void)rewardVideoAdPlayableChanged:(BOOL)isAdPlayable placementID:(NSString *)placementID;

- (void)rewardVideoAdLoadSuccess:(NSString *)placementID;

- (void)rewardVideoAdLoadFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)rewardVideoAdStartShow:(NSString *)placementID;

- (void)rewardVideoAdShowFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)rewardVideoAdDidClicked:(NSString *)placementID;

- (void)rewardVideoAdIsRewarded:(BOOL)isRewarded placementID:(NSString *)placementID;

- (void)rewardVideoAdDidClosed:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
