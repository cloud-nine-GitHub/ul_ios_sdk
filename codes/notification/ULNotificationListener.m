//
//  ULNotificationListener.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/15.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULNotificationListener.h"

@implementation ULNotificationListener

- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName
{
    if (self == [super init]) {
        _priority = priority;
        _notificationName = notificationName;
    }
    return self;
}

- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName withClassObj:(id )mClassObj
{
    if (self == [super init]) {
        _priority = priority;
        _notificationName = notificationName;
        _callClassObj = mClassObj;
    }
    return self;
}


- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName withClassObj:(id )mClassObj withDispatchOnce: (BOOL )dispatchOnce
{
    if (self == [super init]) {
        _priority = priority;
        _notificationName = notificationName;
        _callClassObj = mClassObj;
        _dispatchOnce = dispatchOnce;
    }
    return self;
}

- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName withClassObj:(id )mClassObj withDispatchOnce: (BOOL )dispatchOnce withExtra:(id _Nullable)extra
{
    if (self == [super init]) {
        _priority = priority;
        _notificationName = notificationName;
        _callClassObj = mClassObj;
        _dispatchOnce = dispatchOnce;
        _extra = extra;
    }
    return self;
}


@end
