//
//  ZZAdInterstitialAd.h
//  ZZAdSDK
//
//  Created by xuhuize on 2017/6/8.
//  Copyright © 2017年 xuhuize. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZZAdInterstitialAdDelegate;

/**
 A modal view controller to represent a interstitial ad. This
 is a full-screen ad shown in your application.
 */
@interface ZZAdInterstitialAd : NSObject
/**
 the delegate
 */
@property (nonatomic, weak, nullable) id<ZZAdInterstitialAdDelegate> delegate;
/**
 Returns true if the interstitial ad has been successfully loaded and has not been showed.
 You should check `isReadyToShow` before trying to show the ad.
 */
@property (nonatomic, getter=isReadyToShow, readonly) BOOL readyToShow;

/**
 ready to show.(Deprecated for 2.4.18+)
 */
@property (nonatomic, assign) BOOL isReady;

/**
 has been showed or not.(Deprecated for 2.4.18+)
 */
@property (nonatomic, assign) BOOL hasBeenUsed;

/**
  This is a method to initialize an ZZAdInterstitialAd matching the given placement id.

 @param placementID id of the ad placement.  
 @return ZZAdInterstitialAd
 */
- (instancetype)initWithPlacementID:(NSString *)placementID;

/**
 Begins loading the ZZAdInterstitialAd content.
 
 You can implement `zzAd_interstitialAdDidLoad:` and `zzAd_interstitialAd:didFailWithError:` methods
 of `ZZAdInterstitialAdDelegate` if you would like to be notified as loading succeeds or fails.
 */
- (void)loadAd;

/**
Presents the interstitial ad modally from the specified view controller.
 
@param rootViewController The view controller that will be used to present the interstitial ad.

You can implement `zzAd_interstitialAdDidClick:`, `interstitialAdWillClose:` and `zzAd_interstitialAdDidClose`
methods of `ZZAdInterstitialAdDelegate` if you would like to stay informed for thoses events
*/
- (void)showAdFromRootViewController:(nullable UIViewController *)rootViewController;

/**
 Manual close the specified view controller from the interstitial.
  you cann call the method in `zzAd_interstitialAdDidClick:`
 */
- (void)closeAd;

@end

/**
 The methods declared by the ZZAdInterstitialAdDelegate protocol allow the adopting delegate to respond
 to messages from the ZZAdInterstitialAd class and thus respond to operations such as whether the
 interstitial ad has been loaded, user has clicked or closed the interstitial.
 */
@protocol ZZAdInterstitialAdDelegate <NSObject>

@optional

/**
 Sent after an ad in the ZZAdInterstitialAd object is clicked. The appropriate app store view or
 app browser will be launched.
 
 @param interstitialAd An ZZAdInterstitialAd object sending the message.
 */
- (void)zzAd_interstitialAdDidClick:(ZZAdInterstitialAd *)interstitialAd;

/**
 Sent after an ZZAdInterstitialAd object has been dismissed from the screen, returning control
 to your application.
 
 @param interstitialAd An ZZAdInterstitialAd object sending the message.
 */
- (void)zzAd_interstitialAdDidClose:(ZZAdInterstitialAd *)interstitialAd;

/**
 Sent immediately before an ZZAdInterstitialAd object will be dismissed from the screen.
 
 @param interstitialAd An ZZAdInterstitialAd object sending the message.
 */
- (void)zzAd_interstitialAdWillClose:(ZZAdInterstitialAd *)interstitialAd;

/**
 Sent when an ZZAdInterstitialAd successfully loads an ad.
 
 @param interstitialAd An ZZAdInterstitialAd object sending the message.
 */
- (void)zzAd_interstitialAdDidLoad:(ZZAdInterstitialAd *)interstitialAd;

/**
 Sent when an ZZAdInterstitialAd failes to load an ad.
 
 @param interstitialAd An ZZAdInterstitialAd object sending the message.
 @param error An error object containing details of the error.
 */
- (void)zzAd_interstitialAd:(ZZAdInterstitialAd *)interstitialAd didFailWithError:(NSError *)error;

/**
 Sent immediately before the impression of an ZZAdInterstitialAd object will be logged.
 
 @param interstitialAd An ZZAdInterstitialAd object sending the message.
 */
- (void)zzAd_interstitialAdWillLogImpression:(ZZAdInterstitialAd *)interstitialAd;

@end

NS_ASSUME_NONNULL_END

