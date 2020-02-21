//
//  ULInnerPromotion.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULInnerPromotion.h"
#import "ULSKStoreProductViewController.h"
#import "ULTools.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULSDKManager.h"
#import "ULCmd.h"

static NSString *const UL_INTER_PROMOTION_ICON_DEFAULT_BASE_URL = @"http://gamesres.ultralisk.cn/notice/gameIcon/";

@interface ULInnerPromotion ()<SKStoreProductViewControllerDelegate>

@property (nonatomic,strong)NSMutableDictionary *promotionDataDict;
@property (nonatomic,strong)NSString *usingScheme;
@property (nonatomic,assign)BOOL pushingFlag;

@end


@implementation ULInnerPromotion


- (void)onInitModule {
    NSLog(@"%s",__func__);
    
    
    NSString *innerData = [ULTools getCopOrConfigStringWithKey:@"s_sdk_inner_promotion_data" withDefaultString:@""];
    if (innerData == nil ||[innerData isEqualToString :@""] ) {
        NSLog(@"%s%@",__func__,@":未获取到互推数据");
        return;
    }
    _promotionDataDict = [NSMutableDictionary dictionary];
    NSArray *innerDataArray = [innerData componentsSeparatedByString:@"|"];
    
    for (NSString *itemData in innerDataArray) {
        NSArray *itemDataArray = [itemData componentsSeparatedByString:@";"];
        if (itemDataArray.count != 5) {
            NSLog(@"%s%@",__func__,@":检测到元组数据未按要求配置");
            continue;
        }
        NSString *appleId = itemDataArray[0];
        NSDictionary *mutualPushSchemes = [ULTools GetNSDictionaryFromDic:[ULConfig getConfigInfo] :@"o_sdk_inner_promotion_schemes" :nil];
        NSString *scheme = [ULTools GetStringFromDic:mutualPushSchemes :appleId :@""];
        [_promotionDataDict setValue:itemData forKey:scheme];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self checkAppInstalled :scheme]) {
                [self checkResult:1 :@"目标应用已安装" :itemDataArray];
            }else{
                [self checkResult:0 :@"目标应用未安装" :itemDataArray];
            }
        });
        

    }
}


- (void)requestDownloadApp :(NSDictionary *)json
{
    if(_pushingFlag){
        //简单粗暴的直接拦截
        NSLog(@"%s 已有下载请求执行中",__func__);
        [self downloadResult :0 :@"失败" :json];
        return;
        
    }
    _pushingFlag = YES;
    NSLog(@"%s download-json:%@" ,__func__,json);

    NSString *appleId = [ULTools GetStringFromDic:json :@"appleId" :@""];
    if (appleId == nil || [appleId isEqualToString:@""]) {
        NSLog(@"%s appleId获取失败",__func__);
        [self downloadResult :0 :@"失败" :json];
        return;
    }
    NSDictionary *mutualPushSchemes = [ULTools GetNSDictionaryFromDic:[ULConfig getConfigInfo ]:@"o_sdk_inner_promotion_schemes" :nil];
    _usingScheme = [ULTools GetStringFromDic:mutualPushSchemes :appleId :@""];
    
    
    ULSKStoreProductViewController *controller = [[ULSKStoreProductViewController alloc] init];
    controller.delegate = self;
    NSDictionary * dic = @{SKStoreProductParameterITunesItemIdentifier:appleId};
    [controller loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (result) {
            [self downloadResult :1 :@"成功" :json];
        }else{
            [self downloadResult :0 :@"失败" :json];
        }
        self->_pushingFlag = NO;
    }];
    [[ULTools getCurrentViewController] presentViewController:controller animated:YES completion:nil];
}


- (BOOL)checkAppInstalled:(NSString *)scheme
{
    NSLog(@"%s scheme:%@",__func__ ,scheme);
    @try {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[scheme stringByAppendingString:@"://"]]]) {
            NSLog(@"%s 已安装",__func__);
            return YES;
        }else{
            NSLog(@"%s 未安装",__func__);
            return NO;
        }
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%s 检测目标应用是否存在出现异常:%@" ,__func__,exception);
        return NO;
    }
    return NO;
    
}

