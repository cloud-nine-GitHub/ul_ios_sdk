//
//  ULConfig.h
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/21.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//2类
static NSString *const NOTIFICATION_SDK_OPENPAY = @"ulsdkopenpay";
static NSString *const NOTIFICATION_SDK_OPENADV = @"ulsdkopenadv";




@interface ULConfig : NSObject

+ (void)initConfigInfo;
+ (NSDictionary*)getConfigInfo;
+ (NSString *)getConfigInfoString;
+ (NSArray *)getModuleList;
+ (NSString *)getUlsdkVersion;
@end


NS_ASSUME_NONNULL_END
