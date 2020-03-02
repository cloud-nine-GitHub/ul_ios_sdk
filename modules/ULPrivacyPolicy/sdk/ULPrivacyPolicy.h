//
//  ULPrivacyPolicy.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/2.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULModuleBase.h"

NS_ASSUME_NONNULL_BEGIN
#define UL_PRIVACY_POLICY_URL @"http://gamesres.ultralisk.cn/notice/leishoupolicy/"

@interface ULPrivacyPolicy : ULModuleBase

+ (void) savePrivacyPolicyState :(BOOL) isAgreePrivacyPolicy;
@end

NS_ASSUME_NONNULL_END
