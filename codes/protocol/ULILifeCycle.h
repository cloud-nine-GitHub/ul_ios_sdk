//
//  ULILifeCycle.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/11/13.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#ifndef ULILifeCycle_h
#define ULILifeCycle_h


#endif /* ULILifeCycle_h */


@protocol ULILifeCycle <NSObject>


- (void)applicationWillResignActive;

- (void)applicationDidEnterBackground;

- (void)applicationWillEnterForeground;

- (void)applicationDidBecomeActive;

- (void)applicationWillTerminate;

- (void)applicationDidReceiveMemoryWarning;

@end
