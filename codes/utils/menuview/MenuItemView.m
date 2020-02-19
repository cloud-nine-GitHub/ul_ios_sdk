//
//  MenuItemView.m
//  benz-carsign
//
//  Created by topwellsoft_dev2 on 2018/12/25.
//  Copyright © 2018年 ssq-ssq. All rights reserved.
//

#import "MenuItemView.h"
#import "HEMenu.h"
#import "UIView+MJExtension/UIView+MJExtension.h"


@interface MenuItemView ()
@property (nonatomic, strong) UIView *itemView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *arrowMark;
@end

@implementation MenuItemView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *itemView = [[UIView alloc] init];
        [self addSubview:itemView];
        _itemView = itemView;
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:13];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        [itemView addSubview:title];
        _title = title;
        
        // 旋转尖头
        UIImageView *arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(itemView.frame.size.width - 15, 0, 12, 12)];
        arrowMark.mj_centerY = itemView.mj_h/2.;
        arrowMark.image  = [UIImage imageNamed:@"arrow_down_icon"];
       // [arrowMark sizeToFit];
        [itemView addSubview:arrowMark];
        _arrowMark = arrowMark;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 44, 100, 35);
        [btn addTarget:self action:@selector(dropClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:@"请选择" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [itemView addSubview:btn];
        _btn = btn;
        
        
    }
    
    return self;
}



- (void)setItemText:(NSString *)itemText{
    _itemText = itemText;
//    [_btn setTitle:itemText forState:UIControlStateNormal];
    _title.text = itemText;

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _itemView.frame = self.frame;
    _itemView.backgroundColor = [UIColor clearColor];
    _itemView.mj_x = 0;
    _itemView.mj_y = 0;
    
    _title.frame = self.frame;
    _title.mj_w = self.frame.size.width - 25;
    _title.mj_y = 0;
    _title.mj_x = 10;
    
//    if (_titleFrame) {
//        _title.mj_x = 10;;
//        _title.mj_w = self.frame.size.width - 25;
//
//    }
    
    _arrowMark.mj_x = _itemView.frame.size.width - 15;
    _arrowMark.mj_centerY = _itemView.mj_h/2.;
    
    _btn.frame = _itemView.frame;
    _btn.backgroundColor = [UIColor clearColor];
}


- (void)dropClick:(UIButton *)sender{
    
    if (self.items.count == 0) {
        !self.downItemBlock?:self.downItemBlock(YES);
        return;
    }
    !self.downItemBlock?:self.downItemBlock(NO);

    
    
//    NSArray *titles = @[@"发起群聊",@"添加朋友",@"扫一扫",@"收付款"];
    __weak typeof (self) weakself = self;
    [[HEMenu shareManager] showPopMenuSelecteWithFrameWidth:self.mj_w height:40*5 point:CGPointMake(self.right - 9, self.frame.origin.y - 20) item:_items imgSource:nil action:^(NSInteger index) {
        NSLog(@"%ld", index);
//        [weakself.btn setTitle:weakself.items[index] forState:UIControlStateNormal];
        weakself.title.text = weakself.items[index];
        !weakself.selectedItemBlock?:weakself.selectedItemBlock(index,weakself.items[index]);
        [weakself down];
    } hideBlock:^(BOOL ishide) {//隐藏
        if (ishide) {
            [weakself down];
        }else{
            [weakself up];
        }
    }];
}

- (void)up{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)down{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.arrowMark.transform = CGAffineTransformIdentity;
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)setBgColor:(UIColor *)bgColor{
    _itemView.backgroundColor = bgColor;
}

- (void)setTintColor:(UIColor *)tintColor{
    _title.tintColor = tintColor;
}

- (void)setFontColor:(UIColor *)fontColor{
    _title.textColor = fontColor;
}


@end
