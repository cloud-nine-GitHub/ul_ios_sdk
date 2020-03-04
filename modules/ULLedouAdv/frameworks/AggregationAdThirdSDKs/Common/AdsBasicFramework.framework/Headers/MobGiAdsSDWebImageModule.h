//
//  MobGiNativeAdSDWebImageModule.h
//  NativePolymerization
//
//  Created by star.liao on 2018/3/6.
//  Copyright © 2018年 com.idreamsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdsBasicFramework/SDWebImageDownloader.h>
#import <AdsBasicFramework/SDImageCache.h>

@interface MobGiAdsSDWebImageModule : NSObject

+ (SDWebImageDownloader*)sharedDownloader;

+ (SDImageCache*)sharedImageCache;
    
@end
