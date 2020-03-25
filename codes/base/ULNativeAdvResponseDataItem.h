//
//  ULNativeAdvResponseDataItem.h
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULINativeAdvItemCallback.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ULNativeAdvResponseDataItem : NSObject
{
    @private
    id _response;
    UIView *_containerView;
    UIView *_clickView;
    id <ULINativeAdvItemCallback> _callback;
    
}

@property (nonatomic,strong) id response;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIView *clickView;
@property (nonatomic,strong) id<ULINativeAdvItemCallback> callback;

- (id)initWithResponse: (id )response;
- (id)initWithResponse: (id )response withContainerView: (UIView *)containerView;
- (id)initWithResponse: (id )response withContainerView: (UIView *)containerView withClickView: (UIView *)clickView;
- (id)initWithResponse: (id )response withContainerView: (UIView *)containerView withClickView: (UIView *)clickView withCallback: (id<ULINativeAdvItemCallback>) callback;


- (void)onClick;
- (void)onDispose;


@end

NS_ASSUME_NONNULL_END
