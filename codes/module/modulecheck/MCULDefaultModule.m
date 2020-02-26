//
//  MCULDefaultModule.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import "MCULDefaultModule.h"
#import "ULTools.h"
#import "MCULModuleLayoutCreater.h"
#import "ULCop.h"
#import "ULConfig.h"
#import "ULAdvCallBackManager.h"
#import "ULNotificationDispatcher.h"
#import "ULStringConst.h"
#import "ULNotification.h"
#import "ULModuleBaseSdk.h"
#import "ULAccountType.h"

@interface MCULDefaultModule ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)int y;
@property(nonatomic,strong)UITextView *paramShowText;
@property(nonatomic,strong)NSString *advId,*payId;
@property(nonatomic,strong)UITextField *payIdTextField,*advIdTextField;

@end

@implementation MCULDefaultModule


-(BOOL)hasNativeAdv
{
    return NO;
}

- (void)initView:(int)floatY
{
    _y = floatY;
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, _y, SCREEN_WIDTH, 410)];
    //--------参数文本显示view
    _paramShowText = [[UITextView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,250)];
    _paramShowText.text = UL_TEXT_PARAMS_CONFIG_DEFAULT;
    _paramShowText.textColor = [UIColor grayColor];
    _paramShowText.backgroundColor = [UIColor whiteColor];
    [_paramShowText setEditable:NO];//设置不可编辑
    [ULTools getCurrentViewController].automaticallyAdjustsScrollViewInsets = NO;//这个属性设置textView文本吸顶显示，TODO是否会产生其他因素待定。这个属性貌似禁用了滑动属性，具体的还需要验证
    
    UILabel *paramsConfigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,290,100,30)];
    paramsConfigLabel.text = UL_TEXT_PARAMS_CONFIG_NAME;
    paramsConfigLabel.textColor = [UIColor whiteColor];
    paramsConfigLabel.font = [UIFont systemFontOfSize:12];
    paramsConfigLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *localParamsConfigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,290,100,30)];
    localParamsConfigLabel.text = UL_TEXT_LOCAL_CONFIG_NAME;
    localParamsConfigLabel.textColor = [UIColor whiteColor];
    localParamsConfigLabel.font = [UIFont systemFontOfSize:12];
    localParamsConfigLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个点击事件
    UITapGestureRecognizer *localLabelClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(localParamsConfigLabelClick)];
    [localParamsConfigLabel addGestureRecognizer:localLabelClick];
    localParamsConfigLabel.userInteractionEnabled = YES; //设置label可被点击
    [MCULModuleLayoutCreater adjustCenterWithParentView:_view withChildView:localParamsConfigLabel];
    
    UILabel *copParamsConfigLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,290,100,30)];
    copParamsConfigLabel.text = UL_TEXT_COP_CONFIG_NAME;
    copParamsConfigLabel.textColor = [UIColor whiteColor];
    copParamsConfigLabel.font = [UIFont systemFontOfSize:12];
    copParamsConfigLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个点击事件
    UITapGestureRecognizer *copLabelClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copParamsConfigLabelClick)];
    [copParamsConfigLabel addGestureRecognizer:copLabelClick];
    copParamsConfigLabel.userInteractionEnabled = YES; //设置label可被点击
    
    //-----支付流程ui
    UILabel *payBaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,330,100,30)];
    payBaseLabel.text = UL_TEXT_BASE_PAY;
    payBaseLabel.textColor = [UIColor whiteColor];
    payBaseLabel.font = [UIFont systemFontOfSize:12];
    payBaseLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _payIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,330,100,30)];
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
    
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,330,100,30)];
    payLabel.text = UL_TEXT_CLICK_PAY;
    payLabel.textColor = [UIColor whiteColor];
    payLabel.font = [UIFont systemFontOfSize:12];
    payLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个点击事件
    UITapGestureRecognizer *payLabelClickR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payLabelClick)];
    [payLabel addGestureRecognizer:payLabelClickR];
    payLabel.userInteractionEnabled = YES; //设置label可被点击
    
    //-----广告流程ui
    UILabel *advBaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,380,100,30)];
    advBaseLabel.text = UL_TEXT_BASE_ADV;
    advBaseLabel.textColor = [UIColor whiteColor];
    advBaseLabel.font = [UIFont systemFontOfSize:12];
    advBaseLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _advIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,380,100,30)];
    _advIdTextField.tag = 100;
    _advIdTextField.textColor = [UIColor grayColor];
    _advIdTextField.font = [UIFont systemFontOfSize:10];
    _advIdTextField.textAlignment = NSTextAlignmentCenter;
    _advIdTextField.backgroundColor = [UIColor whiteColor];
    //占位文字
    _advIdTextField.placeholder = UL_EDIT_ADVID;
    //当编辑时清空
    _advIdTextField.clearsOnBeginEditing = YES;
    _advIdTextField.delegate = self;
    _advIdTextField.returnKeyType = UIReturnKeyDone;
    [MCULModuleLayoutCreater adjustCenterWithParentView:_view withChildView:_advIdTextField];
    
    
    UILabel *advShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,380,100,30)];
    advShowLabel.text = UL_TEXT_CLICK_SHOW;
    advShowLabel.textColor = [UIColor whiteColor];
    advShowLabel.font = [UIFont systemFontOfSize:12];
    advShowLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个点击事件
    UITapGestureRecognizer *advShowLabelClickR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advShowLabelClick)];
    [advShowLabel addGestureRecognizer:advShowLabelClickR];
    advShowLabel.userInteractionEnabled = YES; //设置label可被点击
    
    
    [_view addSubview:_paramShowText];
    [_view addSubview:paramsConfigLabel];
    [_view addSubview:localParamsConfigLabel];
    [_view addSubview:copParamsConfigLabel];
    [_view addSubview:payBaseLabel];
    [_view addSubview:_payIdTextField];
    [_view addSubview:payLabel];
    [_view addSubview:advBaseLabel];
    [_view addSubview:_advIdTextField];
    [_view addSubview:advShowLabel];
    
    [self initData];
}

