//
//  MobGiBasePresenter.h
//  AggregationAdsComponent
//
//  Created by star.liao on 2018/4/17.
//  Copyright © 2018年 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobGiBasePresenter<E> : NSObject
{
    //用来存储Controller实例或者其它类实例，这里用Xcode7支持的范型特性
    __weak E _view;
}

-(instancetype)initWithView:(E)view;

-(id) getOwer;

-(void)attachView:(E)view;

-(void)detachView;

@end
