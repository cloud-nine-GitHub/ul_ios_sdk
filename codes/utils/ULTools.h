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
+ (NSArray *)GetArrayFromDic :(NSDictionary *)dic :(NSString *)key :(NSArray *_Nullable)defValue;
+ (NSMutableArray *)GetMutableArrayFromDic :(NSDictionary *)dic :(NSString *)key :(NSMutableArray *_Nullable)defValue;
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
+ (NSString *)getNSUDID;
+ (NSString *)getIDFV;
+ (void)showMessageWithTartVC:(UIViewController *)vc withMsg:(NSString *)message;
+  (NSArray *)stringToJsonArray:(NSString *)jsonArrayStr;
+ (NSString *)jsonArrayToJsonStr:(NSArray *)jsonArray;
+ (NSString *)getIMSI;
+ (NSString *)getICCID;
+ (NSString *)getIMEI;
+ (NSString *)getProvidersName;
+ (NSString *)platformString;
+ (NSString *)getRandomParamByCopOrConfigWithParamArray:(NSArray *)paramArray withProbabilityArray:(NSArray *)probabilityArray withParamKey:(NSString *)paramsKey withDefaultParam:(NSString *)defaultParam withSplitString:(NSString *)splitString;
+ (NSDictionary *)mergeDictionary :(NSDictionary *)dicOne :(NSDictionary *)dicTwo :(BOOL)isCoverFlag;
//TODO 对于ios13及以上包版本，sdk目前只支持单场景和单窗口，window会默认获取第一个窗口，当前展示vc也是在相应的基础上获取，如果是多场景使用，可能会导致sdk运行异常
+ (UIWindow *) getAppCurrentWindow;
+ (BOOL) isLandscapeScreen;
+ (void) adjustCenterH:(UIView *)childView :(UIView *)parentView;
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
+ (NSString *)getNowTimeTimestamp;

@end

NS_ASSUME_NONNULL_END
