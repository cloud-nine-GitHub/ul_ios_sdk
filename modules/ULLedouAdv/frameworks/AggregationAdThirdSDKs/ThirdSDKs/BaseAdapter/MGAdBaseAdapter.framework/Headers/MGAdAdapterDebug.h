//
//  MGAdAdapterDebug.h
//  MGAdBaseAdapter
//  
//  Created by alan.xia on 2019/6/12.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MGAAdapter_Log(frmt, ...) if ([MGAdAdapterDebug sharedInstance].debug) NSLog((@"%@[T:0x%x %@ %p] %s:%d " frmt),@"5.0.0",(unsigned int)[NSThread currentThread], ([[NSThread currentThread] isMainThread] ? @"M" : @"S"),self, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

NS_ASSUME_NONNULL_BEGIN

@interface MGAdAdapterDebug : NSObject

@property (nonatomic, assign) BOOL debug;

+ (MGAdAdapterDebug *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
