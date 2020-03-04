//
//  MobGiAdsBlockIdsDisplayModel.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/17.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobGiAdsBlockIdsDisplayModel : NSObject

@property (nonatomic,strong) NSString *bid;
@property (nonatomic,strong) NSString *bidDes;
@property (nonatomic,assign) BOOL isServerConfiged;
@property (nonatomic,assign) BOOL isInvalid;

-(instancetype) initWithBid:(NSString*)bid
        bidDes:(NSString*)bidDes;


@end
