//
//  ULNativeSplashAdvLayout.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/27.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ZLDrawCircleProgressBtn.h"
NS_ASSUME_NONNULL_BEGIN
// 倒计时时间
static int const UL_NATIVE_SPLASH_ADV_SHOW_TIME = 5;
// 应用内容描述
static NSString *const UL_NATIVE_SPLASH_ADV_DEFAULT_APP_DESC = @"身边小伙伴都在玩";

@interface ULNativeSplashAdvLayout : NSObject


@property (nonatomic,strong)UIView *parentView;//总布局view
//@property (nonatomic,strong)UIView *adAreaParentView;//显示广告区域的view
//@property (nonatomic,strong)UIView *appAreaParentView;//显示应用信息区域的view
// 跳过按钮
@property (nonatomic, strong) ZLDrawCircleProgressBtn *drawCircleBtn;

@property (nonatomic, strong) UIImageView *imageUI;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;


- (id)initWithOrientation:(BOOL )isPortrait withViewController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
