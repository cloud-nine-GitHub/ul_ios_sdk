//
//  ULNativeSplashAdvLayout+Portrait.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/26.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULNativeSplashAdvLayout+Portrait.h"


@implementation ULNativeSplashAdvLayout+Portrait

- (void)showNativeSplashView:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    _parentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, controller.view.bounds.size.width, controller.view.bounds.size.height)];
    [controller.view addSubview:_parentView];
    
    /*广告素材显示区域*/
    CGFloat adAreaParentWidth = controller.view.bounds.size.width;
    CGFloat adAreaParentHeight = controller.view.bounds.size.height * (4 / 5);
    _adAreaParentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adAreaParentWidth, adAreaParentHeight)];
    //设置背景图片
    UIImage *backGroundImage = [UIImage imageNamed:@"ul_native_splash_bg_image.png"];
    _adAreaParentView.contentMode=UIViewContentModeScaleAspectFill;
    _adAreaParentView.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    [_parentView addSubview:_adAreaParentView];
    
    //添加广告说明字样
    UIImageView *adMark = [[UIImageView alloc]initWithFrame:CGRectMake(10, adAreaParentHeight - 24, 26, 14)];
    adMark.image = [UIImage imageNamed:@"ul_native_advlogo_image.png"];
    [_adAreaParentView addSubview:adMark];
    
    //跳过按钮
    ZLDrawCircleProgressBtn *drawCircleBtn = [[ZLDrawCircleProgressBtn alloc]initWithFrame:CGRectMake(adAreaParentWidth - 55, 30, 40, 40)];
    drawCircleBtn.lineWidth = 2;
    [drawCircleBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [drawCircleBtn setTitleColor:[UIColor  colorWithRed:197/255.0 green:159/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    drawCircleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //跳过按钮注册点击事件
    //[drawCircleBtn addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
    _drawCircleBtn = drawCircleBtn;
    [_adAreaParentView addSubview:_drawCircleBtn];
    
    
    //原生广告素材显示区域
    
    
    
    /*应用信息显示区域*/
    CGFloat appAreaParentWidth = controller.view.bounds.size.width;
    CGFloat appAreaParentHeight = controller.view.bounds.size.height * (1 / 5);
    _appAreaParentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, appAreaParentWidth, appAreaParentHeight)];
    _appAreaParentView.backgroundColor = UIColor.whiteColor;
    [_parentView addSubview:_appAreaParentView];
    
    //应用icon
    
    
    //应用名称
    
    //应用描述
    
    
}



@end
