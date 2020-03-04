//
//  MGNativeAdAdapterDelegate.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/16.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGNativeAdBaseAdapter;
@class MGNativeAdDataAdapter;

NS_ASSUME_NONNULL_BEGIN

@protocol MGNativeAdAdapterDelegate <NSObject>

- (void)nativeAdLoadSuccess:(NSArray<MGNativeAdDataAdapter *> *)dataArray adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)nativeAdLoadFailed:(NSError *)error adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)nativeAdStartShow:(MGNativeAdDataAdapter *)adData adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)nativeAdShowFailed:(NSError *)error adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)nativeAdDidClicked:(MGNativeAdDataAdapter *)adData adManager:(MGNativeAdBaseAdapter *)adManager;

- (void)nativeAdDidClosed:(MGNativeAdDataAdapter *)adData adManager:(MGNativeAdBaseAdapter *)adManager;

@end

NS_ASSUME_NONNULL_END
