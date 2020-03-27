//
//  ULNativeSplashAdvLayout.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/27.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULNativeSplashAdvLayout.h"
#import "ULTools.h"

@implementation ULNativeSplashAdvLayout

- (id)initWithOrientation:(BOOL )isPortrait withViewController:(UIViewController *)controller
{
    if (self = [super init]) {
        if (isPortrait) {
            [self showNativeSplashViewPortrait:controller];
        }else{
            [self showNativeSplashViewLandscape:controller];
        }
    }
    return self;
}



- (void)showNativeSplashViewPortrait:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    
    CGFloat parentWidth = controller.view.bounds.size.width;
    CGFloat parentHeight = controller.view.bounds.size.height;
    _parentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, parentWidth, parentHeight)];
    _parentView.backgroundColor = UIColor.whiteColor;
    [controller.view addSubview:_parentView];
    
    /*广告素材显示区域*/
    CGFloat adAreaParentWidth = parentWidth;
    CGFloat adAreaParentHeight = parentHeight * 4 / 5;
    UIImageView *adAreaParentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, adAreaParentWidth, adAreaParentHeight)];
    adAreaParentView.image = [UIImage imageNamed:@"ul_native_splash_bg_image.jpg"];
    [_parentView addSubview:adAreaParentView];
    
    
    //添加广告说明字样
    UIImageView *adMark = [[UIImageView alloc]initWithFrame:CGRectMake(10, adAreaParentHeight - 24, 26, 14)];
    adMark.image = [UIImage imageNamed:@"ul_native_advlogo_image.png"];
    [adAreaParentView addSubview:adMark];
    
    //跳过按钮
    ZLDrawCircleProgressBtn *drawCircleBtn = [[ZLDrawCircleProgressBtn alloc]initWithFrame:CGRectMake(adAreaParentWidth - 40, 10, 30, 30)];
    drawCircleBtn.lineWidth = 2;
    [drawCircleBtn setTitle:@"跳过" forState:UIControlStateNormal];
    //    [drawCircleBtn setTitleColor:[UIColor  colorWithRed:197/255.0 green:159/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    [drawCircleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    drawCircleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _drawCircleBtn = drawCircleBtn;
    [adAreaParentView addSubview:_drawCircleBtn];
    
    
    //原生广告素材显示区域
    CGFloat nativeBoxWidth = adAreaParentWidth-40;
    CGFloat nativeBoxHeight = adAreaParentHeight-80;
    UIImageView *nativeBoxView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, nativeBoxWidth, nativeBoxHeight)];
    nativeBoxView.center = adAreaParentView.center;
