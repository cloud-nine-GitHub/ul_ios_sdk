//
//  MGNativeFlowViewInfo.h
//  MobGiNativeFlowAd
//
//  Created by alan.xia on 2018/12/21.
//  Copyright © 2018年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGNativeFlowViewInfo : NSObject

//大图image，或者视频位置（开发者必修传入）
@property (assign, nonatomic) CGRect mediaViewFrame;

//广告商标志位置（可选）
@property (assign, nonatomic) CGRect logoImageFrame;



//关闭按钮位置（可选）
@property (assign, nonatomic) CGRect closeButtonFrame;

//广告标记位置（可选）
@property (assign, nonatomic) CGRect adMarkFrame;


@end

NS_ASSUME_NONNULL_END
