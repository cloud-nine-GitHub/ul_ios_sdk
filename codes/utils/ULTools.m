//
//  ULTools.m
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/24.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

/**
 
 tools工具类
 
 
 */

#import "ULTools.h"
#import "ULCop.h"
#import "ULConfig.h"
#import <AdSupport/ASIdentifierManager.h>


@implementation ULTools

#pragma mark - 将字典类型转为NSString
+ (NSString*) DictionaryToString:(NSDictionary*)dict
{
    NSString* jsonStr = @"";
    
    NSError * error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([data length] > 0 && error == nil) {
        jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return jsonStr;
}


#pragma mark - 将NSString转为字典类型 jsonStr -> dict
+ (NSDictionary*) StringToDictionary:(NSString*)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    
    NSError* error = nil;
    NSDictionary* jsonDict = nil;
    NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        jsonDict = (NSDictionary *)jsonData;
    }
    return jsonDict;
}



#pragma mark - 从字典中获取指定NSString
+ (NSString *)GetStringFromDic :(NSDictionary *)dic :(NSString *)key :(NSString *)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id value = [dic objectForKey:key];
    if (!value) {
        return defValue;
    }
    if (![value isKindOfClass:[NSString class]]) {
        return defValue;
    }
    return value;
}

#pragma mark - 从字典中获取指定int
+ (int)GetIntFromDic :(NSDictionary *)dic :(NSString *)key :(int)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id value = [dic objectForKey:key];
    if (!value) {
        return defValue;
    }
    if (![value isKindOfClass:[NSNumber class]]) {
        return defValue;
    }
    return [value intValue];//TODO 这里会不会存在长度问题？
}

#pragma mark - 从字典中获取指定long
+ (long)GetLongFromDic :(NSDictionary *)dic :(NSString *)key :(long)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id value = [dic objectForKey:key];
    if (!value) {
        return defValue;
    }
    if (![value isKindOfClass:[NSNumber class]]) {
        return defValue;
    }
    long v = [value longValue];
    return v;//TODO 这里会不会存在长度问题？
}


#pragma mark - 从字典中获取指定Bool
+ (BOOL)GetBoolFromDic :(NSDictionary *)dic :(NSString *)key :(BOOL)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id value = [dic objectForKey:key];
    if (!value) {
        return defValue;
    }
    return value;
}

#pragma mark - 从字典中获取指定NSArray
+ (NSArray *)GetArrayFromDic :(NSDictionary *)dic :(NSString *)key :(NSArray *)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id value = [dic objectForKey:key];
    if (!value) {
        return defValue;
    }
    if (![value isKindOfClass:[NSArray class]]) {
        return defValue;
    }
    return value;
}


#pragma mark - 从字典中获取指定NSMutableArray
+ (NSMutableArray *)GetMutableArrayFromDic :(NSDictionary *)dic :(NSString *)key :(NSMutableArray *)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id value = [dic objectForKey:key];
    if (!value) {
        return defValue;
    }
    if (![value isKindOfClass:[NSMutableArray class]]) {
        return defValue;
    }
    return value;
}


#pragma mark - 从字典中获取指定NSDictionary
+ (NSDictionary *)GetNSDictionaryFromDic :(NSDictionary *)dic :(NSString *)key :(NSDictionary *_Nullable)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id str = [dic objectForKey:key];
    if (!str) {
        return defValue;
    }
    if (![str isKindOfClass:[NSDictionary class]]) {
        return defValue;
    }
    return str;
}

#pragma mark - 从字典中获取指定NSMutableDictionary
+ (NSMutableDictionary *)GetNSMutableDictionaryFromDic :(NSDictionary *)dic :(NSString *)key :(NSMutableDictionary *_Nullable)defValue
{
    
    if (!dic) {
        return defValue;
    }
    id str = [dic objectForKey:key];
    if (!str) {
        return defValue;
    }
    if (![str isKindOfClass:[NSMutableDictionary class]]) {
        return defValue;
    }
    return str;
}






#pragma mark - 获取当前时间
+ (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}



#pragma mark - 反射无参函数，注意重写该类的allocWithZone，确保是单例模式
+ (void)invokeInstance:(NSString*)className noArgFunc:(NSString*)funcName{
    id someClass = NSClassFromString(className);
    if(someClass != nil){
        id instance = [[someClass alloc] init];
        SEL selecor = NSSelectorFromString(funcName);
        if (instance && [instance respondsToSelector:selecor]) {
            //[instance performSelector:selecor withObject:nil]; //注意，这里会报警告，因为上下文找不到该方法
            //如果带多个参数，或者使编译器不报警告,使用函数指针
            void(* fun)(id,SEL) = (void(*)(id,SEL))[instance methodForSelector:selecor]; //这里会获取到IMP指针
            fun(instance,selecor);
        }
    }
}

