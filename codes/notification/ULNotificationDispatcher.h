//
//  ULNotificationDispatcher.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/12.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULNotificationDispatcher : NSObject
{
    
}


+ (instancetype)getInstance;
- (BOOL)postNotificationWithName :(NSString *)notificationName withData:(id _Nullable)data;
- (void)removeNotificationWithName :(NSString *)notificationName;
- (void)addNotificationWithObserver:(id )classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority;
- (void)addNotificationWithObserver:(id )classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority withExtra:(id _Nullable)extra;
- (void)addNotificationWithObserverOnce:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority;
- (void)addNotificationWithObserverOnce:(id ) classObj withName:(NSString *)notificationName withSelector:(SEL )sel withPriority:(int )priority withExtra:(id _Nullable)extra;

@end

NS_ASSUME_NONNULL_END