- (void)initData
{
    _advId = @"";
    _payId = @"";
}


- (void)copParamsConfigLabelClick
{
    _paramShowText.text = [ULCop getCopInfoString];
}

- (void)localParamsConfigLabelClick
{
    _paramShowText.text = [ULConfig getConfigInfoString];
}

- (void)advShowLabelClick
{
    NSLog(@"%s%@",__func__,_advId);
    //关闭输入键盘
    [_advIdTextField resignFirstResponder];
    if ([_advId isEqualToString:@""]) {
        __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"请先输入广告位" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            alert = nil;
        }];
        return;
    }
    [self openAdv:[self getBaseAdvTestData:_advId]];
}


- (void)openAdv:(NSMutableDictionary*)advData
{
    [ULAdvCallBackManager callBackInit:advData];
    NSDictionary *gameAdvData = [advData objectForKey:@"gameAdvData"];
    NSString *advId = [ULTools GetStringFromDic:gameAdvData :@"advId" :@""];
    
    //广告埋点统计
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],@"",@"",@"totalAdvRequest",@"",@"",advId,advId,@"",@""];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    //开始调用聚合流程
    [[ULNotificationDispatcher getInstance] postNotificationWithName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_PREPARE_SHOW_ADV_BASE,advId]  withData:advData];
    
    BOOL hasShowAdv = [[ULNotificationDispatcher getInstance] postNotificationWithName:[[NSString alloc]initWithFormat:@"%@%@",UL_NOTIFICATION_SHOW_ADV_BASE,advId] withData:advData];
    
    if (!hasShowAdv) {
        if ([advId isEqualToString:S_CONST_ADV_SPLASH_ADVID_DES]) {
            __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"测试界面暂不支持开屏广告调用" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
                [alert dismissViewControllerAnimated:YES completion:nil];
                alert = nil;
            }];
        }else{
            [ULAdvCallBackManager callBackExit:0 :S_CONST_ADV_FAIL_DES :advData];
        }
    }
}



- (void)payLabelClick
{
    NSLog(@"%s%@",__func__,_payId);
    //关闭输入键盘
    [_payIdTextField resignFirstResponder];
    if ([_payId isEqualToString:@""]) {
        __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"请先输入计费点" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            alert = nil;
        }];
        return;
    }
    [self openPay:[self getBasePayTestData:_payId]];
}

- (void)openPay:(NSMutableDictionary*)payData
{
    NSDictionary *gamePayData = [payData objectForKey:@"gamePayData"];
    NSString *payId = [ULTools GetStringFromDic:gamePayData :@"payId" :@""];
    int payPolicy = [ULModuleBaseSdk getBasePayInfoPolicyWithPayId:payId];
    switch (payPolicy) {
        case PAY_POLICY_DEFAULT:
        default:
            //先通知做好支付准备。初始化模块支付消息等
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_PREOPEN_PAY withData:payData];
            
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_OPEN_PAY withData:payData];
            break;
        case PAY_POLICY_ULPAY:
            
            break;
    }
}

- (int )getViewHeight
{
    return 410;
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

        case 100:
            _advId = s;
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

        case 100:
            _advId = @"";
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
