//
//  ULTimeOut.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/11.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULTimeOut : NSObject
{
    
}

+ (void)startTimeOutTask:(NSMutableDictionary *)json;
+ (void)stopTimeOutTask:(NSMutableDictionary *)rpcCallJson;


@end

NS_ASSUME_NONNULL_END
