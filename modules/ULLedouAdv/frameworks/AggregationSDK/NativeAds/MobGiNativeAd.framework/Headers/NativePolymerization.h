

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdxAdsComponent/AdxAdsDebugger.h>

@class NativeAdData;
@class NativeAdDetailsInfo;
@class NativeAdExtraOptionInfo;

NS_ASSUME_NONNULL_BEGIN


@protocol NativeAdDelegate <NSObject>

@optional

/**
 *  CP可通过该回调，实时收到广告数据准备就绪的通知; CP可通过调用getNativeAd接口拿到广告数据!
 *
 *  @param blockId 广告位ID
 */
- (void)nativeAdLoadSuccess:(NSString *)blockId;

/**
 *  This method is called when an ad load fails.
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Detailed message loading failure.
 */
- (void)nativeAdLoadFailed:(NSString *)blockId
                     error:(NSError *)error;

/**
 *  This method is called when an ad has been presented
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)nativeAdShowSuccess:(NSString *)blockId;

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param error  Description to show the cause of the failure.
 */
- (void)nativeAdShowFailed:(NSString *)blockId
                     error:(NSError *)error;

/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)nativeAdDidClicked:(NSString *)blockId;

/**
 *  This method is called when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)nativeAdDidClosed:(NSString *)blockId;


@end


@protocol NativeAdLogDelegate <NSObject>

@required

- (void)nativeAdSendLog:(NSString *)log level:(NSString *)level;

@end


@interface NativePolymerization : NSObject

+ (NativePolymerization *)sharedInstance;


/**
 *
 * 是否启用默认日志来定位是否调用接口，默认值为YES
 *
 */
@property (nonatomic, assign) BOOL isEnableDefaultLog;

/**
 *  日志开关，方便开发者接入观察原生广告请求过程
 */
@property (nonatomic, assign) BOOL debug;

/**
 *  是否写原生广告SDK调试日志到.txt文件
 */
@property (nonatomic, assign) BOOL writeLogFile;

- (void)setLogDelegate:(nullable id<NativeAdLogDelegate>) delegate;

- (void)setLogLevel:(AdxLogLevel)logLevel;

/*设置一些可选的属性，如logo标志位置*/
- (void)setOptionInfo:(NativeAdExtraOptionInfo*)optionInfo;

#pragma mark

/**
 *  获取SDK版本号
 */
+ (NSString *)getCurrentSDKVersion;

/**
 *  获取SDK当前聚合平台信息
 */
+ (void)validateIntergration;

/**
 *  初始化原生广告聚合SDK，完成相应广告位的原生广告获取; 建议接入方在游戏启动后，尽早调用该方法
 *
 *  @param appkey appkey
 */
- (void)initSDK:(NSString *)appkey
       blockids:(NSArray *)bids;

/**
 *  初始化原生广告聚合SDK，完成相应广告位的原生广告获取; 建议接入方在游戏启动后，尽早调用该方法
 *
 *  @param appkey      appkey
 *  @param delegate    设置代理
 */
- (void)initSDK:(NSString *)appkey
       blockids:(NSArray *)bids
       delegate:(id<NativeAdDelegate> __nullable)delegate;

/**
 *  获取广告位对应的原生广告数据
 *
 *  @param blockid 广告位ID
 *
 *  @return 原生广告数据
 */
- (NativeAdData* __nullable)getNativeAd:(NSString *)blockid;

/**
 *  接入方在拿到原生广告数据后，绘制界面成功后，必须调用该方法，否则广告收益不予结算
 *
 *  @param currentAd 当前显示界面对应的原生广告数据
 *  @param adView    显示界面
 *  @param vc   显示界面所属的视图控制器
 *  @param detailsInfo   应用的信息
 */
- (BOOL)attachAd:(NativeAdData *)currentAd
          toView:(UIView *)adView
              vc:(UIViewController *)vc
     detailsInfo:(NativeAdDetailsInfo *)detailsInfo;

/**
 *  原生广告显示界面不再展示的时候，必须调用该方法
 *  @param currentAd 当前显示界面对应的原生广告数据
 *  @param adView    显示界面
 */
- (BOOL)unAttachAd:(NativeAdData *)currentAd
            toView:(UIView *)adView;

/**
 *  原生广告显示界面发生点击的时候，必须调用该方法，否则广告收益不予结算
 *
 *  @param currentAd 当前显示界面对应的原生广告数据
 */
- (void)clickAd:(NativeAdData *)currentAd;

#pragma mark -
#pragma mark 为方便您了解广告的使用和加载状态，我们提供了原生广告测试调试页面，帮助您在开发过程中更好的了解视频广告的使用情况，可通过如下方法调用
#warning 注意:⚠️ 下面两个方法禁止在上线提审包体的代码里进行接入，否则后果自行承担！

- (void)showTestView:(UIViewController *)vc
        forBlockidId:(NSString *)blockid;

- (void)showTestView:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
