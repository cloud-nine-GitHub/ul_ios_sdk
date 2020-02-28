//
//  ULAppstore.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/21.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULModuleBaseSdk.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const UL_APPSTORE_SANDBOX_VERIFY_URL = @"https://sandbox.itunes.apple.com/verifyReceipt";//支付凭据校验沙盒地址
static NSString *const UL_APPSTORE_BUY_VERIFY_URL = @"https://buy.itunes.apple.com/verifyReceipt";//支付凭据校验正式地址
static NSString *const UL_APPSTORE_VERIFY_PASSWORD = @"c1927b0780c14400a5a9f2fd39535107";//支付凭据校验正式地址

@interface ULAppstore : ULModuleBaseSdk

@end

NS_ASSUME_NONNULL_END
