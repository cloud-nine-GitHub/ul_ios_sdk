//
//  ULNativeAdvItemCacher.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/16.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULINativeAdvItemProvider.h"
NS_ASSUME_NONNULL_BEGIN

@interface ULNativeAdvItemCacher : NSObject


-(id)initWithProvider:(id <ULINativeAdvItemProvider>)provider;
@end

NS_ASSUME_NONNULL_END
