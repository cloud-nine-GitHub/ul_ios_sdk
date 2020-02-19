//
//  ULDefaultModule.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULDefaultModule.h"

@implementation ULDefaultModule


- (void)onInitModule {
    NSLog(@"%s",__func__);
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
    return nil;
}


- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr
{
    NSLog(@"%s",__func__);
    return nil;
}



@end
