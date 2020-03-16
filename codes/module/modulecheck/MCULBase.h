//
//  MCULBase.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MCULBase : NSObject

- (id)initWithY:(int )y;
- (void)initView:(int )y;
- (BOOL )hasNativeAdv;
- (int )getViewHeight;
- (UIView *)getView;
- (NSMutableDictionary *)getBaseAdvTestData:(NSString *)editAdvId;
- (NSMutableDictionary *)getModuleAdvTestDataWithModule:(NSString *)module withType:(NSString *)advType withEditParam:(NSString *)advParam withLocalParamKey:(NSString *)key;
- (NSMutableDictionary *)getBasePayTestData:(NSString *)editPayId;
- (NSMutableDictionary *)getModulePayTestData:(NSString *)editPayId;
- (BOOL)checkId:(NSString *)payId :(NSDictionary *)payInfo;
@end

NS_ASSUME_NONNULL_END
