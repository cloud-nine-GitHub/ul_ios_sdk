//
//  ULQueue.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/24.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULQueue : NSObject
{
   @private
    NSMutableArray *_array;
}

@property (nonatomic,strong) NSMutableArray *array;

- (id)init;
- (void)clear;
- (BOOL)isEmpty;
- (void)enQueue:(id )o;
- (id)deQueue;
- (int)length;
- (id)getFirstObj;
- (id)getLastObj;
@end

NS_ASSUME_NONNULL_END
