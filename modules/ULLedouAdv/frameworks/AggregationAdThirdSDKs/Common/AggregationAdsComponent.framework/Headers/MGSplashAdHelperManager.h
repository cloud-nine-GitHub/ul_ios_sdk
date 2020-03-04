//
//  MGSplashAdHelperManager.h
//  SDKCommonModule
//
//  Created by alan.xia on 2018/7/20.
//  Copyright © 2018年 com.idreamsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSplashAdHelperManager : NSObject

@property (nonatomic, assign) BOOL  splashSDKInit;

@property (nonatomic, assign) BOOL  splashHidden;

+ (MGSplashAdHelperManager *)sharedManager;

@end
