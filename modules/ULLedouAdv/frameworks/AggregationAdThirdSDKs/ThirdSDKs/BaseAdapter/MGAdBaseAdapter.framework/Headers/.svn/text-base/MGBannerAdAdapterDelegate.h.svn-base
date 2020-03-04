//
//  MGBannerAdAdapterDelegate.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/6/12.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGBannerAdAdapterDelegate <NSObject>

- (void)bannerAdLoadSuccess:(NSString *)placementID view:(UIView *)view;

- (void)bannerAdLoadFailed:(NSString *)placementID view:(UIView *)view error:(NSError *)error;

- (void)bannerAdStartShow:(NSString *)placementID view:(UIView *)view;

- (void)bannerAdShowFailed:(NSString *)placementID view:(UIView *)view error:(NSError *)error;

- (void)bannerAdDidClicked:(NSString *)placementID view:(UIView *)view;

- (void)bannerAdDidClosed:(NSString *)placementID view:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
