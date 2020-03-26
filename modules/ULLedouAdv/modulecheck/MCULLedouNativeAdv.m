//
//  MCULLedouNativeAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "MCULLedouNativeAdv.h"
#import "ULTools.h"
#import "MCULModuleLayoutCreater.h"
#import "ULCop.h"
#import "ULConfig.h"
#import "ULAdvCallBackManager.h"
#import "ULNotificationDispatcher.h"
#import "ULStringConst.h"
#import "ULNotification.h"
#import "ULModuleBaseSdk.h"
#import "MenuItemView.h"
#import "ULModuleBaseAdv.h"
#import "ULAccountType.h"

@interface MCULLedouNativeAdv ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)int y;
@property(nonatomic,strong)UITextView *paramShowText;
@property(nonatomic,strong)NSString *advType,*advParam;
@property(nonatomic,strong)NSArray *advTypeArray;
@property(nonatomic,strong)UITextField* paramTextField;
@end

@implementation MCULLedouNativeAdv


-(BOOL)hasNativeAdv
{
    return NO;
}

- (void)initView:(int)floatY
{
    [self initData];
    [self addListener];
    _y = floatY;
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, _y, SCREEN_WIDTH, 170)];
    
    _paramShowText = [[UITextView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,60)];
    _paramShowText.text = UL_TEXT_DEFAULT_CALLBACK_INFO;
    _paramShowText.textColor = [UIColor grayColor];
    _paramShowText.backgroundColor = [UIColor whiteColor];
    [_paramShowText setEditable:NO];//设置不可编辑
    [ULTools getCurrentViewController].automaticallyAdjustsScrollViewInsets = NO;//这个属性设置textView文本吸顶显示，TODO是否会产生其他因素待定。这个属性貌似禁用了滑动属性，具体的还需要验证
    
    UILabel *advLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,100,100,30)];
    advLabel.text = @"乐逗原生广告:";
    advLabel.textColor = [UIColor whiteColor];
    advLabel.font = [UIFont systemFontOfSize:12];
    advLabel.textAlignment = NSTextAlignmentCenter;
    
    //广告类型选项框
    //这里引入了一个自定义的下拉选项框，后续可用原生的代替
    MenuItemView *advTypeItemSelectView = [[MenuItemView alloc] initWithFrame:CGRectMake(0,100,100,30)];
    advTypeItemSelectView.itemText = UL_TEXT_SELECT_ADV_TYPE;
    advTypeItemSelectView.items = _advTypeArray;
    advTypeItemSelectView.backgroundColor = [UIColor whiteColor];
    advTypeItemSelectView.layer.borderWidth = 1.;
    advTypeItemSelectView.layer.borderColor = [UIColor whiteColor].CGColor;
    advTypeItemSelectView.layer.masksToBounds = YES;
    advTypeItemSelectView.backgroundColor = [UIColor orangeColor];
    //__weak typeof (self) weakSelf = self;
    [advTypeItemSelectView setSelectedItemBlock:^(NSInteger index, NSString *item) {
        self->_advType = item;
        
    }];
    advTypeItemSelectView.backgroundColor = [UIColor clearColor];
    [MCULModuleLayoutCreater adjustCenterWithParentView:_view withChildView:advTypeItemSelectView];
    
    
    
    
    //参数输入框
    _paramTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,100,100,30)];
    _paramTextField.textColor = [UIColor grayColor];
    _paramTextField.font = [UIFont systemFontOfSize:10];
    _paramTextField.textAlignment = NSTextAlignmentCenter;
    _paramTextField.backgroundColor = [UIColor whiteColor];
    //占位文字
    _paramTextField.placeholder = UL_EDIT_ADV_PARAM;
    //当编辑时清空
    _paramTextField.clearsOnBeginEditing = YES;
    _paramTextField.delegate = self;
    _paramTextField.returnKeyType = UIReturnKeyDone;
    
    //展示按钮
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100,140,100,30)];
    showLabel.text = UL_TEXT_CLICK_SHOW;
    showLabel.textColor = [UIColor whiteColor];
    showLabel.font = [UIFont systemFontOfSize:12];
    showLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个点击事件
    UITapGestureRecognizer *showLabelClickR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLabelClick)];
    [showLabel addGestureRecognizer:showLabelClickR];
    showLabel.userInteractionEnabled = YES; //设置label可被点击
    
    [_view addSubview:_paramShowText];
    [_view addSubview:advLabel];
    [_view addSubview:advTypeItemSelectView];
    [_view addSubview:_paramTextField];
    [_view addSubview:showLabel];
    
}

