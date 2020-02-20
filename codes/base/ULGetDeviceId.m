//
//  ULGetDeviceId.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/20.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULGetDeviceId.h"
#import "ULTools.h"
#import "ULKeyChain.h"

@implementation ULGetDeviceId


+ (NSString *)getUniqueDeviceId
{
    NSData *data = [ULKeyChain getDataFromKeyChainWithKey:@"ulsdkUniqueDeviceId"];
    NSString *saveDeviceId = @"";
    if (data) {
        saveDeviceId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
     
    if ([saveDeviceId isEqualToString:@""]) {
        NSString *idfa = [ULTools getIDFA];
        NSString *nsuuid = [ULTools getNSUDID];
        NSString *idfv = [ULTools getIDFV];
        NSLog(@"%s:idfa = %@; nsuuid = %@; idfv = %@",__func__,idfa,nsuuid,idfv);
        saveDeviceId = [saveDeviceId stringByAppendingFormat:@"%@%@%@%@%@",idfa, @"_",nsuuid,@"_",idfv];
        
        [ULKeyChain saveDataToKeyChainWithKey:@"ulsdkUniqueDeviceId" withValue:saveDeviceId];
        
        return saveDeviceId;
    }
    return saveDeviceId;
    
}






@end
