
#import <UIKit/UIKit.h>
#import <AdxAdsComponent/AdxAdsDebugger.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VideoAdLogDelegate <NSObject>

@required

- (void)videoAdSendLog:(NSString *)log level:(NSString*)level;

@end


@protocol VideoAdDelegate <NSObject>

@required

/**
 *  When the video ad is closed, it triggers a reward callback.
 *
 *  @param isShouldReward  YES means you can give rewards, and NO means you can't
 *  @param blockId         Detailed message  ad id.
 */
- (void)triggerReward:(BOOL)isShouldReward
           forBlockid:(NSString *)blockId;

@optional

/**
 *  This method is invoked when an ad load sucess.
 */
- (void)videoAdLoadSuccess;

/**
 *  This method is invoked when an ad load fails.
 *
 *  @param  errorMessage  Detailed message loading failure.
 */
- (void)videoAdFailedToLoadWithError:(NSString*)errorMessage __attribute__((deprecated("Use videoAdLoadFailed: instead.")));

/**
 *  This method is invoked when an ad load fails.
 *
 *  @param  error  Detailed message loading failure.
 */
- (void)videoAdLoadFailed:(NSError *)error;

/**
 *  This method is invoked when an ad has been presented.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)videoAdStartShow:(NSString *)blockId;

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param errorMessage  Description to show the cause of the failure.
 */
- (void)videoAdShowFailed:(NSString *)blockId
             errorMessage:(NSString *)errorMessage __attribute__((deprecated("Use videoAdShowFailed:error: instead.")));

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param error  Description to show the cause of the failure.
 */
- (void)videoAdShowFailed:(NSString *)blockId
                    error:(NSError *)error;

/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)videoAdDidClicked:(NSString *)blockId;

/**
 *  This method is invoked when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)videoAdDidClosed:(NSString *)blockId;

@end


@interface VideoPolymerizationSDK : NSObject

/**
 *
 * 是否启用默认日志来定位是否调用接口，默认值为YES
 *
 */
@property (nonatomic, assign) BOOL isEnableDefaultLog;

/**
 *  日志开关，方便开发者接入观察视频广告请求过程
 */
@property (nonatomic, assign) BOOL debug;

/**
 *  是否写聚合SDK调试日志到.txt文件
 */
@property (nonatomic, assign) BOOL writeLogFile;


+ (VideoPolymerizationSDK *)sharedInstance;




- (void)setLogDelegate:(nullable id<VideoAdLogDelegate>) delegate;


- (void)setLogLevel:(AdxLogLevel)logLevel;

/**
 *  获取SDK版本号
 */
+ (NSString *)getCurrentSDKVersion;

/**
 *  获取SDK当前聚合平台信息
 */
+ (void)validateIntergration;

/**
 *  初始化接口，开发者接入只需调用一次
 *
 *  @param appkey     appkey,在广告后台申请，联系han.song
 *  @param vc         vc,游戏开发者可传入[UIApplication sharedApplication].keyWindow.rootViewController
 *  @param blockArray 广告位ID数组，例如@[@"blockid1",@"blockid2"],在广告后台申请，联系han.song
 *  @param delegate   delegate
 */
- (void)initSDK:(NSString *)appkey
             vc:(UIViewController *)vc
       blockIds:(NSArray *)blockArray
       delegate:(id<VideoAdDelegate>)delegate;


/**
 *  判断视频是否准备就绪接口，可以反复调用
 *
 *  在展示广告之前调用此方法，获取到返回值，如果返回YES则对应广告位就绪，可以展示视频，如果返回NO则对应广告位没有加载好，不能展示视频，
 *
 *  @param blockid    传入广告位
 */
- (BOOL)isAdPlayable:(NSString *)blockid;

/**
 *  游戏开发者进行调用展示视频广告，监控adReady:forBlockid:回调方法的值为YES，才建议调用
 *  如果对应的广告商广告没有准备就绪，调用无法展示广告，监控callBack参数回调，游戏进行相应提示处理
 *
 *  @param vc       vc,游戏开发者可传入[UIApplication sharedApplication].keyWindow.rootViewController
 *  @param blockId  要展示视频广告的广告位ID
 *  @param callBack 无法展示视频广告，发生异常，监控callBack参数回调，游戏进行相应提示处理,该block在异步线程上执行
 */
- (void)showViewAd:(UIViewController *)vc
        forBlockId:(NSString *)blockId
          callBack:(void(^)(void))callBack;

#pragma mark -
#pragma mark 为方便您了解广告的使用和加载状态，我们提供了视频广告测试调试页面，帮助您在开发过程中更好的了解视频广告的使用情况，可通过如下方法调用
#warning 注意:⚠️ 下面两个方法禁止在上线提审包体的代码里进行接入，否则后果自行承担！

- (void)showTestView:(UIViewController *)vc
        forBlockidId:(NSString *)blockid;

- (void)showTestView:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
