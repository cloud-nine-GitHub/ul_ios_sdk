//
//  MobGiAdsStateViewController.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/17.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobGiAdsBaseViewController.h"
#import "NetworkAdStateDisplayModel.h"

@interface MobGiAdsStateViewController : MobGiAdsBaseViewController

@property (nonatomic,strong) NSMutableArray<NetworkAdStateDisplayModel*> *tableData;
@property (nonatomic,strong) NSString *blockid;

-(void)dataInit;

@end
