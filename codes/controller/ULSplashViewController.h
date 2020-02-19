//
//  ULSplashViewController.h
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/26.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULSplashViewController : UIViewController
@property (nonatomic, strong) UILabel* label;

- (void)removeSplashView;
+ (instancetype)getInstance;
@end

NS_ASSUME_NONNULL_END
