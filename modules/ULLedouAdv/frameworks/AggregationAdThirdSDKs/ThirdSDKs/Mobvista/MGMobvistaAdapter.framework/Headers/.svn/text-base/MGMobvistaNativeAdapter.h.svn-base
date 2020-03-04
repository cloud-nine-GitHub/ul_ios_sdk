//
//  MGMobvistaNativeAdapter.h
//  MGMobvistaAdapter
//
//  Created by alan.xia on 2017/5/23.
//  Copyright © 2017年 com.idreamsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol MGMobvistaNativeAdapterDelegate <NSObject>

- (void)nativeAdLoadSuccess:(NSDictionary *)dict;

- (void)nativeAdLoadFail:(NSString *)error;

- (void)nativeAdClick;

@end

@interface MGMobvistaNativeAdapter : NSObject

@property (nonatomic,strong)id<MGMobvistaNativeAdapterDelegate>  delegate;

- (instancetype) init:(UIViewController *)vc
              blockId:(NSString *)blockId;

- (void)loadAd;

- (void)setRealViewController:(UIViewController *)realController;

- (void)showAd:(UIView *)view;

- (void)closeAd;

@end
