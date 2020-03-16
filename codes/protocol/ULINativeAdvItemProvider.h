//
//  ULINativeAdvItemProvider.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/16.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#ifndef ULINativeAdvItemProvider_h
#define ULINativeAdvItemProvider_h


#endif /* ULINativeAdvItemProvider_h */
#import "ULINativeAdvItem.h"
#import "ULINativeAdvItemCallback.h"

@protocol ULINativeAdvItemProvider <NSObject>

- (ULINativeAdvItem *)getItem:(NSString *)advParam :(ULINativeAdvItemCallback *)callback;

@end
