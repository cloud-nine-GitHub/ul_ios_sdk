//
//  MGAdBaseAdapterSetting.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/17.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MGAdBaseAdapterSetting : NSObject

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;

/**
 agree status
 */
@property (nonatomic, strong, readonly) NSNumber *consent;

@property (nonatomic, assign) BOOL  isInit;
@property (nonatomic, assign) BOOL  isSetDebug;
@property (nonatomic, assign) BOOL  isSetGDPR;

+ (NSString *)getSDKVersion;

+ (NSString *)getSDKDefaultVersion;

/**
 GDPR – Managing Consent
 
 If the user provided consent, please set the following flag to true:
 If the user did not consent, please set the following flag to false:
 
 @param consent Allowed data collection
 */
- (void)setConsent:(NSNumber *)consent;

- (void)setLoggingLevel:(NSNumber *)loggingLevel;

- (void)setThirdAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

- (NSString *)getErrorMessageWithErrorCode:(int)errorCode;

@end

NS_ASSUME_NONNULL_END
