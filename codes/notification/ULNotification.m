//
//  ULNotification.m
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/10/30.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import "ULNotification.h"

@implementation ULNotification



- (id)initWithNotificationName:(NSString *)name withData:(id _Nullable)param
{
    if (self == [super init]) {
        _name = name;
        _data = param;
    }
    return self;
}


- (void)stopDispatchNotification
{
    _isStopDispatchNotification = YES;
}

@end


