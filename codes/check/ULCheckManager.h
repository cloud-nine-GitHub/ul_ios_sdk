//
//  ULCheckManager.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/13.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULICheck.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ULICheck;
@interface ULCheckManager : NSObject
{
    
}

+ (BOOL)checkConditionString:(NSString *)condition :(id<ULICheck> )check;
+ (BOOL)checkConditionListByAnd:(NSMutableArray *)list :(id<ULICheck> )check;
+ (BOOL)checkConditionListByOr:(NSMutableArray *)list :(id<ULICheck> )check;

@end



NS_ASSUME_NONNULL_END
