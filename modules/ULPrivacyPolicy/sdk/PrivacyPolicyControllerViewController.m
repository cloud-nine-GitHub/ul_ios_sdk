//
//  PrivacyPolicyControllerViewController.m
//  template-mobile
//
//  Created by 一号机雷兽 on 2019/12/16.
//

#import "PrivacyPolicyControllerViewController.h"
#import "ULTools.h"
#import "PrivacyPolicyPortraitLayout.h"
#import "PirvacyPolicyLandscapeLayout.h"
#import "ULPrivacyPolicy.h"

@interface PrivacyPolicyControllerViewController ()

@property(nonatomic,strong) UIView *parentView,*shelterView;

@end

@implementation PrivacyPolicyControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![ULTools isLandscapeScreen]) {
        self.parentView = [[PrivacyPolicyPortraitLayout getInstance] getPrivacyPolicyParentView];
    }else{
        self.parentView = [[PirvacyPolicyLandscapeLayout getInstance] getPrivacyPolicyParentView];
    }
    self.view = self.parentView;
}



# pragma mark 点击函数



//同意点击事件监听函数
- (void)agreeOnClickEvent{
    NSLog(@"%s",__func__);
    [ULPrivacyPolicy savePrivacyPolicyState:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//拒绝点击事件监听函数
- (void)refuseOnClickEvent{
    NSLog(@"%s",__func__);
    [self showShelterView];
}

- (void) shelterViewOnClick
{
    [self showPrivacyPolicyDialog];
}



- (void) showPrivacyPolicyDialog
{
    self.view = self.parentView;
}


- (void) showShelterView
{
    if (!self.shelterView) {
        [self createShelterView];
    }
    self.view = self.shelterView;
}






- (void) createShelterView
{
    CGRect shelterC = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.shelterView = [[UIView alloc] initWithFrame:shelterC];
    self.shelterView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shelterViewOnClick)];
    [self.shelterView addGestureRecognizer:tapGesturRecognizer];
}

@end
