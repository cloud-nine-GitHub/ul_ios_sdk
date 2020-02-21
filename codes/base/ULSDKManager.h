//
//  ULSDKManager.h
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/21.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULSDKManager : NSObject
{
    
}
+ (void)init;
+ (void)initAdv;
+ (void)JsonAPI :(NSString *)jsonStr;
+ (void)JsonRpcCall :(NSString *)cmd :(NSMutableDictionary *)dataDic;
+ (void)openAdv:(NSDictionary *)data;
+ (long)getAdvRequestSerialNum;
+ (void)setAdvRequestSerialNum:(long)num;
+ (NSMutableDictionary *)getBaseChannelInfo;
+ (void)setBaseChannelInfo:(NSMutableDictionary *)info;
+ (NSMutableDictionary *)getModuleTypeParamsDic;
@end

NS_ASSUME_NONNULL_END
