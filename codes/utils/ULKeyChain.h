//
//  ULKeyChain.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULKeyChain : NSObject


+ (NSData *)getDataFromKeyChainWithKey:(NSString *)key;
+ (void)saveDataToKeyChainWithKey: (NSString *)key withValue:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
