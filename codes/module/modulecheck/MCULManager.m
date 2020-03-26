//
//  MCULManager.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/17.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

/**
 测试界面(金手指)管理函数
    该界面应该在主controller展现后才能调用，当前监听时间较早，支持再这之前的controller展现，但是会出问题
 */
#import "MCULManager.h"
#import "ULTimer.h"
#import <UIKit/UIKit.h>
#import "ULTools.h"
#import "ULConfig.h"
#import "MCULBase.h"

static NSString *const MC_CLICK_PASSWORD = @"+-+-++--";
static int const MC_CLICK_TIME_LIMIT = 2;
static NSString *const MODULE_CHECK_NAME_PREFIX = @"MC";

@implementation MCULManager

static NSString *passWord = @"";
static BOOL isInit = NO;//初始化函数标示符
static NSMutableArray *clickTimeArray;
static int clickCount = 0;//音量按键点击次数记录
static BOOL isCreated = NO;//ui创建标识符
static UIScrollView *scrollView = nil;//测试界面父布局
static int layoutHightCount = 0;//各空间高度计数
static NSMutableArray *moduleObjList = nil;

+ (void)init
{
    if (!isInit) {//只创建一次
        clickTimeArray = [NSMutableArray new];
    }
}

+ (void)volumeChangeListenerWithBtn:(NSString *)btn
{
    passWord = [[NSString alloc] initWithFormat:@"%@%@",passWord,btn];
    NSLog(@"%s%@%@",__func__,@"当前音量按键触发:",passWord);
    isInit = YES;
    [clickTimeArray insertObject:@"0" atIndex:0];//默认值为0，初始状态
    //每触发一次就记录一次
    clickCount++;
    if (clickCount == 1) {
        NSLog(@"%s%@",__func__,@"测试界面开始触发");
        //点击过程点击密码不符合5s后重置
        [[ULTimer getInstance]startTimerWithName:@"ul_module_check_click_reset" withTarget:self withTime:5.0 withSel:@selector(reset:) withUserInfo:nil withRepeat:NO];
        NSDate *datenow = [NSDate date];//当前时间戳，单位s
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        [clickTimeArray insertObject:timeSp atIndex:1];
    }
    if (clickCount == 8) {
        NSDate *datenow = [NSDate date];//当前时间戳，单位s
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        [clickTimeArray insertObject:timeSp atIndex:8];
        NSString *index8 = clickTimeArray[8];
        NSString *index1 = clickTimeArray[1];
        if (([index8 longLongValue] - [index1 longLongValue] <= MC_CLICK_TIME_LIMIT) && [passWord isEqualToString:MC_CLICK_PASSWORD]) {
            if (!isCreated) {
                [self createModuleCheckLayout];
            }else{
                NSLog(@"%s%@",__func__,@"测试界面禁止重复创建");
            }
        }else{
            NSLog(@"%s%@",__func__,@"测试界面触发无效");
            clickCount = 0;
            passWord = @"";
        }
    }
    
    if (clickCount > 8) {
        if (isCreated) {
            NSLog(@"%s%@",__func__,@"测试界面已存在，后续触发无效");
        }else{
            clickCount = 0;
            passWord = @"";
        }
    }
    
}

+ (void)reset:(ULTimer *)timer
{
    NSLog(@"%s",__func__);
    if (!isCreated) {
        clickCount = 0;
        passWord = @"";
    }
}

//创建测试界面ui
+ (void)createModuleCheckLayout
{
    NSLog(@"%s",__func__);
    if (isCreated) {
        NSLog(@"%s%@",__func__,@"测试界面禁止重复创建");
        return;
    }
    isCreated = YES;
    //TODO 这里有个问题：demo也是用的scrollView，两个的滑动事件会冲突
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //1.获取所有模块对应的高度来优先设置父布局高度
    //默认添加点击按钮高度
    layoutHightCount = 20+40;
    moduleObjList = [self getMcModuleObjList];
    for (MCULBase *moduleObj in moduleObjList) {
        layoutHightCount = layoutHightCount + [moduleObj getViewHeight];
    }
    
    layoutHightCount = layoutHightCount + 300;
    
    if (layoutHightCount < SCREEN_HEIGHT) {
        layoutHightCount = SCREEN_HEIGHT;
    }
    scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width,layoutHightCount);
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    [[ULTools getCurrentViewController].view addSubview:scrollView];
    //2.开始按模块添加view
    [self addView];
    
    //3.添加通用结束模块填充
    UILabel *end = [[UILabel alloc] initWithFrame:CGRectMake(0,layoutHightCount-300,SCREEN_WIDTH,300)];
    end.text = @"----------我是有底线的----------";
    end.textColor = [UIColor grayColor];
    end.font = [UIFont systemFontOfSize:12];
    end.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:end];
}

+ (void)addView
{
    //添加退出按钮
    UIButton *exit = [UIButton new];
    exit.backgroundColor = [UIColor whiteColor];
    exit.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    [exit setTitle:@"退出测试界面" forState:UIControlStateNormal];
    [exit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:exit];

    //添加其他模块
    for (MCULBase *moduleObj in moduleObjList) {
        [scrollView addSubview:[moduleObj getView]];
    }
    
    
    
    
}

//获取测试模块显示列表:禁止重复创建同一个对象
+ (NSMutableArray *)getMcModuleObjList
{
    NSArray *moduleList = [ULConfig getModuleList];
    NSMutableArray *mcModuleList = [NSMutableArray new];
    for (NSString *module in moduleList) {
        NSString *mcModule = [[NSString alloc] initWithFormat:@"%@%@",MODULE_CHECK_NAME_PREFIX,module];
        Class class = NSClassFromString(mcModule);
        if (!class) {
            NSLog(@"%s%@%@%@",__func__,@"未找到测试模块中对应的:【",mcModule,@"】模块！");
        }else{
            [mcModuleList addObject:mcModule];
        }
    }
    
    int height = 60;
    NSMutableArray *mcModuleObjList = [NSMutableArray new];
    for (NSString *mcModule in mcModuleList) {
        Class class = NSClassFromString(mcModule);
        //测试模块对象创建
        MCULBase *classObj = [[class alloc] initWithY:height];
        [mcModuleObjList addObject:classObj];
        height = height + [classObj getViewHeight];
        
        if ([classObj hasNativeAdv]) {//当前测试模块包含原生广告，那么对应的原生模块也需要创建相应的对象
            NSString *mcNativeModule = [mcModule stringByReplacingOccurrencesOfString:@"Adv" withString:@"NativeAdv"];
            Class nativeClass = NSClassFromString(mcNativeModule);
            if (nativeClass) {
                //测试模块对象创建
                MCULBase *nativeClassObj = [[nativeClass alloc] initWithY:height];
                [mcModuleObjList addObject:nativeClassObj];
                
                height = height + [nativeClassObj getViewHeight];
            }else{
                NSLog(@"%s%@%@%@",__func__,@"未找到测试模块中对应的原生模块:【",mcNativeModule,@"】模块！");
            }
            
        }
    }
    return mcModuleObjList;
}


//退出按钮点击函数
+ (void)exit
{
    NSLog(@"%s%@",__func__,@"退出测试界面");
    [scrollView removeFromSuperview];
    isCreated = NO;
    clickCount = 0;
    passWord = @"";
    layoutHightCount = 0;
}

@end
