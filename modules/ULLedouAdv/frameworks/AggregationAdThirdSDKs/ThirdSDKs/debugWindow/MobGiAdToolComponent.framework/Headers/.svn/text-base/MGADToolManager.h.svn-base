//
//  MGADToolManager.h
//  MobGiDebugToolDemo
//
//  Created by ocomme.zhou on 2019/9/12.
//  Copyright © 2019 kuma.zhou. All rights reserved.
//
// 弹出窗口高度
#define MGDebugWindowHeight \
(([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) ?\
(UIScreen.mainScreen.bounds.size.height/2.0) : (UIScreen.mainScreen.bounds.size.height*2/3.0))

///安全设计区域
#define MGSafeAreaInsets ({\
UIEdgeInsets safeInsets = UIEdgeInsetsMake(20, 0, 0, 0);\
if(@available(iOS 11.0, *)){\
safeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;\
}\
safeInsets;\
})

///tool展示区域高度
#define MGADToolContentHeight (MGDebugWindowHeight - MGSafeAreaInsets.top - 44)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGADToolManager : NSObject

@end

/// about debug button
@interface MGADToolManager (debugButton)

+ (void)showDebugButton;

+ (void)hiddenDebugButton;

+ (void)dismissDebugState;

@end

/// about debug button
@interface MGADToolManager (debugData)

- (NSBundle *)currentBundle;

@end


@interface MGADToolManager (customView)

@end

NS_ASSUME_NONNULL_END
