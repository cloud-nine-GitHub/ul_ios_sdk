//
//  ULCountTool.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/13.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULCountTool : NSObject


+ (instancetype)getInstance;
- (void)setMax:(NSString *)key :(int )max;
- (void)post:(NSString *)key :(int)count;
- (BOOL)checkOverload:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
