//
//  PayResult.h
//  demo
//
//  Created by 一号机雷兽 on 2019/9/18.
//  Copyright © 2019 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayResult : NSObject
{
    @private
    NSString *_orderId;
    NSString *_receipt;
    NSString *_price;
    NSString *_userId;
    NSDictionary *_payData;
}

@property(strong,nonatomic) NSString *orderId;
@property(strong,nonatomic) NSString *receipt;
@property(strong,nonatomic) NSString *price;
@property(strong,nonatomic) NSString *userId;
@property(strong,nonatomic) NSDictionary *payData;


- (id)initWithUserId :(NSString *)userId withPrice :(NSString *)price withOrderId :(NSString *)orderId withReceipt :(NSString *)receipt withPayData :(NSDictionary *)payData;
- (id)initWithPrice :(NSString *)price withOrderId :(NSString *)orderId withReceipt :(NSString *)receipt withPayData :(NSDictionary *)payData;

- (NSString *)toString;
@end

NS_ASSUME_NONNULL_END
