//
//  ULTimer.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/11.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 定时器工具函数
 */
@interface ULTimer : NSObject

{
    
}

+ (instancetype)getInstance;
-(id)init;
- (void)startTimerWithName:(NSString *)timerLogo withTarget:(id )target withTime:(float )time withSel:(SEL )selector withUserInfo:(id _Nullable)userInfo withRepeat:(BOOL )isRepeat;
- (NSTimer *)createTimerWithName:(NSString *)timerLogo withTarget:(id )target withTime:(float )time withSel:(SEL )selector withUserInfo:(id _Nullable)userInfo withRepeat:(BOOL )isRepeat;
- (void)destroyTimerWithName:(NSString *)timerLogo;
- (void)stopTimerWithName:(NSString *)timerLogo;
- (void)restartTimerWithName:(NSString *)timerLogo;
- (BOOL)hasTimerWithName:(NSString *)timerLogo;

@end

NS_ASSUME_NONNULL_END
