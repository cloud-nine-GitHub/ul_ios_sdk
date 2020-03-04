
NS_ASSUME_NONNULL_BEGIN
@class ZZAdNativeMediaView;
@protocol ZZAdNativeAdDelegate;

/**
 Native Ad just supports ZZADImageSize_1200x627,please check
 */
typedef NS_ENUM(NSInteger, ZZADImageSizeType) {

    ZZADImageSize_320x200 = 0, //AdImageSize 320x200
    ZZADImageSize_1200x627 = 1, //AdImageSize 1200x627
};



/**
 The ZZAdNativeAd represents ad metadata to allow you to construct custom ad views.
 See the NativeAdSample in the sample apps section of the Audience Network framework.
 */
@interface ZZAdNativeAd : NSObject

/**
 * Ad title
 */
@property (nonatomic, copy, readonly, nullable) NSString *title;

/**
 *Ad install button
 */
@property (nonatomic, copy, readonly, nullable) NSString *callToAction;

/**
 *Ad description
 */
@property (nonatomic, copy, readonly, nullable) NSString *body;

/**
 load iconImage to  render the icon
 
 @param block  in the block. you can set image or imageUrl for icon
 */
-(void)loadAdIconImageAsyncWithBlock:(void(^)(UIImage*_Nullable,NSURL*_Nullable))block;

/**
 load mediaImage to  render the media
 
 @param block in the block. you can set image or imageUrl for media
 */
-(void)loadAdMediaImageAsyncWithBlock:(void(^)(BOOL,NSURL*_Nonnull))block;


/**
 This is a method to associate a ZZAdNativeAd with the UIView you will use to display the native ads.
 
 @param adMediaView The ZZAdNativeMediaView you created to render the media
 @param viewController The UIViewController that will be used to present viewcontroller
 */
- (void)registerViewForInteraction:(nonnull ZZAdNativeMediaView *)adMediaView
                withViewController:(nonnull UIViewController *)viewController;


/**
 This is a method to associate ZZAdNativeAd with the UIView you will use to display the native ads
 and set clickable areas.
 
 @param adMediaView The ZZAdNativeMediaView you created to render the media
 @param viewController The UIViewController that will be used to present viewcontroller
 @param clickableViews clickableViews An array of UIView you created to render the native ads data element, e.g.
 CallToAction button, Icon image, which you want to specify as clickable.
 */
- (void)registerViewForInteraction:(nonnull ZZAdNativeMediaView *)adMediaView
                withViewController:(nonnull UIViewController *)viewController
                withClickableViews:(nonnull NSArray<UIView *>*)clickableViews;


/**
 This is a method to disconnect a ZZAdNativeAd with the UIView you used to display the native ads.
 */
-(void)unRegisterView;

//*********************************************************************

/**
 The id of the ad placement.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *placementID;

/**
 the delegate
 */
@property (nonatomic, weak, nullable) id<ZZAdNativeAdDelegate> delegate;

/**
 This is a method to initialize a ZZAdNativeAd object matching the given placement id.
 
 - Parameter placementID: The id of the ad placement. 
 */
- (instancetype)initWithPlacementID:(NSString *)placementID  andImageSize:(ZZADImageSizeType) imageSize NS_DESIGNATED_INITIALIZER;


/**
 Begins loading the ZZAdNativeAd content.
 
 You can implement `zzAd_nativeAdDidLoad:` and `zzAd_nativeAd:didFailWithError:` methods
 of `ZZAdNativeAdDelegate` if you would like to be notified as loading succeeds or fails.
 */
- (void)loadAd;

@end

/**
 The methods declared by the ZZAdNativeAdDelegate protocol allow the adopting delegate to respond to messages
 from the ZZAdNativeAd class and thus respond to operations such as whether the native ad has been loaded.
 */
@protocol ZZAdNativeAdDelegate <NSObject>

@optional

/**
 Sent when an ZZAdNativeAd has been successfully loaded.

 @param nativeAd An ZZAdNativeAd object sending the message.
 */
- (void)zzAd_nativeAdDidLoad:(ZZAdNativeAd *)nativeAd;


/**
  Sent immediately before the impression of an ZZAdNativeAd object will be logged.
 
 @param nativeAd An ZZAdNativeAd object sending the message.
 */
- (void)zzAd_nativeAdWillLogImpression:(ZZAdNativeAd *)nativeAd;


/**
 Sent when an FBNativeAd is failed to load.
 
 @param nativeAd An ZZAdNativeAd object sending the message.
 @param error An error object containing details of the error.
 */
- (void)zzAd_nativeAd:(ZZAdNativeAd *)nativeAd didFailWithError:(NSError *)error;

/**
 Sent after an ad has been clicked by the person.
 
 @param nativeAd An ZZAdNativeAd object sending the message.
 */
- (void)zzAd_nativeAdDidClick:(ZZAdNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
