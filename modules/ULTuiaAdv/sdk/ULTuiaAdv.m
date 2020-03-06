//
//  ULTuiaAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/5.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULTuiaAdv.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JSContext.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULGetDeviceId.h"
#import "ULCmd.h"
#import "ULTimeOut.h"

static NSString * const kDuibaJSH5RewardProtocolTest = @"TAHandlerReward"; // reward测试
static NSString * const kDuibaJSH5CloseProtocolTest = @"TAHandlerClose"; // reward测试
#define BASE_URL @"http://engine.tuibamboo.com/index/activity"

@interface ULTuiaAdv ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *mPrizeFlag;
@property (nonatomic,strong) NSDictionary *urlJson;
@property (nonatomic,assign) BOOL isReward;
@end

@implementation ULTuiaAdv


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
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_TUIA_URL_ADV withSelector:@selector(onShowUrlAdv:) withPriority:PRIORITY_NONE];
}


- (void)onShowUrlAdv :(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showUrlAdv:data];
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


- (void)initModuleAdv
{
    NSLog(@"%s",__func__);
    [self addListener];
    //注册监听消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPrizeFlag:) name:@"getPrizeFlag" object:nil];
    
}

- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_SPLAH,UL_ADV_VIDEO,UL_ADV_BANNER,UL_ADV_EMBEDDED,UL_ADV_FULLSCREEN,UL_ADV_INTERSTITIAL]];
}

- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showInterstitialAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showVideoAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showFullscreenAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showBannerAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showUrlAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _urlJson = json;
    
    _isReward = NO;
    NSString *deviceId = [ULGetDeviceId getUniqueDeviceId];
    NSString *url = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_h5_url" withDefaultString:@""];
    url = [NSString stringWithFormat:@"%@%@%@%@%@",url,@"&device_id=",deviceId,@"&userId=",deviceId];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self pauseSound];
    
    [[ULTools getCurrentViewController].view addSubview:_webView];
    
    [_webView loadRequest:request];
    [_webView setDelegate:self];
    
    
    
    

    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIInterfaceOrientation orien = controller.interfaceOrientation;

    //默认竖屏展示
    NSString *isForcePortrait = [ULTools getCopOrConfigStringWithKey:@"s_sdk_webview_force_portrait" withDefaultString:@"1"];
    if([isForcePortrait isEqualToString:@"1"]){
        if(orien == UIInterfaceOrientationLandscapeLeft || orien == UIInterfaceOrientationLandscapeRight){
            [self landscapeExecute];
            [self addCloseButton:_webView.frame.size.height];
            return;
        }
    }

    
    
    [self addCloseButton:_webView.frame.size.width];
    
    
}

- (void) addCloseButton:(CGFloat)coordinate
{
    UIButton *closeButton = [UIButton new];
    closeButton.frame = CGRectMake(coordinate-30, 5, 25, 25);
    //closeButton.backgroundColor = [UIColor redColor];
    UIImage *image = [UIImage imageNamed:@"close.jpg"];
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(webView.frame.size.width - 35, 0, 35, 35)];
    [closeButton setBackgroundImage:image forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:closeButton];
}






- (void)backButtonAction
{
    NSLog(@"这里执行返回操作");
    //判断是否有上一层H5页面
    if ([_webView canGoBack]) {
        //如果有则返回
        [_webView goBack];
    }else{
        [_webView removeFromSuperview];
        _webView = nil;
        if (!_isReward) {
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TUIA_ADV_CALLBACK withData:@"未达到获奖条件"];
            [self showNextAdv:_urlJson :@"" :@"未达到获奖条件"];
        }
    }

}




#pragma mark webview delegate
- (void)webViewDidStartLoad:(UIWebView  *)webView{
    NSLog(@"%s",__func__);
    [self javaScriptContextSeek:webView];
}

- (void)webViewDidFinishLoad:(UIWebView  *)webView{
    NSLog(@"%s",__func__);
    [self javaScriptContextSeek:webView];
    //[self showAdv:_urlJson :@""];
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:_urlJson :@"gameAdvData" :nil];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:_urlJson :@"sdkAdvData" :nil];
    long advRequestSerialNum = [ULTools GetLongFromDic:sdkAdvData :@"requestSerialNum" :-1];
    NSMutableDictionary *urlData = [NSMutableDictionary new];
    [urlData setValue:advId forKey:@"advId"];
    [urlData setValue:[NSNumber numberWithLong:advRequestSerialNum] forKey:@"requestSerialNum"];
    NSMutableDictionary *rpcCallJsonObj = [NSMutableDictionary new];
    [rpcCallJsonObj setValue:REMSG_CMD_OPENADVRESULT forKey:@"cmd"];
    [rpcCallJsonObj setValue:urlData forKey:@"data"];
    //结束超时任务
    [ULTimeOut stopTimeOutTask:rpcCallJsonObj];
}

- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
    NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%ld",(long)error.code],@" errorMsg = ",error.localizedDescription];
    [self showNextAdv:_urlJson :@"" :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TUIA_ADV_CALLBACK withData:errorMsg];
}


#pragma mark native method for js call
//暴露native方法给js调用
- (void)javaScriptContextSeek:(UIWebView *)webView{
    NSLog(@"%s",__func__);
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //发放奖励
    context[kDuibaJSH5RewardProtocolTest] = ^() {
        NSArray *args = [JSContext currentArguments];
        JSValue *js = args.firstObject;
        id dic =js.toString;
        NSLog(@"%s----dic:%@",__func__,dic);
        if([dic isKindOfClass:[NSString class]]){
            NSDictionary *dictionary = [ULTools StringToDictionary:dic];
            NSString *flag = [ULTools GetStringFromDic:dictionary :@"prizeFlag" :@""];
            NSLog(@"%s----flag:%@",__func__,flag);
            //分发消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPrizeFlag" object:nil userInfo:@{
                                                                                                             @"flag":flag
                                                                                                             }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%s----这里是js调用原生-%@", __func__,kDuibaJSH5RewardProtocolTest);
        });
    };
    //关闭页面
    context[kDuibaJSH5CloseProtocolTest] = ^() {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%s----这里是js调用原生-%@", __func__,kDuibaJSH5CloseProtocolTest);
            [self resumeSound];
            [self->_webView removeFromSuperview];
            self->_webView = nil;
        });
    };
    
}




#pragma mark 控制webview方向旋转
- (void)landscapeExecute{
    _webView.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    CGRect bounds = CGRectMake(0, 0, CGRectGetHeight(_webView.superview.bounds), CGRectGetWidth(_webView.superview.bounds));
    CGPoint center = CGPointMake(CGRectGetMidX(_webView.superview.bounds),CGRectGetMidY(_webView.superview.bounds));
    _webView.bounds = bounds;
    _webView.center = center;
}





- (void)getPrizeFlag:(NSNotification *)notification
{
    NSDictionary *json = notification.userInfo;
    _mPrizeFlag = [json objectForKey:@"flag"];
    NSLog(@"%s----_mPrizeFlag:%@",__func__,_mPrizeFlag);
    NSString *appleId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_app_appleid" :@""];
    if(_mPrizeFlag != nil && [_mPrizeFlag isEqualToString:appleId]){
        [self showAdv:_urlJson :@""];
    }else{
        [self showNextAdv:_urlJson :@"" :@"未达到获奖条件"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TUIA_ADV_CALLBACK withData:@"未达到获奖条件"];
    }
}


- (void)showEmbeddedAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showGiftAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showIconAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)closeAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}


@end
