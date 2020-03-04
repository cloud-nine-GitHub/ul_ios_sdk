//
//  ZZAdSetting.h
//  ZZAdSDK
//
//  Created by xuhuize on 2017/4/16.
//  Copyright © 2017年 xuhuize. All rights reserved.
//

@class ZZAdConfig;

@interface ZZAdSettings : NSObject

/**
 init SDK

 @param adConfig adConfig
 */
+(void)setConfig:(ZZAdConfig*_Nonnull)adConfig;


/**
 get current config.

 @return congfit
 */
+(ZZAdConfig*_Nullable)currentConfig;

/**
 grant consent for GDPR according user's choice.
 you should call before '+setConfig:'
 */
+(void)grantConsentForGDPR;

/**
 revoke consent for GDPR according user's choice.
 you should call before '+setConfig:'
 */
+(void)revokeConsentForGDPR;


/**
 close print log info
 */
+(void)closeConsole;


/**
 open print log info
 */
+(void)enableConsole;


@end
