//
//  MGNativeFlowAdData.h
//  MobGiNativeFlowAd
//
//  Created by alan.xia on 2018/12/18.
//  Copyright © 2018年 Lingfeng.Xia. All rights reserved.
//



@interface MGNativeFlowAdData : NSObject

/** 视频或大图的宽高比为 16:9 建议按这个尺寸来设置*/

@property (nonatomic,strong) NSString* blockId;

//广告商的平台名标志 如Toutiao、Mintegral
@property (copy, nonatomic) NSString* platformName;

//标题（广告的标题）
@property (copy, nonatomic) NSString* adTitle;

//描述信息 （广告的详情描述）
@property (copy, nonatomic) NSString* adDescription;

//图标icon网络地址
@property (strong, nonatomic) NSString* iconURL;

//广告商标志位置大小
@property (assign, nonatomic) CGSize logoImageSize;



//关闭按钮位置大小
@property (assign, nonatomic) CGSize closeButtonSize;

//广告标记位置大小
@property (assign, nonatomic) CGSize adMarkSize;



@end