- (void)addListener
{
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_ADV_CALLBACK withSelector:@selector(advCallback:) withPriority:-1];
}

- (void)advCallback:(NSNotification *)notification
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
    _advType = @"";
    _advParam = @"";
    _advTypeArray = @[UL_ADV_INTERSTITIAL,UL_ADV_BANNER,UL_ADV_EMBEDDED];
}


- (void)showLabelClick
{
    [_paramTextField resignFirstResponder];
    _paramShowText.text = UL_TEXT_DEFAULT_CALLBACK_INFO;
    if ([_advType isEqualToString:@""]) {
        __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:@"提示" withDesc:@"请先选择广告类型" withBtnText:@"知道了" withListener:^(UIAlertAction *_Nonnull action){
            [alert dismissViewControllerAnimated:YES completion:nil];
            alert = nil;
        }];
        return;
    }
    NSString *key = @"s_sdk_adv_ledou_nativeid";
    //未输入参数则使用本地默认的参数
    NSMutableDictionary *advData = [self getModuleAdvTestDataWithModule:@"ULLedouNativeAdv" withType:_advType withEditParam:_advParam withLocalParamKey:key];
    [self openAdv:advData];
}

- (void)openAdv:(NSMutableDictionary *)advData
{
    
    //TODO 临时写法(插入未知不合理) 为方便后期统计字段扩展修改
    //广告埋点统计
    NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],@"",@"",@"totalAdvRequest",@"",@"",S_CONST_ADV_MC_ADVID_DES,S_CONST_ADV_MC_ADVID_DES,@"",@""];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
    
    
    
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:advData :@"sdkAdvData" :nil];
    NSString *type = [ULTools GetStringFromDic:sdkAdvData :@"type" :@""];
    
    if([type isEqualToString:UL_ADV_INTERSTITIAL]){
        
        //广告请求统计 对于多参数来说并不知道本次请求的是哪一个参数
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],@"ULLedouNativeAdv",UL_ADV_FULLSCREEN,@"branchAdvRequest",@"",@"",S_CONST_ADV_MC_ADVID_DES,S_CONST_ADV_MC_ADVID_DES,@"",@""];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
        
        if (![[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_INTER_ADV withData:advData]) {
            [MCULModuleLayoutCreater showTipsWithTitile:@"提示" withDesc:@"广告消息未注册,请检查cop是否配置该广告" withBtnText:@"知道了"];
        }
    }else if([type isEqualToString:UL_ADV_BANNER]){
        
        //广告请求统计 对于多参数来说并不知道本次请求的是哪一个参数
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],@"ULLedouNativeAdv",UL_ADV_VIDEO,@"branchAdvRequest",@"",@"",S_CONST_ADV_MC_ADVID_DES,S_CONST_ADV_MC_ADVID_DES,@"",@""];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
        
        if (![[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_BANNER_ADV withData:advData]) {
            [MCULModuleLayoutCreater showTipsWithTitile:@"提示" withDesc:@"广告消息未注册,请检查cop是否配置该广告" withBtnText:@"知道了"];
        }
    }else if([type isEqualToString:UL_ADV_EMBEDDED]){
        
        //广告请求统计 对于多参数来说并不知道本次请求的是哪一个参数
        NSArray *array = @[[NSString stringWithFormat:@"%d",ULA_GAME_ADV_INFO],@"ULLedouNativeAdv",UL_ADV_VIDEO,@"branchAdvRequest",@"",@"",S_CONST_ADV_MC_ADVID_DES,S_CONST_ADV_MC_ADVID_DES,@"",@""];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_ACCOUNT_UP_DATA withData:array];
        
        if (![[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_LEDOU_NATIVE_EMBEDDED_ADV withData:advData]) {
            [MCULModuleLayoutCreater showTipsWithTitile:@"提示" withDesc:@"广告消息未注册,请检查cop是否配置该广告" withBtnText:@"知道了"];
        }
    }
}




- (int )getViewHeight
{
    return 170;
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
    _advParam = s;
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
    _advParam = @"";
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



