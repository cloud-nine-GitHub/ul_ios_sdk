//
//  PayResultManager.h
//  demo
//
//  Created by 一号机雷兽 on 2019/9/23.
//  Copyright © 2019 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayResult.h"


NS_ASSUME_NONNULL_BEGIN
/**
 *专门用于处理未到账订单：
 *  订单存储
 *  订单重新上报
**/
@class PayResult;

@interface PayResultManager : NSObject
{

}


+ (void)initManager;
+ (void)savePayResultToLocal: (PayResult *)payResult;
+ (NSArray *)getPayResultFromLocal;
+ (void)removePayResultFromLocal: (PayResult *)payResult;
@end

NS_ASSUME_NONNULL_END