#pragma mark - 反射静态无参函数，还没做测试
+ (void)invokeStatic:(NSString*)className noArgFunc:(NSString*)funcName{
    id someClass = NSClassFromString(className);
    if(someClass != nil){
        SEL selecor = NSSelectorFromString(funcName);
        if ([someClass respondsToSelector:selecor]) {
            //[instance performSelector:selecor withObject:nil]; //注意，这里会报警告，因为上下文找不到该方法
            //如果带多个参数，或者使编译器不报警告,使用函数指针
            void(* fun)(id,SEL) = (void(*)(id,SEL))[someClass methodForSelector:selecor]; //这里会获取到IMP指针
            fun(someClass,selecor);
        }
    }
}

#pragma mark - 从cop或者config获取指定NSString值
+ (NSString *)getCopOrConfigStringWithKey:(NSString *)key withDefaultString:(NSString *)defaultString
{
    NSString *p = nil;
    NSDictionary *dic = [ULCop getCopInfo];
    if (dic) {
        p = [dic objectForKey:key];
    }
    if (!p) {
        dic = [ULConfig getConfigInfo];
        if (!dic) {
            return defaultString;
        }
        p = [dic objectForKey:key];
    }
    if (!p) {
        return defaultString;
    }
    if ([p isKindOfClass:[NSString class]]) {
        return p;
    }else{
        NSLog(@"%s%@",__func__,@"value is not string,retrun default!");
        return defaultString;
    }
    
    return @"";
}


#pragma mark - 从cop或者config获取指定NSDictionary值
+ (NSDictionary *)getCopOrConfigDictionaryWithKey:(NSString *)key withDefaultString:(NSDictionary * _Nullable)defValue
{
    NSDictionary *p = nil;
    NSDictionary *dic = [ULCop getCopInfo];
    if (dic) {
        p = [dic objectForKey:key];
    }
    if (!p) {
        dic = [ULConfig getConfigInfo];
        if (!dic) {
            return defValue;
        }
        p = [dic objectForKey:key];
    }
    if (!p) {
        return defValue;
    }
    if ([p isKindOfClass:[NSDictionary class]]) {
        return p;
    }else{
        NSLog(@"%s%@",__func__,@"value is not dictionary,retrun default!");
        return defValue;
    }
}


#pragma mark - 将NSOBject对象转为NSString对象(目前测试存在问题，先行注释)
+ (NSString *)NSObjectToNSString:(NSObject *)obj
{
//    // response是NSObject
//    // 归档(NSObject) 转成 NSData
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
//    // @"root"不能改
//    [archiver encodeObject:obj forKey:@"root"];
//    [archiver finishEncoding];
//    // NSData 转成 NSString
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return string;
    return @"";
}




#pragma mark - 获取当前正在显示的控制器

+ (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    // 获取默认的window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它。
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取window的rootViewController
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}



#pragma mark - 单按钮提示对话框
+ (UIAlertController *)showSingleBtnDialogWithTitle:(NSString *)title withDesc:(NSString *)desc withBtnText:(NSString *)btnText withListener:(id)listener{
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:desc preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:btnText style:UIAlertActionStyleDefault handler:listener]];
    // 弹出对话框
    [[self getCurrentViewController] presentViewController:alert animated:true completion:nil];
    
    return alert;
}

#pragma mark - 双按钮提示对话框
+ (UIAlertController *)showDoubleBtnDialogWithTitle:(NSString *)title withDesc:(NSString *)desc withSureBtnText:(NSString *)sureText withCancelBtnText:(NSString *)cancelText withSureListener:(id)sureListener withCancelListener:(id)cancelListener
{
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:desc preferredStyle:UIAlertControllerStyleAlert];
    // 确定
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureText style:UIAlertActionStyleDefault handler:sureListener];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:cancelListener];
    
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    
    // 弹出对话框
    [[self getCurrentViewController] presentViewController:alert animated:true completion:nil];
    
    return alert;
}

