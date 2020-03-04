//
//  ZZBatchFetchAdManager.h
//  ZZAdSDK
//
//  Created by xuhuize on 2018/8/31.
//  Copyright © 2018年 xuhuize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZZAdSDK/ZZAdNativeAd.h>
@interface ZZBatchFetchAdManager : NSObject
/**
 
 @param placementId The id of the ad placement.  
 @param mediaSize now only support ZZADImageSize_1200x627
 @param handler complet handler
 @return return
 */
-(instancetype)initWithPlacementId:(NSString*)placementId withImageSize:(ZZADImageSizeType)mediaSize withCompletHandler:(void(^)(NSArray<ZZAdNativeAd*>*,NSError*))handler;


/**
 Fetch a numer of native ad

 @param adSize ad's num
 */
-(void)fetchAdsWithAdSize:(int)adSize;

@end
