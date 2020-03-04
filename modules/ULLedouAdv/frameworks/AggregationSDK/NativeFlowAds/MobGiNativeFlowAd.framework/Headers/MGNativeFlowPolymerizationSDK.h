//
//  MGNativeFlowPolymerizationSDK.h
//  MobGiNativeFlowAd
//
//  Created by alan.xia on 2018/12/17.
//  Copyright © 2018年 Lingfeng.Xia. All rights reserved.
//

#import <AdxAdsComponent/AdxAdsDebugger.h>

@class MGNativeFlowAdData;
@class MGNativeFlowViewInfo;

@protocol MGNativeFlowAdDelegate <NSObject>

/**
 *  信息流广告加载成功
 *  blockId          广告位
 */
- (void)nativeFlowAdLoadSuccess:(NSString *)blockId;

/**
 *  信息流广告加载失败
 *  blockId          广告位
 *  errorMsg         失败的原因
 */
- (void)nativeFlowAdLoadFail:(NSString *)blockId
                    errorMsg:(NSString *)errorMsg __attribute__((deprecated("Use nativeFlowAdLoadFailed:error: instead.")));

/**
 *  信息流广告加载失败
 *  blockId          广告位
 *  NSError          失败的原因
 */
- (void)nativeFlowAdLoadFailed:(NSString *)blockId
                         error:(NSError *)error;

/**
 *  信息流广告展示
 *  blockId          广告位
 *  nativeFlowData   信息流数据
 */
- (void)nativeFlowAdDidPresent:(NSString *)blockId
                nativeFlowData:(MGNativeFlowAdData *)nativeFlowData;

/**
 *  信息流广告展示失败
 *  blockId          广告位
 *  errorMsg         失败的原因
 */
- (void)nativeFlowAdShowFail:(NSString *)blockId
                    errorMsg:(NSString *)errorMsg __attribute__((deprecated("Use nativeFlowAdShowFailed:error: instead.")));

/**
 *  信息流广告展示失败
 *  blockId          广告位
 *  NSError          失败的原因
 */
- (void)nativeFlowAdShowFailed:(NSString *)blockId
                         error:(NSError *)error;

/**
 *  信息流广告点击
 *  blockId          广告位
 *  nativeFlowData   信息流数据
 */
- (void)nativeFlowAdDidClicked:(NSString *)blockId
                nativeFlowData:(MGNativeFlowAdData *)nativeFlowData;


/**
 *  信息流广告关闭
 *  blockId          广告位
 *  nativeFlowData   信息流数据
 */
- (void)nativeFlowAdDidDismiss:(NSString *)blockId
                nativeFlowData:(MGNativeFlowAdData *)nativeFlowData;

@end


@protocol MGNativeFlowAdLogDelegate <NSObject>

@required

- (void)nativeFlowAdSendLog:(NSString *)log level:(NSString *)level;

@end




@interface MGNativeFlowPolymerizationSDK : NSObject

/**
 *
 * 是否启用默认日志来定位是否调用接口，默认值为YES
 *
 */
@property (nonatomic, assign) BOOL isEnableDefaultLog;

/**
 *  日志开关，方便开发者接入观察Banner广告请求过程
 */
@property (nonatomic, assign) BOOL debug;

/**
 *  是否写Banner广告SDK调试日志到.txt文件
 */
@property (nonatomic, assign) BOOL writeLogFile;


+ (MGNativeFlowPolymerizationSDK *)sharedInstance;

/**
 *  设置原生信息流的代理
 */
- (void)setNativeFlowAdDelegate:(id<MGNativeFlowAdDelegate>) delegate;

/**
 *  设置原生信息流的日志代理,可以用于调试和定位问题
 */
- (void)setLogDelegate:(id<MGNativeFlowAdLogDelegate>) delegate;

/**
 *  设置日志打印等级
 *  注意:只有在debug属性设置为YES的时候，才有效果; debug属性默认为NO
 *
 *  @param logLevel 日志级别
 */
- (void)setLogLevel:(AdxLogLevel)logLevel;

/**
 *  设置抓取时间
 *  注意:只有在规定时间内没有加载到广告，会返回失败，默认30秒
 *
 *  @param fetchTime 时间
 */
- (void)setNativeFlowFecthTime:(int)fetchTime;

/**
 *  设置占位图片
 *  注意:在加载大图的时候使用到的默认占位图片
 *
 *  @param imagePath 图片路径
 */
- (void)setPlaceholderImage:(NSString *)imagePath;

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
- (void)initNativeFlowAd:(NSString *) appKey
                blockIds:(NSArray *) blockIds;

/**
 *  加载
 *  blockId           广告位
 *  viewController    视图控制器（用于显示对应广告位界面信息流的视图控制器）
 *  adNumber          广告素材数量,一次最多不超过10个(建议不超过3个)
 */
- (void)preloadNativeFlowAd:(NSString *)blockId
             viewController:(UIViewController *)viewController
                   adNumber:(int)adNumber;

/**
 *  获取对应广告位的信息流数据
 *
 *  @param blockId 广告位ID
 *
 *  @return 信息流广告数据数组
 */
- (NSArray<MGNativeFlowAdData *> *) getNativeFlowAd:(NSString*)blockId;


/**
 *  展示信息流广告
 *  blockId           广告位
 *  data              对应广告位下需要展示的信息流数据
 *  viewController    当前需要展示界面的视图控制器
 *  adView            用于显示信息流广告的视图，是viewController上的view
 *  viewInfo          一些关联视图的信息
 *  interactionView   用于交互的视图（点击跳转）
 */
- (void)showNativeFlowAd:(NSString *)blockId
                    data:(MGNativeFlowAdData *)data
          viewController:(UIViewController *)viewController
                  adView:(UIView *)adView
                viewInfo:(MGNativeFlowViewInfo *)viewInfo
         interactionView:(UIView *)interactionView;

/**
 *  移除信息流广告（对应广告位下的其中一条数据）
 *  blockId           广告位
 *  data              对应广告位的信息流数据
 *  viewController    当前需要展示界面的视图控制器
 *  adView            当前显示信息流广告的视图
 *  interactionView   用于交互的视图（点击跳转）
 */
- (void)removeNativeFlowAd:(NSString *)blockId
                      data:(MGNativeFlowAdData *)data
            viewController:(UIViewController *)viewController
                    adView:(UIView *)adView
           interactionView:(UIView *)interactionView;

/**
 *  移除信息流广告（对应广告位下的所有数据）
 *  blockId           广告位
 *  viewController    当前需要展示界面的视图控制器
 */
- (void)removeNativeFlowAd:(NSString *)blockId
            viewController:(UIViewController *)viewController;

/**
 *  移除所有信息流广告
 */
- (void)removeAllNativeFlowAd;

@end


