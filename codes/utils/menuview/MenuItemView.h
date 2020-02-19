//
//  MenuItemView.h
//  benz-carsign
//
//  Created by topwellsoft_dev2 on 2018/12/25.
//  Copyright © 2018年 ssq-ssq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemView : UIView

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, assign) BOOL titleFrame;



@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) void(^selectedItemBlock)(NSInteger index, NSString *item);
@property (nonatomic, copy) void(^downItemBlock)(BOOL isDown);

@end
