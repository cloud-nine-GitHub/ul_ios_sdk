
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  原生广告数据类，接入方根据里面的属性，自行绘制界面
 */
@interface NativeAdData : NSObject

#pragma mark -

//广告位ID
/*
 广告后台会针对每一个广告位ID设置图片尺寸
 现有尺寸比例如下: (注意:后续可能会有所修改)
 32:5 640*100
 16:9 1280*720
 2:3 640*960
 3:2 960*640
 1:1 1200*1200
 2:1
 1200:627 1200*627
 */

@property(nonatomic,strong) NSString* blockid;

//广告商的平台名标志 如GDT、Admob
@property (copy, nonatomic) NSString* adName;

//标题（广告的标题）
@property (copy, nonatomic) NSString* title;

//描述信息 （广告的详情描述）
@property (copy, nonatomic) NSString* descriptionText;

//图标icon本地缓存地址
@property (strong, nonatomic ) NSString* iconLocalURL;

//大图image本地缓存地址,mainfigureImgUrls里的第一个元素
@property (strong, nonatomic) NSString* imageLocalURL;

//主图本地缓存数组
@property(nonatomic,strong) NSArray* mainfigureLocalImgUrls;


#pragma mark -

//评分(值为1到10)
@property(nonatomic,assign) double rating;

//行动语(下载标题)
@property(nonatomic,strong) NSString* actionLanguageText;

//图标icon网络地址
@property (strong, nonatomic) NSString* iconURL;

//大图image网络地址
@property (strong, nonatomic) NSString* imageURL;

//额外信息
@property (nonatomic, strong) NSDictionary* extras;


@end
