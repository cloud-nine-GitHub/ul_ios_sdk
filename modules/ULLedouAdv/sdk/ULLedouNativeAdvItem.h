//
//  ULLedouNativeAdvItem.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULINativeAdvItemCallback.h"
NS_ASSUME_NONNULL_BEGIN

@interface ULLedouNativeAdvItem : NSObject

- (id)initWithParam:(NSString *)advParam withCallback:(id <ULINativeAdvItemCallback>)callback;
@end

NS_ASSUME_NONNULL_END
