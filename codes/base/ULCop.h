//
//  ULCop.h
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/29.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>


static const int ADV_SHOW_SPLASH_LIST = 0;
static const int ADV_SHOW_INTER_LIST = 1;
static const int ADV_SHOW_BANNER_LIST = 2;

NS_ASSUME_NONNULL_BEGIN

@interface ULCop : NSObject

+ (void)initCopInfo;
+ (NSDictionary*)getCopInfo;
+ (NSString *)getCopInfoString;

@end


NS_ASSUME_NONNULL_END
