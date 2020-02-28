//
//  PayResult.m
//  demo
//
//  Created by 一号机雷兽 on 2019/9/18.
//  Copyright © 2019 一号机雷兽. All rights reserved.
//

#import "PayResult.h"

@interface PayResult ()

@end

@implementation PayResult
- (id)initWithUserId :(NSString *)userId withPrice :(NSString *)price withOrderId :(NSString *)orderId withReceipt :(NSString *)receipt withPayData :(NSDictionary *)payData
{
    
    if (self = [super init]) {
        _userId = userId;
        _price = price;
        _orderId = orderId;
        _receipt = receipt;
        _payData = payData;
    }
    return self;
    
}

- (id)initWithPrice :(NSString *)price withOrderId :(NSString *)orderId withReceipt :(NSString *)receipt withPayData :(NSDictionary *)payData
{
    if (self = [super init]) {
        _price = price;
        _orderId = orderId;
        _receipt = receipt;
        _payData = payData;
    }
    return self;
}


- (NSString *)toString
{
    
    NSString *payResultToString = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@",@"PayResut:userId=",_userId,@"\nprice=",_price,@"\norderId=",_orderId,@"\nreceipt=",_receipt];
    return payResultToString;
}
@end
