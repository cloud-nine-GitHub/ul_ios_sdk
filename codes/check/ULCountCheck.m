//
//  ULCountCheck.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/14.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "ULCountCheck.h"
#import "ULICheck.h"
#import "ULCountTool.h"
#import "ULTools.h"


@interface ULCountCheck ()<ULICheck>

@end

@implementation ULCountCheck

static ULCountCheck *instance = nil;

+ (instancetype)getInstance{
    if(!instance){
        instance = [[self alloc] init];
        
    }
    return instance;
}



-(id)init
{
    if (self = [super init]) {
        [self setAdvMaxNumber];
    }
    return self;
}


- (void)setAdvMaxNumber
{
    //设置次数上限
    NSString *defaultString = @"0";
    NSString *interClickMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_interstitial_click_num" withDefaultString:defaultString];
    int interClickMaxNumInt;
    @try {
        interClickMaxNumInt = [interClickMaxNum intValue];
    } @catch (NSException *exception) {
        interClickMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_interstitial_click_num" :interClickMaxNumInt];
    
    NSString *interShowMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_interstitial_show_num" withDefaultString:defaultString];
    int interShowMaxNumInt;
    @try {
        interShowMaxNumInt = [interShowMaxNum intValue];
    } @catch (NSException *exception) {
        interShowMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_interstitial_show_num" :interShowMaxNumInt];
    
    
    NSString *videoClickMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_video_click_num" withDefaultString:defaultString];
    int videoClickMaxNumInt;
    @try {
        videoClickMaxNumInt = [videoClickMaxNum intValue];
    } @catch (NSException *exception) {
        videoClickMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_video_click_num" :videoClickMaxNumInt];
    
    
    NSString *videoShowMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_video_show_num" withDefaultString:defaultString];
    int videoShowMaxNumInt;
    @try {
        videoShowMaxNumInt = [videoShowMaxNum intValue];
    } @catch (NSException *exception) {
        videoShowMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_video_show_num" :videoShowMaxNumInt];
    
    
    NSString *bannerClickMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_banner_click_num" withDefaultString:defaultString];
    int bannerClickMaxNumInt;
    @try {
        bannerClickMaxNumInt = [bannerClickMaxNum intValue];
    } @catch (NSException *exception) {
        bannerClickMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_banner_click_num" :bannerClickMaxNumInt];
    
    
    NSString *bannerShowMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_banner_show_num" withDefaultString:defaultString];
    int bannerShowMaxNumInt;
    @try {
        bannerShowMaxNumInt = [bannerShowMaxNum intValue];
    } @catch (NSException *exception) {
        bannerShowMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_banner_show_num" :bannerShowMaxNumInt];
    
    
    NSString *embeddedClickMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_embedded_click_num" withDefaultString:defaultString];
    int embeddedClickMaxNumInt;
    @try {
        embeddedClickMaxNumInt = [embeddedClickMaxNum intValue];
    } @catch (NSException *exception) {
        embeddedClickMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_embedded_click_num" :embeddedClickMaxNumInt];
    
    
    NSString *embeddedShowMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_embedded_show_num" withDefaultString:defaultString];
    int embeddedShowMaxNumInt;
    @try {
        embeddedShowMaxNumInt = [embeddedShowMaxNum intValue];
    } @catch (NSException *exception) {
        embeddedShowMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_embedded_show_num" :embeddedShowMaxNumInt];
    
    
    NSString *fullscreenClickMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_fullscreen_click_num" withDefaultString:defaultString];
    int fullscreenClickMaxNumInt;
    @try {
        fullscreenClickMaxNumInt = [fullscreenClickMaxNum intValue];
    } @catch (NSException *exception) {
        fullscreenClickMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_fullscreen_click_num" :fullscreenClickMaxNumInt];
    
    
    NSString *fullscreenShowMaxNum = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_fullscreen_show_num" withDefaultString:defaultString];
    int fullscreenShowMaxNumInt;
    @try {
        fullscreenShowMaxNumInt = [fullscreenShowMaxNum intValue];
    } @catch (NSException *exception) {
        fullscreenShowMaxNumInt = [defaultString intValue];
    }
    [[ULCountTool getInstance]setMax:@"s_sdk_adv_fullscreen_show_num" :fullscreenShowMaxNumInt];
}


- (BOOL) checkResult:(id)condition
{
    return [[ULCountTool getInstance]checkOverload:(NSString *)condition];
}

@end
