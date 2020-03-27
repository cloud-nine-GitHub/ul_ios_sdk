//
//  ULINativeAdvItem.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/16.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#ifndef ULINativeAdvItem_h
#define ULINativeAdvItem_h


#endif /* ULINativeAdvItem_h */

#import "ULNativeAdvResponseDataItem.h"

@protocol ULINativeAdvItem <NSObject>

- (void)load:(NSDictionary *)gameJson;
- (void)onDispose:(ULNativeAdvResponseDataItem *)response;

@end
