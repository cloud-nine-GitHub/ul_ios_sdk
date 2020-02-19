//
//  ULNotificationListener.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/15.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULNotificationListener : NSObject
{
    @public
    int _priority;
    NSString *_notificationName;
    id _callClassObj;
    BOOL _dispatchOnce;
    BOOL _hasDispatched;
    id _Nullable _extra;
    
}

@property (nonatomic,assign) int priority;
@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,strong) id callClassObj;
@property (nonatomic,assign) BOOL dispatchOnce;
@property (nonatomic,assign) BOOL hasDispatched;
@property (nonatomic,strong) id _Nullable extra;

- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName;
- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName withClassObj:(id )mClassObj;
- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName withClassObj:(id )mClassObj withDispatchOnce: (BOOL )dispatchOnce;
- (id)initWithPriority:(int )priority withNotificationName:(NSString *)notificationName withClassObj:(id )mClassObj withDispatchOnce: (BOOL )dispatchOnce withExtra:(id _Nullable)extra;
@end

NS_ASSUME_NONNULL_END
