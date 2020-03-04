//
//  MGAggregationAdFectchTimeManager.h
//  AggregationAdsComponent
//
//  Created by 夏灵烽 on 2019/10/31.
//  Copyright © 2019 star.liao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGAggregationAdFectchTimeManagerDelegate <NSObject>

- (void)mobgiAdFetchDelay:(NSString *)blockId;

@end


@interface MGAggregationAdFectchTimeManager : NSObject

@property (nonatomic, strong) NSString *blockId;

@property (nonatomic, assign) int loadingTime;

@property (nonatomic, assign) BOOL isRequestTimeout;

@property (nonatomic, assign) id<MGAggregationAdFectchTimeManagerDelegate> delegate;

- (instancetype)initWithBlockId:(NSString *)blockId;

- (void)startFetchDelay;

- (void)cancelFetchDelay;

@end

NS_ASSUME_NONNULL_END
