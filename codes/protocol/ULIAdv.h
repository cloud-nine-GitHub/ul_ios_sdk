//
//  ULIAdv.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/14.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#ifndef ULIAdv_h
#define ULIAdv_h


#endif /* ULIAdv_h */

@protocol ULIAdv <NSObject>


@optional
//这两个函数应该是广告子模块必须实现的
- (void)initModuleAdv;
- (void)onConstructorAdv;

- (void)showSplashAdv:(NSDictionary *)json;
- (void)showInterstitialAdv:(NSDictionary *)json;
- (void)showVideoAdv:(NSDictionary *)json;
- (void)showFullscreenAdv:(NSDictionary *)json;
- (void)showBannerAdv:(NSDictionary *)json;
- (void)showUrlAdv:(NSDictionary *)json;
- (void)showEmbeddedAdv:(NSDictionary *)json;
- (void)showGiftAdv:(NSDictionary *)json;
- (void)showIconAdv:(NSDictionary *)json;
- (void)closeAdv:(NSDictionary *)json;
@end
