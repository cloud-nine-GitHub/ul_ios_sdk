//
//  ULQueue.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/24.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULQueue.h"

@implementation ULQueue

- (id)init
{
    if (self == [super init]) {
        _array = [NSMutableArray new];
    }
    return self;
}
- (void)clear
{
    [_array removeAllObjects];
}

- (BOOL)isEmpty
{
    return [_array count] == 0 ? YES : NO;
}

- (void)enQueue:(id )o
{
    [_array addObject:o];
}

- (id)deQueue
{
    if ([_array count] > 0) {
        id item = _array[0];
        [_array removeObjectAtIndex:0];
        return item;
    }
    return nil;
}

- (int)length
{
    return (int)[_array count];
}

- (id)getFirstObj
{
    return [_array firstObject];
}

- (id)getLastObj
{
    return [_array lastObject];
}

@end
