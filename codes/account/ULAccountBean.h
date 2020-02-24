//
//  ULAccountBean.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/22.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 
 将每条数据封装为一个对象
 
 */
NS_ASSUME_NONNULL_BEGIN

@interface ULAccountBean : NSObject
{
    NSString *_upData;  //数据
    long _upDataId; //排序ID
    
}


@property (nonatomic,strong) NSString *upData;
@property (nonatomic,assign) long upDataId;


-(id)initWithId:(long )upDataId andUpData:(NSString *)upData;
@end

NS_ASSUME_NONNULL_END
