//
//  InterstitialPolymerizationSDK.h
//  InterstitialPolymerization
//
//  Created by star.liao on 16/4/6.
//  Copyright © 2016年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdxAdsComponent/AdxAdsDebugger.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InterstitialInitDelegate <NSObject>

@optional

- (void)interstitialAdInitializeSuccess;

@end

@protocol PreloadInterstitialAdDelegate <NSObject>

@optional

/**
 *  This method is called when an ad load success.
 *
 *  @param blockId Detailed message  ad id.
 */
- (void)interstitialAdLoadSuccess:(NSString *)blockId;

/**
 *  This method is called when an ad load fails.
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Detailed message loading failure.
 */
- (void)interstitialAdLoadFailed:(NSString *)blockId
                           error:(NSError *)error;

@end

@protocol ShowCachedInterstitialAdDelegate <NSObject>

@optional

/**
 *  This method is called when an ad has been presented
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)interstitialAdStartShow:(NSString *)blockId;

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param  blockId   Detailed message  ad id.
 *  @param  error  Description to show the cause of the failure.
 */
- (void)interstitialAdShowFailed:(NSString *)blockId
                           error:(NSError *)error;

/**
 *  This method is invoked when an ad has been clicked.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)interstitialAdDidClicked:(NSString *)blockId;

/**
 *  This method is called when an ad has been dismissed.
 *
 *  @param  blockId   Detailed message  ad id.
 */
- (void)interstitialAdDidClosed:(NSString *)blockId;

@end

@protocol InterstitialLogDelegate <NSObject>

@required

- (void)sendLog:(NSString *)log level:(NSString *)level;

@end


@interface InterstitialPolymerizationSDK : NSObject

/**
 *  是否可打印SDK日志
 */
@property (nonatomic, assign) BOOL debug;

/**
 *  是否可写入SDK日志文件
 */
@property (nonatomic, assign) BOOL writeLogFile;

/**
 *
 * 是否启用默认日志来定位是否调用接口，默认值为YES
 *
 */
@property (nonatomic, assign) BOOL isEnableDefaultLog;


+ (InterstitialPolymerizationSDK *)sharedInstance;

+ (NSString *)getCurrentSDKVersion;

+ (void)validateIntergration;

/**
 *  初始化插页SDK
 *
 *  @param appkey 应用标识
 */
- (void)initSDK:(NSString *)appkey;

/**
 *  初始化插页SDK
 *
 *  @param appkey   应用标识
 *  @param delegate delegate, 建议CP在该代理回调执行完后，再去调用preloadInterstitialAd和showCachedInterstitialAd接口
 */
- (void)initSDK:(NSString *)appkey
       delegate:(nullable id<InterstitialInitDelegate>)delegate;

/**
 *  设置日志打印等级
 *  注意:只有在debug属性设置为YES的时候，才有效果; debug属性默认为NO
 *
 *  @param logLevel 日志等级
 */
- (void)setLogLevel:(AdxLogLevel)logLevel;

/**
 *  设置日志回调
 *
 *  @param delegate 代理对象
 */
- (void)setLogDelegate:(nullable id<InterstitialLogDelegate>) delegate;


/**
 *  判断广告位对应的插页广告是否准备就绪
 *
 *  @param blockid 广告位
 *
 *  @return BOOL
 */
- (BOOL)getCacheReady:(NSString*)blockid;


#pragma  mark - load fuction

/**
 *  预加载插页广告
 *
 *  @param blockId 广告位
 */
- (void)preloadInterstitialAd:(NSString *)blockId;

/**
 *  预加载插页广告
 *
 *  @param blockId  广告位
 *  @param delegate 代理对象
 */
- (void)preloadInterstitialAd:(NSString *)blockId
                    delegate:(nullable id<PreloadInterstitialAdDelegate>)delegate;

/**
 *  预加载插页广告
 *
 *  @param blockId  广告位
 *  @param vc       视图控制器
 */
- (void)preloadInterstitialAd:(NSString *)blockId
                           vc:(UIViewController *)vc;

/**
 *  预加载插页广告
 *
 *  @param blockId  广告位
 *  @param vc       视图控制器
 *  @param delegate 代理对象
 */
-(void)preloadInterstitialAd:(NSString *)blockId
                          vc:(UIViewController *)vc
                    delegate:(nullable id<PreloadInterstitialAdDelegate>)delegate;


#pragma  mark - show fuction

/**
 *  如果有缓存，则展示插页广告； 没有缓存则去预加载广告； 关闭插页广告后，会自动去加载下一条广告。
 *  该方法内部已经封装调用getCacheReady方法判断广告状态，接入方可以直接调用该方法显示插页广告，广告关闭后会自动加载下一条插页广告，接入方不需要再调用preloadInterstitialAd:delegate:方法
 *
 *  @param blockId 广告位
 */
- (void)showCachedInterstitialAd:(NSString *)blockId;

/**
 *  如果有缓存，则展示插页广告； 没有缓存则去预加载广告； 关闭插页广告后，会自动去加载下一条广告。
 *  该方法内部已经封装调用getCacheReady方法判断广告状态，接入方可以直接调用该方法显示插页广告，广告关闭后会自动加载下一条插页广告，接入方不需要再调用preloadInterstitialAd:delegate:方法
 *
 *  @param blockId  广告位
 *  @param delegate delegate
 */
- (void) showCachedInterstitialAd:(NSString *)blockId
                         delegate:(nullable id<ShowCachedInterstitialAdDelegate>)delegate;

/**
 *  展示插页广告
 *
 *  @param blockId  广告位
 *  @param vc       视图控制器
 */
- (void)showCachedInterstitialAd:(NSString *)blockId
                              vc:(UIViewController *)vc;

/**
 *  展示广告
 *
 *  @param blockId  广告位
 *  @param vc       视图控制器
 *  @param delegate delegate
 */
- (void) showCachedInterstitialAd:(NSString *)blockId
                               vc:(UIViewController *)vc
                         delegate:(nullable id<ShowCachedInterstitialAdDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
