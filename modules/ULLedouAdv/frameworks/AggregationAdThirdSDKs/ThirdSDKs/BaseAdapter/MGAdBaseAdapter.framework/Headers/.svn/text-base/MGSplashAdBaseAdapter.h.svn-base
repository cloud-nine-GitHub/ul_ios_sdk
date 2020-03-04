//
//  MGSplashAdBaseAdapter.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/16.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import "MGAdBaseAdapterCommon.h"
#import "MGSplashAdAdapterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGSplashAdBaseAdapter : MGAdBaseAdapterCommon

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, weak) id<MGSplashAdAdapterDelegate> delegate;

@property (nonatomic, assign) int fetchDelay;

@property (nonatomic, assign) BOOL hideSkipButton;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, copy) UIColor *backgroundColor;


- (void)setThirdFetchDelay:(NSNumber *)time;

- (void)setThirdHideSkipButton:(NSNumber *)hideSkipButton;


- (void)loadAdAndShow:(UIWindow *)window;

- (void)loadAdAndShow:(UIWindow *)window bottomView:(UIView *)bottomView;


- (void)thirdLifeTime:(NSNumber *)time placementID:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
