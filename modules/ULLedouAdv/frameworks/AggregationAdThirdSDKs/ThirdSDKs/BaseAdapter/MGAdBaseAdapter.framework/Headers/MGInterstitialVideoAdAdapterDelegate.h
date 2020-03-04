//
//  MGInterstitialVideoAdAdapterDelegate.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/15.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGInterstitialVideoAdAdapterDelegate <NSObject>

@optional

- (void)interstitialVideoAdInitializeSuccess;

- (void)interstitialVideoAdInitializeFailed:(NSError *)error;

- (void)interstitialVideoAdPlayableChanged:(BOOL)isAdPlayable placementID:(NSString *)placementID;

- (void)interstitialVideoAdLoadSuccess:(NSString *)placementID;

- (void)interstitialVideoAdLoadFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)interstitialVideoAdStartShow:(NSString *)placementID;

- (void)interstitialVideoAdShowFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)interstitialVideoAdDidClicked:(NSString *)placementID;

- (void)interstitialVideoAdDidClickSkip:(NSString *)placementID;

- (void)interstitialVideoAdDidClosed:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
