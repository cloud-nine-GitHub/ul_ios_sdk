//
//  MCULAccountTask.m
//  ulsdkgamedemo
//
//  Created by ul_macbookpro01 on 2020/4/2.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "MCULAccountTask.h"
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
#import "ULAccountTask.h"

@interface MCULAccountTask ()

@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)int y;
@property(nonatomic,strong)NSMutableArray *pointEventArray;
@end

@implementation MCULAccountTask


-(BOOL)hasNativeAdv
{
    return NO;
}

- (void)initView:(int)floatY
{
    [self initData];

    _y = floatY;
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, _y, SCREEN_WIDTH, 50)];
    
    UILabel *advLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20,100,30)];
    advLabel.text = @"打点统计记录:";
    advLabel.textColor = [UIColor whiteColor];
    advLabel.font = [UIFont systemFontOfSize:12];
    advLabel.textAlignment = NSTextAlignmentCenter;
    
    //广告类型选项框
    //这里引入了一个自定义的下拉选项框，后续可用原生的代替
    MenuItemView *advTypeItemSelectView = [[MenuItemView alloc] initWithFrame:CGRectMake(0,20,100,30)];
    advTypeItemSelectView.itemText = @"点击查看";
    advTypeItemSelectView.items = _pointEventArray;
    advTypeItemSelectView.backgroundColor = [UIColor whiteColor];
    advTypeItemSelectView.layer.borderWidth = 1.;
    advTypeItemSelectView.layer.borderColor = [UIColor whiteColor].CGColor;
    advTypeItemSelectView.layer.masksToBounds = YES;
    advTypeItemSelectView.backgroundColor = [UIColor orangeColor];
    //__weak typeof (self) weakSelf = self;
    [advTypeItemSelectView setSelectedItemBlock:^(NSInteger index, NSString *item) {
        
        
    }];
    advTypeItemSelectView.backgroundColor = [UIColor clearColor];
    [MCULModuleLayoutCreater adjustCenterWithParentView:_view withChildView:advTypeItemSelectView];
    
    

    [_view addSubview:advLabel];
    [_view addSubview:advTypeItemSelectView];
    
}



- (void)initData
{
    _pointEventArray = [NSMutableArray new];
    NSMutableDictionary *pointEventDic = [ULAccountTask getPointEventDic];
    if (!pointEventDic) {
        
        [_pointEventArray addObject:@"暂无打点数据"];
    }else{
        //遍历整个字典
        for (NSString *key in [pointEventDic allKeys]) {
            id value = [pointEventDic objectForKey:key];
            int valueInt = [value intValue];
            NSString *str = [[NSString alloc] initWithFormat:@"%@%@%d",key,@":",valueInt];
            [_pointEventArray addObject:str];
        }
    }
    
}


- (int )getViewHeight
{
    return 50;
}

- (UIView *)getView
{
    if (_view) {
        return _view;
    }
    return nil;
}

@end

