//
//  ZZAdBannerView.h
//  ZZAdSDK
//
//  Created by xuhuize on 2017/6/6.
//  Copyright © 2017年 xuhuize. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// Represents the ad size.
typedef NS_ENUM(NSInteger, ZZAdBannerSizeType){
    
    kZZAdBannerSizeType320x50,//Represents the fixed banner - width is 320pt,height is 50pt.
    kZZAdBannerSizeType300x250,//Represents the fixed rectangle - width is 300pt,height is 250pt.
    kZZAdSizeSmartBanner,//Represents the flexible banner - width is screenWidth, and height is 50pt(iphone) or 90pt(iPad)
};

@protocol ZZAdBannerViewDelegate;

/**
 A customized UIView to represent a ad
 */
@interface ZZAdBannerView : UIView
/**
 The size of the bannerAd;
 */
@property (nonatomic) ZZAdBannerSizeType sizeType;

/**
 Typed access to the id of the ad placement. 
 */
@property (nonatomic,copy) NSString *placementID;
/**
 the delegate
 */
@property (nonatomic, weak, nullable) id<ZZAdBannerViewDelegate> delegate;

@property (nonatomic, assign) BOOL isLoading;

/**
 Begins loading the ZZAdBannerView content.
 
 You can implement `zzAd_bannerViewDidLoad:` and `zzAd_bannerView:didFailWithError:` methods
 of `ZZAdBannerViewDelegate` if you would like to be notified as loading succeeds or fails.
 */
- (void)loadAd;

@end

/**
 The methods declared by the ZZAdBannerViewDelegate protocol allow the adopting delegate to respond
 to messages from the ZZAdBannerView class and thus respond to operations such as whether the ad has
 been loaded, the person has clicked the ad.
 */
@protocol ZZAdBannerViewDelegate <NSObject>

@optional
/**
 Sent after an ad has been clicked by the person.
 
 @param adView An ZZAdBannerView object sending the message.
 */
- (void)zzAd_bannerViewDidClick:(ZZAdBannerView *)adView;

/**
 Sent when an ad has been successfully loaded.
 
 @param adView An ZZAdBannerView object sending the message.
 */
- (void)zzAd_bannerViewDidLoad:(ZZAdBannerView *)adView;

/**
 Sent after an ZZAdBannerView fails to load the ad.
 
 @param adView An ZZAdBannerView object sending the message.
 @param error An error object containing details of the error.
 */
- (void)zzAd_bannerView:(ZZAdBannerView *)adView didFailWithError:(NSError *)error;

/**
 Sent immediately before the impression of an ZZAdBannerView object will be logged.
 
 @param adView An ZZAdBannerView object sending the message.
 */
- (void)zzAd_bannerViewWillLogImpression:(ZZAdBannerView *)adView;

@end

NS_ASSUME_NONNULL_END

