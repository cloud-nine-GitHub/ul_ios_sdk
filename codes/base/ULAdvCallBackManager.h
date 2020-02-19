//
//  ULCallBackManager.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/11.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 奖励类型
 */
typedef NS_ENUM(NSUInteger, CallBackType) {
    showed = 1,//展示
    clicked,//点击
    closed,
    failed,
    timeout
};

//@class CallBack;
@interface ULAdvCallBackManager : NSObject
{
    
}

+ (void)callBackExit:(int )code :(NSString *)msg :(NSMutableDictionary *)data;
+ (void)clickCallBack:(int )code :(NSString *)msg :(NSMutableDictionary *)data;
+ (void)callBackEntry :(CallBackType )type :(NSMutableDictionary *)data;
+ (void)init;
+ (void)callBackInit:(NSMutableDictionary *)data;
@end


@interface CallBack : NSObject
{
@private
    CallBackType _type;
    NSMutableDictionary *_data;
}

@property(nonatomic,assign)CallBackType type;
@property(nonatomic,strong)NSMutableDictionary *data;
-(id)initWith:(CallBackType)type :(NSMutableDictionary *)data;
@end



NS_ASSUME_NONNULL_END
