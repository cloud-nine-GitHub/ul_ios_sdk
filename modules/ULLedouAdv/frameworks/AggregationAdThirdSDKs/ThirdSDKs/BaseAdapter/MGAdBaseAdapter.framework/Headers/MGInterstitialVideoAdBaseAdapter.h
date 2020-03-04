//
//  MGInterstitialVideoAdBaseAdapter.h
//  MGAdBaseAdapter
//
//  Created by alan.xia on 2019/7/15.
//  Copyright © 2019年 Lingfeng.Xia. All rights reserved.
//

#import "MGAdBaseAdapterCommon.h"
#import "MGInterstitialVideoAdAdapterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGInterstitialVideoAdBaseAdapter : MGAdBaseAdapterCommon

@property (nonatomic, weak) id<MGInterstitialVideoAdAdapterDelegate> delegate;

@property (nonatomic, assign) BOOL  isSkip;

- (void)thirdDidClickSkip:(NSString *)placementID;

@end

NS_ASSUME_NONNULL_END
