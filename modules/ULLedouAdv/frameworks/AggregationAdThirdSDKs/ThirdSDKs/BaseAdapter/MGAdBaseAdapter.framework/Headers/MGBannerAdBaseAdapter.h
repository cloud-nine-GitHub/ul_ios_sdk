//
//  MGBannerAdBaseAdapter.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/6/12.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MGBannerAdAdapterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGBannerAdBaseAdapter : NSObject

@property (nonatomic, weak) id<MGBannerAdAdapterDelegate>     delegate;

@property (nonatomic, strong) NSString *placementID;

@property (nonatomic, strong) UIViewController *viewContoller;

@property (nonatomic, strong) UIView *view;


@property (nonatomic, assign) BOOL  isReady;


@property (nonatomic, assign) int interval;

@property (nonatomic, assign) int sizeType;

@property (nonatomic, assign) BOOL  isShowCloseButton;


@property (nonatomic, assign) CGRect bannerFrame;


- (instancetype)initWithPlacementID:(NSString *)placementID;


- (void)setAdInterval:(NSNumber *)interval;

- (void)setAdSizeType:(NSNumber *)sizeType;

- (void)setAdIsShowCloseButton:(NSNumber *)isShow;


- (void)startWithViewContoller:(UIViewController *)viewContoller view:(UIView*)view rectValue:(NSValue *)rectValue;


- (void)loadAd;

- (NSUInteger)getSelectedSizeIndex:(NSArray *)sizeData;

- (NSNumber *)getAdStatus;

- (UIView *)getAdView;


- (void)showAd;

- (void)cleanUpResource;


- (void)adLoadSuccess:(UIView *)view;

- (void)adLoadFailed:(UIView *)view error:(NSError *)error;

- (void)adStartShow:(UIView *)view;

- (void)adShowFailed:(UIView *)view error:(NSError *)error;

- (void)adDidClicked:(UIView *)view;

- (void)adDidClosed:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
