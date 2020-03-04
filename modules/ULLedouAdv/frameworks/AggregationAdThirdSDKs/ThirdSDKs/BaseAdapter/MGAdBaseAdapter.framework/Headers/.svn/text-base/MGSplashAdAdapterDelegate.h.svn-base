//
//  MGSplashAdAdapterDelegate.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/16.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGSplashAdAdapterDelegate <NSObject>

@optional

- (void)splashAdLoadSuccess:(NSString *)placementID;

- (void)splashAdLoadFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)splashAdStartShow:(NSString *)placementID;

- (void)splashAdShowFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)splashAdDidClicked:(NSString *)placementID;

- (void)splashAdLifeTime:(NSNumber *)time placementID:(NSString *)placementID;

- (void)splashAdDidClosed:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
