//
//  PirvacyPolicyLandscapeLayout.m
//  demo
//
//  Created by 一号机雷兽 on 2019/12/14.
//  Copyright © 2019 一号机雷兽. All rights reserved.
//

#import "PirvacyPolicyLandscapeLayout.h"
#import "ULTools.h"
#import "ULPrivacyPolicy.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import <WebKit/WebKit.h>


@implementation PirvacyPolicyLandscapeLayout


static PirvacyPolicyLandscapeLayout *instance = nil;

+ (id) getInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (instance == nil) {
            instance = [[PirvacyPolicyLandscapeLayout alloc] init];
        }
    });
    return instance;
    
}

- (UIView *)getPrivacyPolicyParentView
{
    /*最外层父布局*/
    UIView *parentView = [[UIView alloc] initWithFrame:[ULTools getCurrentViewController].view.bounds];
    parentView.backgroundColor = [UIColor clearColor];
    
    /*第一层相对布局*/
    UIView *relative = [[UIView alloc] initWithFrame:parentView.bounds];
    relative.backgroundColor = [UIColor whiteColor];
    //根据横竖屏设置边距
    [relative setTranslatesAutoresizingMaskIntoConstraints:NO];//将使用AutoLayout的方式布局
    NSLayoutConstraint *constraintTop,*constraintLeft,*constraintRight,*constraintBottom;
    
    constraintTop = [NSLayoutConstraint constraintWithItem:relative attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:30];
    constraintLeft = [NSLayoutConstraint constraintWithItem:relative  attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:100];
    constraintRight = [NSLayoutConstraint constraintWithItem:parentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:relative attribute:NSLayoutAttributeRight multiplier:1.0 constant:100];
    constraintBottom = [NSLayoutConstraint constraintWithItem:parentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:relative attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30];
    
    
    //将约束添加到父视图中
    [parentView addConstraint:constraintTop];
    [parentView addConstraint:constraintLeft];
    [parentView addConstraint:constraintRight];
    [parentView addConstraint:constraintBottom];
    //设置圆角
    relative.layer.cornerRadius = 25;
    relative.layer.masksToBounds = YES;
    [parentView addSubview:relative];
    
    
    /*第二层相对布局*/
    UIView *relativeTwo = [[UIView alloc] initWithFrame:relative.bounds];
    //relativeTwo.backgroundColor = UIColor.yellowColor;
    //根据横竖屏设置边距
    [relativeTwo setTranslatesAutoresizingMaskIntoConstraints:NO];//将使用AutoLayout的方式布局
    NSLayoutConstraint *constraintTwoTop,*constraintTwoLeft,*constraintTwoRight,*constraintTwoBottom;
    
    constraintTwoTop = [NSLayoutConstraint constraintWithItem:relativeTwo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:relative attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
    constraintTwoLeft = [NSLayoutConstraint constraintWithItem:relativeTwo  attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:relative attribute:NSLayoutAttributeLeft multiplier:1.0 constant:30];
    constraintTwoRight = [NSLayoutConstraint constraintWithItem:relative attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:relativeTwo attribute:NSLayoutAttributeRight multiplier:1.0 constant:30];
    constraintTwoBottom = [NSLayoutConstraint constraintWithItem:relative attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:relativeTwo attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    
    
    //将约束添加到父视图中
    [relative addConstraint:constraintTwoTop];
    [relative addConstraint:constraintTwoLeft];
    [relative addConstraint:constraintTwoRight];
    [relative addConstraint:constraintTwoBottom];
    [relative addSubview:relativeTwo];
    
    
    /*webview*/
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [ULTools getCurrentViewController].view.bounds.size.width-260, [ULTools getCurrentViewController].view.bounds.size.height-150) configuration:[self getConfiguration]];
    // 隐藏右侧下侧滚动条、隐藏边界黑色图片
    for (UIView *_aView in [webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            // 隐藏右侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            // 隐藏下侧的滚动条
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  // 隐藏上下滚动出边界时的黑色图片
                    
                }
            }
        }
    }
    // 避免WebView最下方出现黑线
    webView.backgroundColor = [UIColor clearColor];
    
    //加载网页
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:UL_PRIVACY_POLICY_URL]];
    [webView loadRequest:request];
    [relativeTwo addSubview:webView];
    /*底部按钮相对布局*/
    UIView *relativeBtn = [[UIView alloc] initWithFrame:CGRectMake(0, [ULTools getCurrentViewController].view.bounds.size.height-150, [ULTools getCurrentViewController].view.bounds.size.width-260, 60)];
    //relativeBtn.backgroundColor = UIColor.redColor;
    [relativeTwo addSubview:relativeBtn];
    
    /*webview与布局按钮的分界线*/
    UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(0, 3, [ULTools getCurrentViewController].view.bounds.size.width-260, 1)];
    divideLine.backgroundColor = [UIColor grayColor];
    [relativeBtn addSubview:divideLine];
    
    
    /*同意按钮背景图片**/
    UIImageView *agreeImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, [ULTools getCurrentViewController].view.bounds.size.width-350, 36)];
    agreeImgView.image=[UIImage imageNamed:@"ul_privacy_policy_agree_btn_bg.png"];
    agreeImgView.contentMode = UIViewContentModeScaleToFill;
    [relativeBtn addSubview:agreeImgView];
    //在父控件水平居中
    [ULTools adjustCenterH:agreeImgView :relativeBtn];
    /*同意按钮**/
    UILabel *agree = [UILabel new];
    agree.userInteractionEnabled = YES;
    agree.backgroundColor = UIColor.clearColor;
    agree.frame = CGRectMake(0, 12, [ULTools getCurrentViewController].view.bounds.size.width-260, 32);
    agree.text = @"同意，继续游戏";
    agree.font = [UIFont systemFontOfSize:18];
    agree.textColor = UIColor.whiteColor;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeOnClick)];
    [agree addGestureRecognizer:tapGesturRecognizer];
    //点击排他性属性设置，避免用户两个按钮同时点击都会响应
    agree.exclusiveTouch = YES;
    agree.textAlignment = NSTextAlignmentCenter;
    [relativeBtn addSubview:agree];
    
    /*拒绝按钮**/
    UILabel *refuse = [UILabel new];
    refuse.text=@"不同意，仅浏览";
    refuse.userInteractionEnabled = YES;
    //refuse.backgroundColor = UIColor.clearColor;
    refuse.font = [UIFont systemFontOfSize:15];
    //设置控件宽高自适应文本
    CGSize size = [refuse.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:refuse.font,NSFontAttributeName,nil]];
    CGFloat refuseHeight = size.height;
    CGFloat refuseWidth = size.width;
    refuse.frame = CGRectMake(0,45, refuseWidth,refuseHeight);
    UITapGestureRecognizer *refuseTapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refuseOnClick)];
    [refuse addGestureRecognizer:refuseTapGesturRecognizer];
    //点击排他性属性设置，避免用户两个按钮同时点击都会响应
    refuse.exclusiveTouch = YES;
    //添加下划线
    NSDictionary * underAttribtDic  = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor grayColor]};
    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:refuse.text attributes:underAttribtDic];
    refuse.attributedText = underAttr;
    [relativeBtn addSubview:refuse];
    //在父控件水平居中
    [ULTools adjustCenterH:refuse :relativeBtn];
    return parentView;
}

- (WKWebViewConfiguration *)getConfiguration
{
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    //网页自适应大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    return config;
    
}


//同意点击事件监听函数
- (void)agreeOnClick{
    [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_PRIVACY_POLICY_AGREE_LISTENER withData:nil];
}

//拒绝点击事件监听函数
- (void)refuseOnClick{
    [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_PRIVACY_POLICY_REFUSE_LISTENER withData:nil];
}

@end
