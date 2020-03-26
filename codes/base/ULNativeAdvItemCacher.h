//
//  ULNativeAdvItemCacher.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/16.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULINativeAdvItemProvider.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *const NATIVE_DEFAULT_TITLE = @"广告";
static NSString *const NATIVE_DEFAULT_DESC = @"哇！这个实在太棒啦！";

typedef void (^CacheCallback)(NSDictionary *gameJson,id __nullable reponse,id __nullable error);

@interface ULNativeAdvItemCacher : NSObject

@property(nonatomic,copy) CacheCallback cacheCallback;

-(id)initWithProvider:(id <ULINativeAdvItemProvider>)provider;
- (id)pollUsingItem :(NSString *)advId;
- (void)getAdvItem :(NSString *)advId :(NSString *)paramString :(NSDictionary *)gameJson;
@end

NS_ASSUME_NONNULL_END
