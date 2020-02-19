//
//  ULUserDefaults.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2020/2/13.
//  Copyright © 2020 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ULUserDefaults : NSObject
{
    
}
+ (void)writeDataToUserDefault:(NSMutableDictionary *)targetData;
+ (id)readDataFromUserDefault:(NSString *)key;
+ (void)removeDataFromUserDefault:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
