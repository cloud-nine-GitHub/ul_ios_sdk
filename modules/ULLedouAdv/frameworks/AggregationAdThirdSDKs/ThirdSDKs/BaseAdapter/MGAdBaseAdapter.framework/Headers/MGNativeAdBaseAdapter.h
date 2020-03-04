//
//  MGNativeAdBaseAdapter.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/16.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MGNativeAdAdapterDelegate.h"
#import "MGNativeAdDataAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGNativeAdBaseAdapter : NSObject

@property (nonatomic, weak) id<MGNativeAdAdapterDelegate> delegate;

@property (nonatomic, strong) NSString *placementID;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) MGNativeAdDataAdapter *currentAdData;

@property (nonatomic, strong) NSString *customNativeDataKey;

@property (nonatomic, strong) NSString *thirdNativeDataKey;

@property (nonatomic, strong) NSMutableArray *dataDictArray;


- (void)startWithPlacementID:(NSString *)placementID;

- (void)loadAdsNumber:(NSNumber *)adsNumber;

- (void)registerContainerView:(UIView *)containerView
               clickableViews:(NSArray *)clickableViews
                       adData:(MGNativeAdDataAdapter *)adData;

- (void)clickAd:(MGNativeAdDataAdapter *)adData;

- (void)unregisterContainerView:(UIView *)containerView
                 clickableViews:(NSArray *)clickableViews
                         adData:(MGNativeAdDataAdapter *)adData;

- (void)cleanUpResource;


- (void)thirdLoadSuccess:(NSArray<MGNativeAdDataAdapter *> *)dataArray adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)thirdLoadFailed:(NSError *)error adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)thirdStartShow:(MGNativeAdDataAdapter *)adData adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)thirdShowFailed:(NSError *)error adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)thirdDidClicked:(MGNativeAdDataAdapter *)adData adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)thirdDidClosed:(MGNativeAdDataAdapter *)adData adManager:(MGNativeAdBaseAdapter *)adManager;


@end

NS_ASSUME_NONNULL_END