#pragma mark - 三按钮提示对话框
+ (UIAlertController *)showThreeBtnDialogWithTitle:(NSString *)title withDesc:(NSString *)desc withBtnOneText:(NSString *)btnOneText withBtnTwoText:(NSString *)btnTwoText withBtnThreeText:(NSString *)btnThreeText withOneListener:(id)oneListener withTwoListener:(id)twoListener withThreeListener:(id)threeListener
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:desc preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:btnOneText style:UIAlertActionStyleDefault handler:oneListener]];
    [alert addAction:[UIAlertAction actionWithTitle:btnTwoText style:UIAlertActionStyleDefault handler:twoListener]];
    [alert addAction:[UIAlertAction actionWithTitle:btnThreeText style:UIAlertActionStyleDestructive handler:threeListener]];
    
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = [self getCurrentViewController].view;
        popover.sourceRect = CGRectMake(0, 0, 100, 100);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil]; //跳转到弹框
    return alert;
}

#pragma mark - 获取当前app名称
+ (NSString *)getCurrentAppName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        return @"";
    }
    return appName;
}

#pragma mark - 获取当前app-版本
+ (NSString *)getCurrentAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (!appVersion) {
        return @"";
    }
    return appVersion;
}

#pragma mark - 获取当前app-build版本
+ (NSString *)getCurrentAppBuildVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *appBuildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    if (!appBuildVersion) {
        return @"";
    }
    return appBuildVersion;
}

#pragma mark - 获取当前系统版本号
+ (NSString *)getCurrentPhoneVersion
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];//13.0
    if (!phoneVersion) {
        return @"";
    }
    return phoneVersion;
}

#pragma mark - 获取当前udid
+ (NSString *)getCurrentPhoneUDID
{
//    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
//    if (!udid) {
//        return @"";
//    }
//    return udid;
    return @"";
}

#pragma mark - 获取当前手机型号
+ (NSString *)getCurrentPhoneModel
{
    NSString* phoneModel = [[UIDevice currentDevice] model];
    if (!phoneModel) {
        return @"";
    }
    return phoneModel;
}

#pragma mark - 获取当前手机别名（用户定义的名称）
+ (NSString *)getCurrentPhoneUserName
{
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    if (!userPhoneName) {
        return @"";
    }
    return userPhoneName;
}


#pragma mark - 获取当前手机设备名称
+ (NSString *)getCurrentPhoneName
{
    NSString* deviceName = [[UIDevice currentDevice] systemName];//ios
    if (!deviceName) {
        return @"";
    }
    return deviceName;
}

#pragma mark - 获取当前手机地方型号（国际化区域名称）
+ (NSString *)getCurrentPhoneLocalModel
{
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    if (!localPhoneModel) {
        return @"";
    }
    return localPhoneModel;
}


#pragma mark - 获取当前语言
+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if (!currentLanguage) {
        return @"";
    }
    return currentLanguage;
}


#pragma mark - 将16进制颜色转为color对象
+ (UIColor*)stringToColor:(NSString *)str
{
    
    if (!str || [str isEqualToString:@""]) {
        
        return nil;
        
    }
    
    unsigned red,green,blue;
    
    NSRange range;
    
    range.length = 2;
    
    range.location = 1;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    
    range.location = 3;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    
    range.location = 5;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    
    return color;
    
}

#pragma mark - 分割字符串并获取随机
+ (NSString*) getRandomParamBySplit:(NSString *)param :(NSString *)splitString
{
    NSMutableArray *paramArray = (NSMutableArray *)[param componentsSeparatedByString:splitString];
    int length = (int)paramArray.count;
    if (length > 1) {
        int idx = arc4random() % length;
        return paramArray[idx];
    }
    return param;
}

#pragma mark - 获取idfa
//需要引入Adsupport.framework
+ (NSString*)getIDFA
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (idfa == nil) {
        idfa = @"";
    }
    return idfa;
}



#pragma mark - NSUDID
+ (NSString *)getNSUDID
{
    NSString *nsUuid = [[NSUUID UUID] UUIDString];
    if (nsUuid == nil) {
        nsUuid = @"";
    }
    return nsUuid;
}

#pragma mark - Vendor标示符
+ (NSString *)getIDFV
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (idfv == nil) {
        idfv = @"";
    }
    return idfv;
}

#pragma marks - 模拟andorid中的toast提示打印
+ (void)showMessageWithTartVC:(UIViewController *)vc withMsg:(NSString *)message
{
    UIView *showview = [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [vc.view addSubview:showview];
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end



