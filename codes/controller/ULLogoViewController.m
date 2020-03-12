//
//  ULLogoViewController.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/26.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import "ULLogoViewController.h"
#import "ULSplashViewController.h"
#import "ULTools.h"

@interface ULLogoViewController ()

@end

@implementation ULLogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    // Do any additional setup after loading the view.
    //初始化，设置坐标
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    logo.alpha = 0.0;
    logo.image = [UIImage imageNamed:@"ul_logo.png"];
    logo.contentMode = UIViewContentModeScaleAspectFill;
    logo.clipsToBounds=YES;
    self.logo = logo;
    [self.view addSubview:logo];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    UIImageView* logo = self.logo;
    
    [UIView animateWithDuration:3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^ {
        logo.alpha = 1.0;
        //        NSLog(@"out animate start");
    }completion:^(BOOL finished) {
        //        NSLog(@"out animate completion");
        //label.alpha = 0.0;
        //next
        [UIView animateWithDuration:1 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^ {
            logo.alpha = 0.0;
            //            NSLog(@"out animate start");
        }completion:^(BOOL finished) {
            //            NSLog(@"out animate completion");
            //label.alpha = 0.0;
            //next
            //部分sdk开屏广告需要rootVC，preset跳转不能正常展示广告
            //            ULSplashViewController* splashViewController = [[ULSplashViewController alloc] init];
            //            //处理ios13新特性，调用present方法会出现折叠视图
            //            splashViewController.modalPresentationStyle = 0;
            //            [self presentViewController:splashViewController animated:false completion:nil];
            
            //这里需要重新设置游戏所在的viewControoler
            
            if (@available(iOS 13.0, *)) {
                //解析工程info.plist文件，判断是否使用分屏特性
                NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
                NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
                NSString *string = [infoDict objectForKey:@"UIApplicationSceneManifest"];
                if (string) {//使用分屏特性
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setRootViewController" object:nil userInfo:@{
                        @"data":@"ULSplashViewController"
                    }];
                    return;
                }
                
                
            }
            
            
            
            UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [UIApplication sharedApplication].delegate.window = window;
            window.backgroundColor = [UIColor whiteColor];
            [window makeKeyAndVisible];
            ULSplashViewController* splashViewController = [[ULSplashViewController alloc] init];
            [window setRootViewController:splashViewController];
            
            //这里需要重新设置游戏所在的viewControoler
            
            
            
        }];
        
        
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
