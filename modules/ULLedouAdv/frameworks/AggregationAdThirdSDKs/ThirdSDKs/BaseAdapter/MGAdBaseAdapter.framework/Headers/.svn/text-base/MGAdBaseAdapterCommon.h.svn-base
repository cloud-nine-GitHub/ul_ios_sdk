//
//  MGAdBaseAdapterCommon.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/17.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGAdBaseAdapterCommon : NSObject

@property (nonatomic, strong) NSString *placementID;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, strong) NSString *currentPlacementID;

@property (nonatomic, assign) BOOL  isInit;

@property (nonatomic, assign) BOOL  isInitializeSuccess;

@property (nonatomic, assign) BOOL  isLoadSuccess;

@property (nonatomic, assign) BOOL  isReady;


- (void)startWithPlacementID:(NSString *)placementID;


- (void)loadAdWithPlacementID:(NSString *)placementID;


- (NSNumber *)getInitializeStatus;

- (NSNumber *)getCacheStatusWithPlacementID:(NSString *)placementID;


- (void)showAd:(UIViewController *)vc placementID:(NSString *)placementID;


- (void)cleanUpResource;


- (void)thirdInitializeSuccess;

- (void)thirdInitializeFailed:(NSError *)error;

- (void)thirdPlayableChanged:(BOOL)isAdPlayable placementID:(NSString *)placementID;

- (void)thirdLoadSuccess:(NSString *)placementID;

- (void)thirdLoadFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)thirdStartShow:(NSString *)placementID;

- (void)thirdShowFailed:(NSError *)error placementID:(NSString *)placementID;

- (void)thirdDidClicked:(NSString *)placementID;

- (void)thirdDidClosed:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
