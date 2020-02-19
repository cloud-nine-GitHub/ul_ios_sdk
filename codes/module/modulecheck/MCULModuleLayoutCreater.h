//
//  MCULModuleLayoutCreater.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

static NSString *const UL_TEXT_PARAMS_CONFIG_NAME = @"参数配置:";
static NSString *const UL_TEXT_PARAMS_CONFIG_DEFAULT = @"这里显示参数配置信息";
static NSString *const UL_TEXT_LOCAL_CONFIG_NAME = @"本地参数配置";
static NSString *const UL_TEXT_COP_CONFIG_NAME = @"cop参数配置";
static NSString *const UL_TEXT_BASE_PAY = @"模拟支付流程:";
static NSString *const UL_EDIT_PAYID = @"请输入计费点";
static NSString *const UL_TEXT_BASE_ADV = @"模拟广告流程:";
static NSString *const UL_TEXT_CLICK_PAY = @"点击支付";
static NSString *const UL_EDIT_ADVID = @"请输入广告位";
static NSString *const UL_EDIT_ADV_PARAM = @"请输入广告参数";
static NSString *const UL_TEXT_CLICK_SHOW = @"点击展示";
static NSString *const UL_TEXT_DEFAULT_MODULE = @"默认模块";
static NSString *const UL_TEXT_DEFAULT_ACTION = @"默认行为";
static NSString *const UL_TEXT_DEFAULT_CALLBACK_INFO = @"这里显示广告或者支付的回调信息";
static NSString *const UL_TEXT_SELECT_ADV_TYPE = @"选择广告类型";

@interface MCULModuleLayoutCreater : NSObject
{
    
}

+ (void) adjustCenterWithParentView:(UIView *)parentView withChildView:(UIView *)childView;
+ (void) showTipsWithTitile:(NSString *)title withDesc:(NSString *)desc withBtnText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
