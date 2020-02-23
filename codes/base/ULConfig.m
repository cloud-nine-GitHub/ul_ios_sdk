//
//  ULConfig.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/21.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import "ULConfig.h"
#import "ULTools.h"

static NSString *const MODULE_DEFAULT_LIST = @"ULDefaultModule,ULCdk,ULAccountTask";

@implementation ULConfig

static NSDictionary* configInfoDic;
static NSArray *moduleList = nil;

+ (void)initConfigInfo{
    
    NSLog(@"%s",__func__);
    //TODO read cConfig.json from Resources
    // configInfo =  @{@"key1" : @"value1",@"key2" : @"value2",@"key3" : @"value3"};

    NSData* content =   [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cConfig" ofType:@"json"]];

    NSError *error = nil;

    configInfoDic = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableLeaves error:&error];

    // NSString * path = [[NSBundle mainBundle]pathForResource:@"cConfig" ofType:@"json"];
    // NSURL * usr = [NSURL fileURLWithPath:path];
    
    // NSString * str = [NSString stringWithContentsOfURL:usr encoding:NSUTF8StringEncoding error:nil];
    // NSLog(@"cConfig====%@", str);

}


+ (NSDictionary*)getConfigInfo{
    //根据启动顺序，这里应该返回的非空值
    return configInfoDic;
}


+ (NSString *)getConfigInfoString
{
    if (!configInfoDic) {
        return @"{}";
    }
    return [ULTools DictionaryToString:configInfoDic];
}

+ (NSArray *)getModuleList
{
    if (!moduleList) {
        NSString *moduleListString = [ULTools GetStringFromDic:configInfoDic :@"s_common_module_list" :@""];
        NSString * moduleListS = @"";
        if(moduleListString.length > 6){
            NSString *defaultAndCommon = [[NSString alloc] initWithFormat:@"%@%@%@",@"common,",MODULE_DEFAULT_LIST,@","];
            moduleListS = [moduleListString stringByReplacingOccurrencesOfString:@"common," withString:defaultAndCommon];
        }else{
            moduleListS = [[NSString alloc]initWithFormat:@"%@%@%@",moduleListString,@",",MODULE_DEFAULT_LIST];
        }
        
        moduleList = [moduleListS componentsSeparatedByString:@","];
    }
    
    return moduleList;
}


+ (NSString *)getUlsdkVersion
{
    return [ULTools GetStringFromDic:configInfoDic :@"s_common_ulsdk_version" :@""];
}

@end
