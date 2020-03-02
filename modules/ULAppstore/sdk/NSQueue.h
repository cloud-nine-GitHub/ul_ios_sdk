//
//  NSQueue.h
//  demo
//
//  Created by 一号机雷兽 on 2019/9/23.
//  Copyright © 2019 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSQueue : NSObject
{
    @private
    NSMutableArray* m_array;
}

- (void)enqueue:(id)anObject;
- (id)dequeue;
- (void)clear;
@property (nonatomic, readonly) int count;

@end

NS_ASSUME_NONNULL_END
