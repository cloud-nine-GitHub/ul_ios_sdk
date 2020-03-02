//
//  MCULAppstore.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/28.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "MCULAppstore.h"
#import "ULTools.h"
#import "MCULModuleLayoutCreater.h"
#import "ULCop.h"
#import "ULConfig.h"
#import "ULAdvCallBackManager.h"
#import "ULNotificationDispatcher.h"
#import "ULStringConst.h"
#import "ULNotification.h"
#import "ULModuleBaseSdk.h"

@interface MCULAppstore ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)int y;
@property(nonatomic,strong)UITextView *paramShowText;
@property(nonatomic,strong)NSString *payId;
@property(nonatomic,strong)UITextField* payIdTextField;

@end

@implementation MCULAppstore


-(BOOL)hasNativeAdv
{
    return NO;
}

- (void)initView:(int)floatY
{
    [self addListener];
    _y = floatY;
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, _y, SCREEN_WIDTH, 130)];
    
    _paramShowText = [[UITextView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,60)];
    _paramShowText.text = UL_TEXT_DEFAULT_CALLBACK_INFO;
    _paramShowText.textColor = [UIColor grayColor];
    _paramShowText.backgroundColor = [UIColor whiteColor];
    [_paramShowText setEditable:NO];//设置不可编辑
    [ULTools getCurrentViewController].automaticallyAdjustsScrollViewInsets = NO;//这个属性设置textView文本吸顶显示，TODO是否会产生其他因素待定。这个属性貌似禁用了滑动属性，具体的还需要验证
    
    UILabel *payBaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,100,100,30)];
    payBaseLabel.text = @"appstore支付:";
    payBaseLabel.textColor = [UIColor whiteColor];
    payBaseLabel.font = [UIFont systemFontOfSize:12];
    payBaseLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _payIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,100,100,30)];
    _payIdTextField.tag = 10;
    _payIdTextField.textColor = [UIColor grayColor];
    _payIdTextField.font = [UIFont systemFontOfSize:10];
    _payIdTextField.textAlignment = NSTextAlignmentCenter;
    _payIdTextField.backgroundColor = [UIColor whiteColor];
    //占位文字
    _payIdTextField.placeholder = UL_EDIT_PAYID;
    //当编辑时清空
    _payIdTextField.clearsOnBeginEditing = YES;
    _payIdTextField.delegate = self;
    _payIdTextField.returnKeyType = UIReturnKeyDone;
    [MCULModuleLayoutCreater adjustCenterWithParentView:_view withChildView:_payIdTextField];
    
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,100,100,30)];
    payLabel.text = UL_TEXT_CLICK_PAY;
    payLabel.textColor = [UIColor whiteColor];
    payLabel.font = [UIFont systemFontOfSize:12];
    payLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个点击事件
    UITapGestureRecognizer *payLabelClickR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payLabelClick)];
    [payLabel addGestureRecognizer:payLabelClickR];
    payLabel.userInteractionEnabled = YES; //设置label可被点击
    
    [_view addSubview:_paramShowText];
    [_view addSubview:payBaseLabel];
    [_view addSubview:_payIdTextField];
    [_view addSubview:payLabel];
    
    [self initData];
}

- (void)addListener
{
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK withSelector:@selector(payCallback:) withPriority:-1];
}

- (void)payCallback:(NSNotification *)notification
{
    NSString *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_paramShowText.text = data;
    });
    
}

- (void)initData
{
    _payId = @"";
}


- (void)payLabelClick
{
    NSLog(@"%s%@",__func__,_payId);
    [_payIdTextField resignFirstResponder];
    _paramShowText.text = UL_TEXT_DEFAULT_CALLBACK_INFO;
    if ([_payId isEqualToString:@""]) {
        __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"请先输入计费点" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            alert = nil;
        }];
        return;
    }
    
    NSDictionary *payInfo = [ULTools GetNSDictionaryFromDic:[ULConfig getConfigInfo] :@"s_sdk_pay_appstore_pay_info" :nil];
    
    if ([self checkId:_payId :payInfo]) {
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_OPEN_APPLE_PAY withData:[self getModulePayTestData:_payId]];
    }else{
        __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"该计费点不存在" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            alert = nil;
        }];
    }
    
}



- (int )getViewHeight
{
    return 130;
}

- (UIView *)getView
{
    if (_view) {
        return _view;
    }
    return nil;
}



//delegate



// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%s",__func__);
    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%s",__func__);
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%s",__func__);
    return YES;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%s",__func__);
    
}

// if implemented, called in place of textFieldDidEndEditing:
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    //NSLog(@"%s%@",__func__,textField.text);
}


// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%s",__func__);
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 10:
            _payId = s;
            break;
    }
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField API_AVAILABLE(ios(13.0), tvos(13.0))
{
    NSLog(@"%s",__func__);
}


// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSLog(@"%s",__func__);
    switch (textField.tag) {
        case 10:
            _payId = @"";
            break;
    }
    return YES;
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%s",__func__);
//    switch (textField.tag) {
//        case 10:
//            _payId = textField.text;
//            break;
//
//        case 100:
//            _advId = textField.text;
//        break;
//    }
    return YES;
}
@end


