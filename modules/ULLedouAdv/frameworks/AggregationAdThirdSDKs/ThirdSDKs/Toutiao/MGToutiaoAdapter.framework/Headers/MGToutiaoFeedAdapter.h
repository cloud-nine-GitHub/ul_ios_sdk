//
//  MGToutiaoFeedAdapter.h
//  MGToutiaoAdapter
//
//  Created by alan.xia on 2018/12/26.
//  Copyright © 2018年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BUAdSDK/BUAdSDK.h>



@class MGToutiaoFeedAdapter;

@protocol MGToutiaoFeedAdapterDelegate<NSObject>

- (void)feedAdLoadSuccess:(MGToutiaoFeedAdapter *)adapter nativeAds:(NSArray<BUNativeAd *> *)nativeAds;

- (void)feedAdLoadFail:(MGToutiaoFeedAdapter *)adapter errorMsg:(NSError *)error;

- (void)feedAdDidPresent:(BUNativeAd *)nativeAd;

- (void)feedAdDidClicked:(BUNativeAd *)nativeAd;

- (void)feedAdDidDismiss:(BUNativeAd *)nativeAd;

@end


@interface MGToutiaoFeedAdapter : NSObject

@property (nonatomic, strong) NSString *slotID;

@property (nonatomic, strong) BUNativeAdsManager *nativeAdsManager;

@property (nonatomic, weak) id<MGToutiaoFeedAdapterDelegate> delegate;

- (void)createNativeAdsManager:(NSString *)slotID;

- (void)loadAdWithCount:(NSNumber *)adCount;

- (void)setCloseButtonFrame:(CGRect)rect;

- (void)setAdLabelFrame:(CGRect)rect;

- (void)setLogoImageFrame:(CGRect)rect;

- (void)setVideoViewFrame:(CGRect)rect;

- (void)setPlaceholderImage:(NSString *)imagePath;

- (void)showNativeAd:(UIViewController *)viewController adView:(UIView *)adView nativeAd:(BUNativeAd *)nativeAd;

- (void)registerContainer:(UIView *)containerView nativeAd:(BUNativeAd *)nativeAd;

- (void)unregisterView:(BUNativeAd *)nativeAd;

- (void)removeNativeData:(BUNativeAd *)nativeAd;

- (void)removeAllNativeData;

- (void)removeNativeAdsManager;

@end


