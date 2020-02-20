//
//  ULInviteComment.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULInviteComment.h"
#import "ULCmd.h"
#import "ULTools.h"
#import "ULConfig.h"
#import <StoreKit/StoreKit.h>

@implementation ULInviteComment


- (void)onInitModule
{
    NSLog(@"%s",__func__);
}


- (void)onDisposeModule

{
    NSLog(@"%s",__func__);
}

- (void)addListener
{
    NSLog(@"%s",__func__);
}


- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    NSDictionary *json = [ULTools StringToDictionary: param];
    NSString *cmd = [json objectForKey:@"cmd"];
    id data = [json objectForKey:@"data"];
    if ([cmd isEqualToString:MSG_CMD_INVITE_TO_COMMENT]) {
        [self openInviteToComment:data];
    }
    return nil;
}

-(void)openInviteToComment :(NSDictionary *)data
{
    
    NSString *appleId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_app_appleid" :@""];
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            [SKStoreReviewController requestReview];
        }else{
            NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",appleId];//替换为对应的APPID
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        }
    } else {
        // Fallback on earlier versions
        NSString  *nsStringToOpen = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",appleId];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }

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
