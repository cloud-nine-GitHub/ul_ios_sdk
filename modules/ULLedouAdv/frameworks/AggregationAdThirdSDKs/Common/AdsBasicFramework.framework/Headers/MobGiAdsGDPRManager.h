//
//  MobGiAdsGDPRManager.h
//  AdsBasicFramework
//
//  Created by ocomme.zhou on 2019/10/14.
//  Copyright © 2019 com.idreamsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MobGiAdsGDPRManager : NSObject

+ (instancetype)sharedInstance;

/**
 consent status
 */
@property (nonnull, nonatomic, readonly, strong) NSNumber *consent;

/**
 update consent status
 */
- (void)updateConsent:(BOOL)consent;

@end

@interface MobGiAdsGDPRManager (alert)

- (void)showPrivacyPolicy: (void (^)(BOOL consent))consentBlock;

@end

NS_ASSUME_NONNULL_END
