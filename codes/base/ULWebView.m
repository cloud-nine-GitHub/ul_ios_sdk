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
#import <WebKit/WebKit.h>

@interface ULWebView ()<WKUIDelegate,WKNavigationDelegate>

//@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ULWebView

static WKWebView *webView = nil;

+ (void)showWebView:(NSDictionary*)json
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //初始化
        webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:[self getConfiguration]];
        // UI代理
        webView.UIDelegate = (id)self;
        // 导航代理
        webView.navigationDelegate = (id)self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        webView.allowsBackForwardNavigationGestures = YES;
        
        
        
        NSString * url = [ULTools GetStringFromDic:json :@"url" :@""];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [[ULTools getCurrentViewController].view addSubview:webView];
        
        [webView loadRequest:request];
        
        
        
        
        
        NSMutableDictionary *data = [NSMutableDictionary new];
        [ULSDKManager JsonRpcCall:REMSG_CMD_PAUSESOUND :data];
        
        
        UIViewController *controller = [ULTools getCurrentViewController];
        UIInterfaceOrientation orien = controller.interfaceOrientation;
        
        
        
        //默认竖屏展示
        NSString *isForcePortrait = [ULTools getCopOrConfigStringWithKey:@"s_sdk_webview_force_portrait" withDefaultString:@"1"];
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

+ (WKWebViewConfiguration *)getConfiguration
{
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//
//    // 创建设置对象
//    WKPreferences *preference = [[WKPreferences alloc]init];
//    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
//    preference.minimumFontSize = 0;
//    //设置是否支持javaScript 默认是支持的
//    preference.javaScriptEnabled = YES;
//    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    preference.javaScriptCanOpenWindowsAutomatically = YES;
//    config.preferences = preference;
//
//    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
//    config.allowsInlineMediaPlayback = YES;
//    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
//    config.requiresUserActionForMediaPlayback = YES;
//    //设置是否允许画中画技术 在特定设备上有效
//    config.allowsPictureInPictureMediaPlayback = YES;
//    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    
    return config;
    
}


+ (void) addCloseButton:(CGFloat)coordinate
{
    UIButton *closeButton = [UIButton new];
    closeButton.frame = CGRectMake(SCREEN_WIDTH - 30, 5, 25, 25);
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


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s",__func__);
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"%s",__func__);
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSLog(@"%s",__func__);
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%s",__func__);
}
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSLog(@"%s",__func__);
}
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"%s",__func__);
}

#pragma mark - WKUIDelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s",__func__);
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"%s",__func__);
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"%s",__func__);
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"%s",__func__);
    return nil;
}


@end
