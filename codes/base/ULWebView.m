//
//  ULWebView.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULWebView.h"
#import <UIKit/UIKit.h>
#import "ULTools.h"
#import "ULSDKManager.h"
#import "ULCop.h"
#import "ULCmd.h"

@interface ULWebView ()<UIWebViewDelegate>

//@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ULWebView

static UIWebView *webView = nil;

+ (void)showWebView:(NSDictionary*)json
{
    dispatch_async(dispatch_get_main_queue(), ^{
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString * url = [ULTools GetStringFromDic:json :@"url" :@""];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [[ULTools getCurrentViewController].view addSubview:webView];
        
        [webView loadRequest:request];
        [webView setDelegate:self];
        
        


        NSMutableDictionary *data = [NSMutableDictionary new];
        [ULSDKManager JsonRpcCall:REMSG_CMD_PAUSESOUND :data];
        
        
        UIViewController *controller = [ULTools getCurrentViewController];
        UIInterfaceOrientation orien = controller.interfaceOrientation;
        


        //默认竖屏展示
        NSString *isForcePortrait = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_common_webview_force_portrait" :@"1"];
        if([isForcePortrait isEqualToString:@"1"]){
            if(orien == UIInterfaceOrientationLandscapeLeft || orien == UIInterfaceOrientationLandscapeRight){
                [self landscapeExecute:orien];
                [self addCloseButton:webView.frame.size.height];
                return;
            }
        }

        [self addCloseButton:webView.frame.size.width];
    });
    

}


+ (void) addCloseButton:(CGFloat)coordinate
{
    UIButton *closeButton = [UIButton new];
    closeButton.frame = CGRectMake(5, 5, 25, 25);
    UIImage *image = [UIImage imageNamed:@"close.jpg"];
    [closeButton setBackgroundImage:image forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:closeButton];
}



+ (void)closeButtonAction
{
    NSLog(@"%s",__func__);
    NSMutableDictionary *data = [NSMutableDictionary new];
    [ULSDKManager JsonRpcCall:REMSG_CMD_RESUMESOUND :data];
    [webView removeFromSuperview];
}



//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType API_DEPRECATED("No longer supported.", ios(2.0, 12.0))
//{
//    NSLog(@"%s",__func__);
//}
- (void)webViewDidStartLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0))
{
    NSLog(@"%s",__func__);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0))
{
    NSLog(@"%s",__func__);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error API_DEPRECATED("No longer supported.", ios(2.0, 12.0))
{
    NSLog(@"%s%@",__func__,error);
}

// frame 转换.
+ (void)landscapeExecute:(UIInterfaceOrientation )orien
{
    if(orien == UIInterfaceOrientationLandscapeRight){
        
        webView.transform = CGAffineTransformMakeRotation(M_PI*1.5);
        
    }else if(orien == UIInterfaceOrientationLandscapeLeft){
        
        webView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        
    }
    
    CGRect bounds = CGRectMake(0, 0, CGRectGetHeight(webView.superview.bounds), CGRectGetWidth(webView.superview.bounds));
    CGPoint center = CGPointMake(CGRectGetMidX(webView.superview.bounds),CGRectGetMidY(webView.superview.bounds));
    webView.bounds = bounds;
    webView.center = center;
}



@end
