//
//  ZLDrawCircleProgressBtn.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/27.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

/**
 
 原生开屏跳过按钮
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DrawCircleProgressBlock)(void);

@interface ZLDrawCircleProgressBtn : UIButton

//set track color
@property (nonatomic, strong) UIColor    *trackColor;

//set progress color
@property (nonatomic, strong) UIColor    *progressColor;

//set track background color
@property (nonatomic, strong) UIColor    *fillColor;

//set progress line width
@property (nonatomic, assign) CGFloat    lineWidth;

//set progress duration
@property (nonatomic, assign) CGFloat    animationDuration;

/**
 *  set complete callback
 *
 *  @param lineWidth line width
 *  @param block     block
 *  @param duration  time
 */
- (void)startAnimationDuration:(CGFloat)duration withBlock:(DrawCircleProgressBlock )block;


@end

NS_ASSUME_NONNULL_END
