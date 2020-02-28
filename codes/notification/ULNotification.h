//
//  ULNotification.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/10/30.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const UL_NOTIFICATION_START_SDK = @"startSdk";
static NSString *const UL_NOTIFICATION_START_GAME = @"startGame";
static NSString *const UL_NOTIFICATION_RESPONSE = @"response";
static NSString *const UL_NOTIFICATION_REQUEST = @"request";


static NSString *const UL_NOTIFICATION_APPLICATION_WILL_RESIGN_ACTIVE = @"applicationWillResignActive";
static NSString *const UL_NOTIFICATION_APPLICATION_DID_ENTER_BACKGROUND = @"applicationDidEnterBackground";
static NSString *const UL_NOTIFICATION_APPLICATION_WILL_ENTER_FOREGROUND = @"applicationWillEnterForeground";
static NSString *const UL_NOTIFICATION_APPLICATION_DID_BECOME_ACTIVE = @"applicationDidBecomeActive";
static NSString *const UL_NOTIFICATION_APPLICATION_WILL_TERMINATE = @"applicationWillTerminate";
static NSString *const UL_NOTIFICATION_APPLICATION_DID_RECEIVE_MEMORYWARNING = @"applicationDidReceiveMemoryWarning";

static NSString *const UL_NOTIFICATION_ULSDKMANAGER_INIT = @"ulsdkManagerInit";
static NSString *const UL_NOTIFICATION_ONJSONAPI = @"onJsonAPI";
static NSString *const UL_NOTIFICATION_ONDISPOSEMODULE = @"onDisposeModule";
static NSString *const UL_NOTIFICATION_ONJSONRPCCALL = @"onJsonRpcCall";

static NSString *const UL_NOTIFICATION_PREOPEN_PAY = @"ulNotificationPreOpenPay";
static NSString *const UL_NOTIFICATION_OPEN_PAY = @"ulNotificationOpenPay";

static NSString *const UL_NOTIFICATION_PREPARE_SHOW_ADV_BASE = @"ulNotificationPrepareShowAdv";
static NSString *const UL_NOTIFICATION_SHOW_ADV_BASE = @"ulNotificationShowAdv";
static NSString *const UL_NOTIFICATION_SETVERSION = @"ulNotificationSetVersion";
static NSString *const UL_NOTIFICATION_MANAGER_INIT_ADV = @"ulNotificationManagerInitAdv";

static NSString *const UL_NOTIFICATION_ACCOUNT_WRITE_DATA = @"ulNotificationAccountWriteData";
static NSString *const UL_NOTIFICATION_ACCOUNT_READ_DATA = @"ulNotificationAccountReadData";
static NSString *const UL_NOTIFICATION_ACCOUNT_UP_DATA = @"ulNotificationAccountUpData";


//测试界面消息
static NSString *const UL_NOTIFICATION_MC_OPEN_DEMO_PAY = @"ulNotificationMcOpenDemoPay";
static NSString *const UL_NOTIFICATION_MC_OPEN_DEMO_PAY_CALLBACK = @"ulNotificationMcOpenDemoPayCallback";
static NSString *const UL_NOTIFICATION_MC_SHOW_DEMO_INTER_ADV = @"ulNotificationMcShowDemoInterAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_DEMO_FULLSCREEN_ADV = @"ulNotificationMcShowDemoFullscreenAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_DEMO_VIDEO_ADV = @"ulNotificationMcShowDemoVideoAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_DEMO_BANNER_ADV = @"ulNotificationMcShowDemoBannerAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_DEMO_URL_ADV = @"ulNotificationMcShowDemoUrlAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_DEMO_ADV_CALLBACK = @"ulNotificationMcShowDemoAdvCallback";
static NSString *const UL_NOTIFICATION_MC_OPEN_APPLE_PAY = @"ulNotificationMcOpenApplePay";
static NSString *const UL_NOTIFICATION_MC_OPEN_APPLE_PAY_CALLBACK = @"ulNotificationMcOpenApplePayCallback";
static NSString *const UL_NOTIFICATION_MC_SHOW_TOUTIAO_INTER_ADV = @"ulNotificationMcShowToutiaoInterAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_TOUTIAO_FULLSCREEN_ADV = @"ulNotificationMcShowToutiaoFullscreenAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_TOUTIAO_VIDEO_ADV = @"ulNotificationMcShowToutiaoVideoAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_TOUTIAO_BANNER_ADV = @"ulNotificationMcShowToutiaoBannerAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_TOUTIAO_URL_ADV = @"ulNotificationMcShowToutiaoUrlAdv";
static NSString *const UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK = @"ulNotificationMcShowToutiaoAdvCallback";
static NSString *const UL_NOTIFICATION_MC_SHOW_ULURL_URL_ADV = @"ulNotificationMcShowUlUrlurlAdvCallback";












@interface ULNotification : NSObject
{
    @public
    NSString *_name;
    id _data;
    BOOL _isStopDispatchNotification;
}

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)id data;

- (id)initWithNotificationName:(NSString *)name withData :(id _Nullable)param;
- (void)stopDispatchNotification;

@end

NS_ASSUME_NONNULL_END