- (void)downloadResult :(int)code :(NSString *)msg :(NSDictionary *)json
{
    NSLog(@"%s downloadResult:%d %@ %@",__func__,code,msg,json);
    NSString *appleId = [ULTools GetStringFromDic:json :@"appleId" :@""];
    NSString *userData = [ULTools GetStringFromDic:json :@"userData" :@""];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [dataDict setValue:msg forKey:@"msg"];
    [dataDict setValue:appleId forKey:@"appleId"];
    [dataDict setValue:userData forKey:@"userData"];
    
    [ULSDKManager JsonRpcCall:MSG_CMD_INNER_PROMOTION_DOWNLOAD_RESULT :dataDict];
}

- (void)checkResult :(int)code :(NSString *)msg :(NSArray *)itemDataArray
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setValue:[NSNumber numberWithInt:code] forKey:@"code"];
    [dataDict setValue:msg forKey:@"msg"];
    
    
    if (itemDataArray != nil) {
        NSString *appleId = itemDataArray[0];
        NSString *iconBaseUrl = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_inner_promotion_icon_baseurl" :@""];
        if (iconBaseUrl == nil || [iconBaseUrl isEqualToString:@""]) {
            iconBaseUrl = UL_INTER_PROMOTION_ICON_DEFAULT_BASE_URL;
        }
        NSString *iconUrl = [iconBaseUrl stringByAppendingString: itemDataArray[1]];
        iconUrl = [iconUrl stringByAppendingString:@".png"];
        NSString *appName = itemDataArray[2];
        NSString *rewardsType = itemDataArray[3];
        NSString *rewardsCount = itemDataArray[4];
        
        NSMutableDictionary *promotionData = [NSMutableDictionary dictionary];
        [promotionData setValue:appleId forKey:@"appleId"];
        [promotionData setValue:iconUrl forKey:@"iconUrl"];
        [promotionData setValue:appName forKey:@"appName"];
        [promotionData setValue:rewardsType forKey:@"rewardsItemId"];
        [promotionData setValue:rewardsCount forKey:@"rewardsAmount"];
        [dataDict setValue:promotionData forKey:@"promotionData"];
        
    }else{

        NSMutableDictionary *promotionData = [NSMutableDictionary dictionary];
        [promotionData setValue:@"" forKey:@"appleId"];
        [promotionData setValue:@"" forKey:@"iconUrl"];
        [promotionData setValue:@"" forKey:@"appName"];
        [promotionData setValue:@"" forKey:@"rewardsItemId"];
        [promotionData setValue:@"" forKey:@"rewardsAmount"];
        [dataDict setValue:promotionData forKey:@"promotionData"];
    }
    
    
    [ULSDKManager JsonRpcCall:MSG_CMD_INNER_PROMOTION_CHECK_RESULT :dataDict];
}




// Sent if the user requests that the page be dismissed
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController __TVOS_PROHIBITED NS_AVAILABLE_IOS(6_0)
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%s退出下载页面:%@",__func__,_promotionDataDict);
    NSString *itemData = [_promotionDataDict objectForKey:_usingScheme];
    NSArray *itemDataArray;
    if(itemData == nil){
        itemDataArray = nil;
    }else{
        itemDataArray = [itemData componentsSeparatedByString:@";"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self checkAppInstalled :self->_usingScheme]) {
            [self checkResult:1 :@"目标应用已安装" :itemDataArray];
        }else{
            [self checkResult:0 :@"目标应用未安装" :itemDataArray];
        }
    });
    
}





- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    return nil;
}


- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo
{
    NSLog(@"%s",__func__);
    NSString *isCloseCop = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_close_cop" :@"0"];
    if ([isCloseCop isEqualToString:@"1"]) {
        //对于不使用cop而使用本地配置的情况，下列配置依然需要返回
        //是否显示互推按钮
        NSString *inner = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_inner_promotion_data" :@""];
        if (inner && ![inner isEqualToString:@""]) {
            [baseChannelInfo setValue:[NSNumber numberWithBool:true] forKey:@"isShowUlInnerPromotionIcon"];
        }else{
            [baseChannelInfo setValue:[NSNumber numberWithBool:false] forKey:@"isShowUlInnerPromotionIcon"];
        }
    }
    [ULSDKManager setBaseChannelInfo:baseChannelInfo];
    return nil;
}


- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr
{
    NSLog(@"%s",__func__);
    return nil;
}


@end
