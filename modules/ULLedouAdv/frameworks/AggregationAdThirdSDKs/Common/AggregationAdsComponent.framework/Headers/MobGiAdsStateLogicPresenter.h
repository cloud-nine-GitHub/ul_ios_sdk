//
//  MobGiAdsStateLogicPresenter.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/17.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import "MobGiBasePresenter.h"
#import <UIKit/UIKit.h>
#import "NetworkAdStateDisplayModel.h"
#import "MobGiAdsStateTableViewCell.h"

@interface MobGiAdsStateLogicPresenter : MobGiBasePresenter<UIViewController *>

-(void) fillAdStateModel:(NetworkAdStateDisplayModel*)data
forCell:(MobGiAdsStateTableViewCell*)cell;


-(void)showAdForAdName:(NSString*)adName
protocl:(Protocol*)protocl;

-(NSMutableArray<NetworkAdStateDisplayModel*>*)loadingListData:(Protocol*)protocl
bid:(NSString*)bid;

@end