//    nativeBoxView.backgroundColor = UIColor.greenColor;
    nativeBoxView.contentMode = UIViewContentModeScaleAspectFit;//图片以原有的高宽比以适应图片视图
    nativeBoxView.image = [UIImage imageNamed:@"ul_native_splash_bg_box.png"];
    [adAreaParentView addSubview:nativeBoxView];
    
    //原生素材图片view
    CGFloat logoViewX = (nativeBoxWidth - 100)/2;
    CGFloat logoViewY = (nativeBoxHeight - 100)/2;
    _imageUI = [[UIImageView alloc] initWithFrame:CGRectMake(logoViewX, logoViewY, 100, 100)];
    //    _imageUI.backgroundColor = UIColor.orangeColor;
    _imageUI.contentMode = UIViewContentModeScaleAspectFit;//图片以原有的高宽比以适应图片视图
    [nativeBoxView addSubview:_imageUI];
    
    //原生素材标题view
    CGFloat titileX = (nativeBoxWidth - 100)/2;
    CGFloat titileY = logoViewY + 105;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titileX, titileY, 100, 30)];
    //    _titleLabel.backgroundColor = UIColor.orangeColor;
    _titleLabel.text = @"标题";
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [nativeBoxView addSubview:_titleLabel];
    
    
    //原生素材描述view
    CGFloat descX = (nativeBoxWidth - 150)/2;
    CGFloat descY = titileY + 35;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(descX, descY, 150, 25)];
    //    _descLabel.backgroundColor = UIColor.orangeColor;
    _descLabel.text = @"广告内容描述";
    _descLabel.textColor = UIColor.whiteColor;
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = [UIFont systemFontOfSize:14];
    [nativeBoxView addSubview:_descLabel];
    
    
    
    /*应用信息显示区域*/
    CGFloat appAreaParentWidth = parentWidth;
    CGFloat appAreaParentHeight = parentHeight * 1 / 5;
    UIView *appAreaParentView = [[UIView alloc]initWithFrame:CGRectMake(0, parentHeight-appAreaParentHeight, appAreaParentWidth, appAreaParentHeight)];
    [_parentView addSubview:appAreaParentView];
    
    //应用icon
    CGFloat appIconX = (appAreaParentWidth - 220)/2;
    CGFloat appIconY = (appAreaParentHeight - 60)/2;
    UIImageView *appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(appIconX, appIconY, 60, 60)];
    //    appIcon.backgroundColor = UIColor.greenColor;
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    appIcon.image = [UIImage imageNamed:iconLastName];
    appIcon.contentMode = UIViewContentModeScaleAspectFit;//图片以原有的高宽比以适应图片视图
    [appAreaParentView addSubview:appIcon];
    
    //应用名称
    CGFloat appNameX = appIconX + 70;
    CGFloat appNameY = (appAreaParentHeight - 50)/2;
    UILabel *appName = [[UILabel alloc] init];
    //    appName.backgroundColor = UIColor.blueColor;
    //根据文本内容自适应大小
    appName.font = [UIFont systemFontOfSize:20];
    appName.text = [ULTools getCurrentAppName];
    appName.textColor = UIColor.blackColor;
    appName.textAlignment = NSTextAlignmentCenter;
    appName.frame = CGRectMake(appNameX, appNameY, 150, 30);
    [appAreaParentView addSubview:appName];
    
    //应用描述
    CGFloat appDescX = appNameX + 25;
    CGFloat appDescY = appNameY + 30;
    UILabel *appDesc = [[UILabel alloc] init];
    //    appDesc.backgroundColor = UIColor.yellowColor;
    //根据文本内容自适应大小
    appDesc.font = [UIFont systemFontOfSize:12];
    appDesc.text = UL_NATIVE_SPLASH_ADV_DEFAULT_APP_DESC;
    appDesc.textColor = UIColor.grayColor;
    appDesc.textAlignment = NSTextAlignmentCenter;
    appDesc.frame = CGRectMake(appDescX, appDescY, 100, 20);
    [appAreaParentView addSubview:appDesc];
    
}

- (void)showNativeSplashViewLandscape:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    
    CGFloat parentWidth = controller.view.bounds.size.width;
    CGFloat parentHeight = controller.view.bounds.size.height;
    _parentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, parentWidth, parentHeight)];
    _parentView.backgroundColor = UIColor.whiteColor;
    [controller.view addSubview:_parentView];
    
    /*广告素材显示区域*/
    CGFloat adAreaParentWidth = parentWidth;
    CGFloat adAreaParentHeight = parentHeight * 10 / 13;
    UIImageView *adAreaParentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, adAreaParentWidth, adAreaParentHeight)];
    adAreaParentView.image = [UIImage imageNamed:@"ul_native_splash_bg_image.jpg"];
    [_parentView addSubview:adAreaParentView];
    
    
    //添加广告说明字样
    UIImageView *adMark = [[UIImageView alloc]initWithFrame:CGRectMake(10, adAreaParentHeight - 24, 26, 14)];
    adMark.image = [UIImage imageNamed:@"ul_native_advlogo_image.png"];
    [adAreaParentView addSubview:adMark];
    
    //跳过按钮
    ZLDrawCircleProgressBtn *drawCircleBtn = [[ZLDrawCircleProgressBtn alloc]initWithFrame:CGRectMake(adAreaParentWidth - 40, 10, 30, 30)];
    drawCircleBtn.lineWidth = 2;
    [drawCircleBtn setTitle:@"跳过" forState:UIControlStateNormal];
    //    [drawCircleBtn setTitleColor:[UIColor  colorWithRed:197/255.0 green:159/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    [drawCircleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    drawCircleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _drawCircleBtn = drawCircleBtn;
    [adAreaParentView addSubview:_drawCircleBtn];
    
    
    //原生广告素材显示区域
    CGFloat nativeBoxWidth = adAreaParentWidth-120;
    CGFloat nativeBoxHeight = adAreaParentHeight;
    UIImageView *nativeBoxView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, nativeBoxWidth, nativeBoxHeight)];
    nativeBoxView.center = adAreaParentView.center;
