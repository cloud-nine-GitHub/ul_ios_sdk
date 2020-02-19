//
//  MCULModuleLayoutCreater.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//
/**
 测试模块uic创建类
 
 */
#import "MCULModuleLayoutCreater.h"
#import "ULTools.h"



@implementation MCULModuleLayoutCreater

+ (UILabel *)getSameUILabelWithRect:(CGRect )rect withContext: (NSString *)context
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = context;
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

//设置view居中
+ (void) adjustCenterWithParentView:(UIView *)parentView withChildView:(UIView *)childView
{
    CGPoint center = parentView.center;
    center.y = childView.frame.origin.y + childView.frame.size.height/2;
    childView.center = center;
}

+ (void)showTipsWithTitile:(NSString *)title withDesc:(NSString *)desc withBtnText:(NSString *)text
{
    __block UIAlertController *alert = [ULTools showSingleBtnDialogWithTitle:title withDesc:desc withBtnText:text withListener:^(UIAlertAction *_Nonnull action){
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    }];
}

@end
