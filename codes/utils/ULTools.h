//
//  ULTools.h
//  ULGameDemo
//
//  Created by ul_macbookpro01 on 2018/12/24.
//  Copyright © 2018 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

@interface ULTools : NSObject
{
    
}

+ (NSString *)getCurrentTimes;
+ (NSString *) DictionaryToString:(NSDictionary *)dict;
+ (NSDictionary *) StringToDictionary:(NSString *)jsonStr;
+ (NSString *)GetStringFromDic :(NSDictionary *)dic :(NSString *)key :(NSString *)defValue;
+ (int)GetIntFromDic :(NSDictionary *)dic :(NSString *)key :(int)defValue;
+ (long)GetLongFromDic :(NSDictionary *)dic :(NSString *)key :(long)defValue;
+ (BOOL)GetBoolFromDic :(NSDictionary *)dic :(NSString *)key :(BOOL)defValue;
+ (NSArray *)GetArrayFromDic :(NSDictionary *)dic :(NSString *)key :(NSArray *)defValue;
+ (NSMutableArray *)GetMutableArrayFromDic :(NSDictionary *)dic :(NSString *)key :(NSMutableArray *)defValue;
+ (NSDictionary *)GetNSDictionaryFromDic :(NSDictionary *)dic :(NSString *)key :(NSDictionary *_Nullable)defValue;
+ (NSMutableDictionary *)GetNSMutableDictionaryFromDic :(NSDictionary *)dic :(NSString *)key :(NSMutableDictionary *_Nullable)defValue;
+ (NSString *)getCopOrConfigStringWithKey:(NSString *)key withDefaultString:(NSString *)defaultString;
+ (NSDictionary *)getCopOrConfigDictionaryWithKey:(NSString *)key withDefaultString:(NSDictionary * _Nullable)defValue;
+ (NSString *)NSObjectToNSString:(NSObject *)obj;
+ (UIViewController *)getCurrentViewController;
+ (UIAlertController *)showSingleBtnDialogWithTitle:(NSString *)title withDesc:(NSString *)desc withBtnText:(NSString *)btnText withListener:(id)listener;
+ (UIAlertController *)showDoubleBtnDialogWithTitle:(NSString *)title withDesc:(NSString *)desc withSureBtnText:(NSString *)sureText withCancelBtnText:(NSString *)cancelText withSureListener:(id)sureListener withCancelListener:(id)cancelListener;
+ (UIAlertController *)showThreeBtnDialogWithTitle:(NSString *)title withDesc:(NSString *)desc withBtnOneText:(NSString *)btnOneText withBtnTwoText:(NSString *)btnTwoText withBtnThreeText:(NSString *)btnThreeText withOneListener:(id)oneListener withTwoListener:(id)twoListener withThreeListener:(id)threeListener;

+ (NSString *)getCurrentAppName;
+ (NSString *)getCurrentAppVersion;
+ (NSString *)getCurrentAppBuildVersion;
+ (NSString *)getCurrentPhoneVersion;
+ (NSString *)getCurrentPhoneUDID;
+ (NSString *)getCurrentPhoneModel;
+ (NSString *)getCurrentPhoneUserName;
+ (NSString *)getCurrentPhoneName;
+ (NSString *)getCurrentPhoneLocalModel;
+ (NSString *)getCurrentLanguage;
+ (UIColor *)stringToColor:(NSString *)str;
+ (NSString *)getRandomParamBySplit:(NSString *)param :(NSString *)splitString;
+ (NSString*)getIDFA;
@end

NS_ASSUME_NONNULL_END
