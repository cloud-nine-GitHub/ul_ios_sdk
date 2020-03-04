//
//  SDKMGAdResourceManager.h
//  SDKCommonModule
//
//  Created by alan.xia on 2019/11/26.
//  Copyright © 2019 com.idreamsky. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@interface SDKMGAdResourceManager : NSObject

+ (NSBundle *)getAdResourceBundle;

+ (UIImage *)getAdMarkImage;

+ (UIImage *)getCloseRectangularImage;

+ (UIImage *)getCloseCircularImage;

@end

NS_ASSUME_NONNULL_END
