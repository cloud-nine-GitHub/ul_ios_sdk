//
//  ULRequestManager.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/10.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

/*
 
 请求管理类
    对于同一广告埋点（advId）或者计费点（payId），同时只能存在一次有效请求（在请求过程中无结果回调时再次请求视为无效请求）
 
 
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULRequestManager : NSObject
{
    
}

+ (void)init;



+ (void) createRequestTask:(NSDictionary *)json;


+ (void)createAdvRequestTask: (NSString *)taskNameCmd :(NSDictionary *)data;


+ (BOOL)getRequestTaskState:(NSString *)taskNameCmd :(NSDictionary *)data;



+ (void)destroyRequestTask:(NSDictionary *)rpcCallData;

+ (void)stopAdvRequestTask:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