//    nativeBoxView.backgroundColor = UIColor.greenColor;
    nativeBoxView.contentMode = UIViewContentModeScaleAspectFit;//图片以原有的高宽比以适应图片视图
    nativeBoxView.image = [UIImage imageNamed:@"ul_native_splash_bg_box.png"];
    [adAreaParentView addSubview:nativeBoxView];
    
    //原生素材图片view
    CGFloat logoViewX = (nativeBoxWidth - 100)/2 + 36;
    CGFloat logoViewY = (nativeBoxHeight - 100)/2 - 40;
    _imageUI = [[UIImageView alloc] initWithFrame:CGRectMake(logoViewX, logoViewY, 100, 100)];
//        _imageUI.backgroundColor = UIColor.orangeColor;
    _imageUI.contentMode = UIViewContentModeScaleAspectFit;//图片以原有的高宽比以适应图片视图
    [nativeBoxView addSubview:_imageUI];
    
    //原生素材标题view
    CGFloat titileX = (nativeBoxWidth - 100)/2 + 36;
    CGFloat titileY = logoViewY + 105;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titileX, titileY, 100, 30)];
//    _titleLabel.backgroundColor = UIColor.orangeColor;
    _titleLabel.text = @"标题";
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [nativeBoxView addSubview:_titleLabel];
    
    
    //原生素材描述view
    CGFloat descX = (nativeBoxWidth - 150)/2 + 36;
    CGFloat descY = titileY + 35;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(descX, descY, 150, 25)];
//        _descLabel.backgroundColor = UIColor.orangeColor;
    _descLabel.text = @"广告内容描述";
    _descLabel.textColor = UIColor.whiteColor;
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = [UIFont systemFontOfSize:14];
    [nativeBoxView addSubview:_descLabel];
    
    
    
    /*应用信息显示区域*/
    CGFloat appAreaParentWidth = parentWidth;
    CGFloat appAreaParentHeight = parentHeight * 3 / 13;
    UIView *appAreaParentView = [[UIView alloc]initWithFrame:CGRectMake(0, parentHeight-appAreaParentHeight, appAreaParentWidth, appAreaParentHeight)];
    [_parentView addSubview:appAreaParentView];
    
    //应用icon
    CGFloat appIconX = (appAreaParentWidth - 220)/2;
    CGFloat appIconY = (appAreaParentHeight - 60)/2;
    UIImageView *appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(appIconX, appIconY, 60, 60)];
//        appIcon.backgroundColor = UIColor.greenColor;
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    appIcon.image = [UIImage imageNamed:iconLastName];
    appIcon.contentMode = UIViewContentModeScaleAspectFit;//图片以原有的高宽比以适应图片视图
    [appAreaParentView addSubview:appIcon];
    
    //应用名称
    CGFloat appNameX = appIconX + 70;
    CGFloat appNameY = (appAreaParentHeight - 50)/2;
    UILabel *appName = [[UILabel alloc] init];
//        appName.backgroundColor = UIColor.blueColor;
    //根据文本内容自适应大小
    appName.font = [UIFont systemFontOfSize:20];
    appName.text = [ULTools getCurrentAppName];
    appName.textColor = UIColor.blackColor;
    appName.textAlignment = NSTextAlignmentCenter;
    appName.frame = CGRectMake(appNameX, appNameY, 150, 30);
    [appAreaParentView addSubview:appName];
    
    //应用描述
    CGFloat appDescX = appNameX + 25;
    CGFloat appDescY = appNameY + 30;
    UILabel *appDesc = [[UILabel alloc] init];
//        appDesc.backgroundColor = UIColor.yellowColor;
    //根据文本内容自适应大小
    appDesc.font = [UIFont systemFontOfSize:12];
    appDesc.text = UL_NATIVE_SPLASH_ADV_DEFAULT_APP_DESC;
    appDesc.textColor = UIColor.grayColor;
    appDesc.textAlignment = NSTextAlignmentCenter;
    appDesc.frame = CGRectMake(appDescX, appDescY, 100, 20);
    [appAreaParentView addSubview:appDesc];
}

@end
