//
//  MGBannerPolymerizationSDK.h
//  MobGiBannerAd
//
//  Created by alan.xia on 2018/9/10.
//  Copyright © 2018年 Lingfeng.Xia. All rights reserved.
//

#import <AdxAdsComponent/AdxAdsDebugger.h>

@protocol MGBannerAdDelegate <NSObject>

@optional

/**
 *  banner广告加载成功
 *  blockId      广告位
 */
- (void)bannerAdLoadSuccess:(NSString *)blockId;

/**
 *  banner广告加载失败
 *  blockId      广告位
 *  error        失败的原因
 */
- (void)bannerAdLoadFailed:(NSString *)blockId
                     error:(NSError *)error;

/**
 *  banner广告展示
 *  blockId      广告位
 */
- (void)bannerAdShowSuccess:(NSString *)blockId;

/**
 *  banner广告显示失败
 *  blockId      广告位
 *  error        失败的原因
 */
- (void)bannerAdShowFailed:(NSString *)blockId
                     error:(NSError *)error;

/**
 *  banner广告自动刷新成功
 *  blockId      广告位
 */
- (void)bannerAdAutoRefreshSuccess:(NSString *)blockId;

/**
 *  banner广告自动刷新失败
 *  blockId      广告位
 *  error        失败的原因
 */
- (void)bannerAdAutoRefreshFailed:(NSString *)blockId
                            error:(NSError *)error;

/**
 *  banner广告点击
 *  blockId      广告位
 */
- (void)bannerAdDidClicked:(NSString *)blockId;

/**
 *  banner广告关闭
 *  blockId      广告位
 */
- (void)bannerAdDidClosed:(NSString *)blockId;

@end

@protocol MGBannerAdLogDelegate <NSObject>

@required

- (void)bannerAdSendLog:(NSString *)log level:(NSString*)level;

@end


@interface MGBannerPolymerizationSDK : NSObject

/**
 *
 * 是否启用默认日志来定位是否调用接口，默认值为YES
 *
 */
@property (nonatomic,assign) BOOL isEnableDefaultLog;

/**
 *  日志开关，方便开发者接入观察Banner广告请求过程
 */
@property (nonatomic, assign) BOOL debug;

/**
 *  是否写Banner广告SDK调试日志到.txt文件
 */
@property(nonatomic,assign) BOOL writeLogFile;

+ (MGBannerPolymerizationSDK *)sharedInstance;

/**
 *  设置banner的代理
 */
- (void)setBannerAdDelegate:(id<MGBannerAdDelegate>)delegate;

/**
 *  设置原banner的日志代理,可以用于调试和定位问题
 */
-(void) setLogDelegate:(nullable id<MGBannerAdLogDelegate>) delegate;

/**
 *  设置日志打印等级
 *  注意:只有在debug属性设置为YES的时候，才有效果; debug属性默认为NO
 *
 *  @param logLevel 日志级别
 */
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
 *  初始化
 *  appKey     应用的标识
 *  blockIds   广告位数组
 */
- (void)initSDK:(NSString *)appKey
       blockIds:(NSArray *)blockIds;

/**
 *  加载广告I
 *  blockId       广告位
 *  vc            视图控制器
 *  view          用于显示banner广告的视图，是vc上的view，banner广告加载在该视图上
 *  rect          banner广告的显示的位置和尺寸
 */
- (void)preloadBannerAd:(NSString *)blockId
                     vc:(UIViewController *)vc
                   view:(UIView *)view
                   rect:(CGRect)rect;

/**
 *  判断广告位对应的banner广告是否准备就绪
 *
 *  @param blockId 广告位
 *
 *  @return BOOL
 */
- (BOOL)getBannerAd:(NSString *)blockId;

/**
 *  展示广告
 *  blockId       广告位
 *  vc            视图控制器
 *  view          用于显示banner广告的视图，是vc上的view，banner广告加载在该视图上
 */
- (void)showBannerAd:(NSString *)blockId
                  vc:(UIViewController *)vc
                view:(UIView *)view;

/**
 *  移除广告
 *  blockId       广告位
 */
- (void)removeBannerAd:(NSString *)blockId;

@end
