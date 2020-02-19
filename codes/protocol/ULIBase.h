//
//  ULIBase.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#ifndef ULIBase_h
#define ULIBase_h


#endif /* ULIBase_h */



@protocol ULIBase <NSObject>

@optional
- (void)onInitModule;
- (void)onDisposeModule;
- (void)addListener;


- (NSString *)onJsonAPI :(NSString *)param;
- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo;
- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr;



@end
