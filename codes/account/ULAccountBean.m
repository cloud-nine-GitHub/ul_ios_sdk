//
//  ULAccountBean.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/22.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULAccountBean.h"

@implementation ULAccountBean


-(id)initWithId:(long )upDataId andUpData:(NSString *)upData
{
    
    if (self = [super init]) {
        _upDataId = upDataId;
        _upData = upData;
    }
    return self;
    
}


@end
