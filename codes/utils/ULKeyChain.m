//
//  ULKeyChain.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULKeyChain.h"
/*
 
 keyChain存储密码、私钥等需要加密的数据
 **/
@implementation ULKeyChain



+ (NSData *)getDataFromKeyChainWithKey:(NSString *)key
{
    NSData *value;
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                         (__bridge id)kSecReturnData : @YES,
                                         (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
                                         (__bridge id)kSecAttrAccount : key,
                                         (__bridge id)kSecAttrService : key,
                                         };
    
    CFTypeRef typeRef = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &typeRef);
    
    if (status == errSecSuccess) {
        value = (__bridge_transfer NSData *)typeRef;
    }
    return value;
}


+ (void)saveDataToKeyChainWithKey: (NSString *)key withValue:(id)value
{
    //删除之前存储的数据
    NSDictionary *deleteQuery = @{
                                          (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                          (__bridge id)kSecAttrService : @"key",
                                          (__bridge id)kSecAttrAccount : @"key"
                                          };
    
    OSStatus deleteStatus = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
    if (deleteStatus == noErr) {
        NSLog(@"%s%@",__func__,@"delete old data success");
    }else{
        NSLog(@"%s%@",__func__,@"delete old data failed");
    }
    
    //存储数据
    NSDictionary *addQuery = @{(__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                                       (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                       (__bridge id)kSecValueData : (NSData *)value,
                                       (__bridge id)kSecAttrAccount : @"key",
                                       (__bridge id)kSecAttrService : @"key",
                                       };
    
    
    OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)addQuery, nil);
    
    if (addStatus == noErr) {
        NSLog(@"%s%@",__func__,@"save success");
    }else{
        NSLog(@"%s%@",__func__,@"save failed");
    }
}



@end
