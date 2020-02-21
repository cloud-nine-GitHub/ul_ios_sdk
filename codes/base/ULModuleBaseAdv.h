//
//  ULModuleBaseAdv.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULModuleBase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 广告类型
 */
typedef NS_ENUM(NSUInteger, AdvType) {
    splash = 1,//开屏
    video,//视频
    banner,//横幅
    interstitial,//插屏
    embedded,//嵌入式
    url,//互动
    icon,
    gift,
    fullscreen, //全屏视频
    unknow
};


/**
 奖励类型
 */
typedef NS_ENUM(NSUInteger, RewardType) {
    show = 1,//展示
    click,//点击
    undefined
};

#define UL_ADV_SPLAH                @"splash"
#define UL_ADV_VIDEO                @"video"
#define UL_ADV_INTERSTITIAL         @"interstitial"
#define UL_ADV_BANNER               @"banner"
#define UL_ADV_URL                  @"url"
#define UL_ADV_EMBEDDED             @"embedded"
#define UL_ADV_ICON                 @"icon"
#define UL_ADV_GIFT                 @"gift"
#define UL_ADV_FULLSCREEN           @"fullscreen"
#define UL_ADV_UNKNOW               @"unknow"

//设置状态初始值
static int SDK_ADV_STATE = 1;

@interface ULModuleBaseAdv : ULModuleBase
{
    
}

- (void)initModuleBaseAdv :(NSDictionary *)advPriorityDic;
- (void)setDisableAdvPriority:(NSString *)disableType,...;
- (NSArray *)getParamArrayWithModule:(NSString *)module withType:(NSString *)type withDefaultValue:(NSArray *)defaultValue;
- (void)showNextAdv:(NSDictionary *)data;

- (void)showFailed:(NSDictionary *)data;

- (void)showClicked:(NSDictionary *)data;

- (void)showAdv:(NSDictionary *)data;

- (void)showClose:(NSDictionary *)data;

- (void)showNativeAdvResultSuccess:(NSDictionary *)nativeData :(NSDictionary *)data;

- (void)showNativeAdvResultFailed:(NSDictionary *)nativeData :(NSDictionary *)data;

- (void)showNativeClickResultFailed:(NSDictionary *)data;

- (void)showNativeClickResultSucess:(NSDictionary *)data;

- (void)showNativeCloseResultSuccess:(NSDictionary *)data;

- (void)showNativeCloseResultFailed:(NSDictionary *)data;

- (void)showCloseResultSuccess:(NSDictionary *)data;

- (void)showCloseResultFailed:(NSDictionary *)data;

- (void)pauseSound;

- (void)resumeSound;
@end

NS_ASSUME_NONNULL_END
