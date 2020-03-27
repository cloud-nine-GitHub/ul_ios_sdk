//
//  ULNativeAdvResponseDataItem.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULNativeAdvResponseDataItem.h"

@implementation ULNativeAdvResponseDataItem

- (id)initWithResponse: (id )response
{
    if (self = [super init]) {
        _response = response;
    }
    return self;
}
- (id)initWithResponse: (id )response withContainerView: (UIView *)containerView
{
    if (self = [super init]) {
        _response = response;
        _containerView = containerView;
    }
    return self;
}

- (id)initWithResponse: (id )response withContainerView: (UIView *)containerView withClickView: (UIView *)clickView
{
    if (self = [super init]) {
        _response = response;
        _containerView = containerView;
        _clickView = clickView;
    }
    return self;
}

- (id)initWithResponse: (id )response withContainerView: (UIView *)containerView withClickView: (UIView *)clickView withCallback: (id<ULINativeAdvItemCallback>) callback
{
    if (self = [super init]) {
        _response = response;
        _containerView = containerView;
        _clickView = clickView;
        _callback = callback;
    }
    return self;
    
}


- (void)onClick
{
    if(_clickView){
        //TODO 暂时未找到主动触法点击事件的方法
    }
}

- (void)onDispose
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_containerView) {
            //先行移除子view
            [self->_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //移除自身
            [self->_containerView removeFromSuperview];
            
            self->_clickView = nil;
            self->_containerView = nil;
            self->_response = nil;
        }
    });
}


@end
