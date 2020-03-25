//
//  ULINativeAdvItemCallback.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/16.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#ifndef ULINativeAdvItemCallback_h
#define ULINativeAdvItemCallback_h


#endif /* ULINativeAdvItemCallback_h */

@protocol ULINativeAdvItemCallback <NSObject>

- (void)onGetItemSuccessed:(NSDictionary *)gameJson :(id )response :(NSString *)advParam;
- (void)onGetItemFailed:(NSDictionary *)gameJson :(id )response :(NSString *)advParam :(id )error;

@end
