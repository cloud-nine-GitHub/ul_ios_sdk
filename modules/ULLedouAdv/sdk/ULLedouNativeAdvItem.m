//
//  ULLedouNativeAdvItem.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULLedouNativeAdvItem.h"
#import "ULINativeAdvItem.h"
#import "ULQueue.h"
#import "NativeAdData.h"
#import "NativePolymerization.h"
#import "NativeAdDetailsInfo.h"
#import "ULTools.h"
#import "ULConfig.h"
#import "ULNativeAdvResponseDataItem.h"

@interface MyAdDataItem : NSObject
{
    @private
    NSDictionary *_gameJson;
}

@property (nonatomic,strong)NSDictionary *gameJson;
- (id)initWithGameJson:(NSDictionary *)gameJson;

@end

@implementation MyAdDataItem

- (id)initWithGameJson:(NSDictionary *)gameJson
{
    if (self = [super init]) {
        _gameJson = gameJson;
    }
    return self;
}

@end


@interface ULLedouNativeAdvItem ()<ULINativeAdvItem>

@property (nonatomic,strong) id<ULINativeAdvItemCallback> myNativeAdvCallback;
@property (nonatomic,strong) NSString *advParam;

@end


@implementation ULLedouNativeAdvItem

- (id)initWithParam:(NSString *)advParam withCallback:(id <ULINativeAdvItemCallback>)callback
{
    if (self = [super init]) {
        
        _advParam = advParam;
        _myNativeAdvCallback = callback;
        
        //不能重复初始化
//        NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_ledou_appkey" :@""];
//        [[NativePolymerization sharedInstance] initSDK:appKey blockids:@[advParam]];
        
    }
    return self;
}


- (void)load:(NSDictionary *)gameJson
{
    [self loadAd:gameJson];
}

- (void)onDispose:(ULNativeAdvResponseDataItem *)response
{
    [[NativePolymerization sharedInstance] unAttachAd:response.response toView:response.containerView];
}


- (void)loadAd:(NSDictionary *)gameJson
{
    MyAdDataItem *item = [[MyAdDataItem alloc] initWithGameJson:gameJson];
    //没有回调，同步状态，那么就无需担心存在多个请求，直接处理
    //获取原生广告
    NativeAdData *data = [[NativePolymerization sharedInstance]getNativeAd:_advParam];
    if (data) {
        
        //拿到原生素材后我们还是直接曝光
        /**
         *  接入方在拿到原生广告数据后，绘制界面成功后，必须调用该方法，否则广告收益不予结算
         *
         *  currentAd 当前显示界面对应的原生广告数据
         *  adView    显示界面
         *  vc   显示界面所属的视图控制器
         *  detailsInfo   当前显示界面对应的原生广告其他详细信息 isGame表示应用类型（yes游戏no应用），与点击和展示有关联
         */
        NativeAdDetailsInfo *detailsInfo = [[NativeAdDetailsInfo alloc]init];
        detailsInfo.isGame = YES;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];//先给个1像素
        view.backgroundColor = UIColor.clearColor;//设置透明
        view.alpha = 0.02;
        
        [[ULTools getCurrentViewController].view addSubview:view];
        
        ULNativeAdvResponseDataItem *response = [[ULNativeAdvResponseDataItem alloc] initWithResponse:data withContainerView:view withClickView:view];
        
        [_myNativeAdvCallback onGetItemSuccessed:item.gameJson :response :_advParam ];
        
        [[NativePolymerization sharedInstance]attachAd:data toView:view vc:[ULTools getCurrentViewController] detailsInfo:detailsInfo];
    }else{
        [_myNativeAdvCallback onGetItemFailed:item.gameJson :nil :_advParam :@"no data"];
    }
    
}


@end





