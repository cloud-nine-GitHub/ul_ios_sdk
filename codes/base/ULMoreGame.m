//
//  ULMoreGame.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULMoreGame.h"
#import "ULTools.h"
#import "ULWebView.h"
#import "ULCop.h"
#import "ULConfig.h"

@implementation ULMoreGame

+ (void)showMoreGame
{
    
    NSMutableDictionary *jsonData = [NSMutableDictionary new];
    NSString *url = [ULTools getCopOrConfigStringWithKey:@"s_sdk_ul_more_game_url" withDefaultString:@""];
    NSString *channelName = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_common_channel_name" :@""];
    
    NSArray  *array = [[NSArray alloc] initWithArray:[url componentsSeparatedByString:@"?"]];
    
    if ([array count] > 1){
        url = [url stringByAppendingFormat:@"&channelName=%@",channelName];
    }else{
        url = [url stringByAppendingFormat:@"?channelName=%@",channelName];
    }
    [jsonData setValue:url forKey:@"url"];
    
    [ULWebView showWebView:jsonData];

}

@end
