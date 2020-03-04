//
//  MobGiAdsSDKError.h
//  SDKCommonModule
//
//  Created by alan.xia on 2020/1/6.
//  Copyright © 2020 com.idreamsky. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSErrorDomain MGAdErrorDomain ;

typedef NS_ENUM(NSInteger, MGAdErrorCode) {
    MGAdErrorCodeNoInternet                     = 6001,
    MGAdErrorCodeRequestConfigurationFailed     = 6002,
    MGAdErrorCodeServerLimit                    = 6003,
    MGAdErrorCodeConfigurationEmpty             = 6004,
    MGAdErrorCodeAppKeyError                    = 6005,
    MGAdErrorCodeDataParsingError               = 6006,
    MGAdErrorCodePackageNameError               = 6007,
    MGAdErrorCodeNetworkTypeError               = 6008,
    MGAdErrorCodeGeneralConfigurationEmpty      = 6009,
    
    MGAdErrorCodeNoUseInitFunction                      = 7001,
    MGAdErrorCodeBlockIdEmpty                           = 7002,
    MGAdErrorCodeBlockIdError                           = 7003,
    MGAdErrorCodeBlockIdShowLimit                       = 7004,
    MGAdErrorCodeAllThirdPlatformShowLimit              = 7005,
    MGAdErrorCodeBlockIdProbabilityNotSelected          = 7006,
    MGAdErrorCodeViewControllerEmpty                    = 7007,
    MGAdErrorCodeAggregateRequestTimeout                = 7008,
    MGAdErrorCodeBlockIdProbabilityLessOrEqualZero      = 7009,
    MGAdErrorCodeNoAdsReady                             = 7010,
    MGAdErrorCodeViewEmpty                              = 7011,
    MGAdErrorCodeAdSizeEmpty                            = 7012,
    MGAdErrorCodeInitializationNotCompleted             = 7013,
    MGAdErrorCodeBlockIdConfigurationEmpty              = 7014,
    MGAdErrorCodeBlockIdNoUseLoadFunction               = 7015,
    MGAdErrorCodeRandomPlatformError                    = 7016,
    MGAdErrorCodeSelectedPlatformError                  = 7017,
    MGAdErrorCodeHTMLTemplateTLoadFailed                = 7018,
    MGAdErrorCodeImageLoadFailed                        = 7019,
    MGAdErrorCodeIncomingDataEmpty                      = 7020,
    MGAdErrorCodeIncomingDataError                      = 7021,
    MGAdErrorCodeNoAnyCacheData                         = 7022,
    MGAdErrorCodeBlockIdNoCacheData                     = 7023,
    MGAdErrorCodeBlockIdNoAdReady                       = 7024,
    MGAdErrorCodeinteractionViewEmpty                   = 7025,
    MGAdErrorCodeAdViewInfoEmpty                        = 7026,
    MGAdErrorCodeNoUseGetStatusFuction                  = 7027,
    MGAdErrorCodeWindowEmpty                            = 7028,
    MGAdErrorCodeVideoResourceLoadFailed                = 7029,
    MGAdErrorCodeSystemLessThanNine                     = 7030,
    MGAdErrorCodeWebviewError                           = 7031,
    MGAdErrorCodeLoadResourceTimeout                    = 7032,
    MGAdErrorCodeScreenOrientationError                 = 7033,
    
    MGAdErrorCodeThirdPlatformRequestTimeout              = 8001,
    MGAdErrorCodeThirdPlatformAdExpire                    = 8002,
    MGAdErrorCodeThirdPlatformConfigurationError          = 8003,
    MGAdErrorCodeThirdPlatformShowLimit                   = 8004,
    MGAdErrorCodeThirdPlatformNoFill                      = 8005,
    MGAdErrorCodeThirdPlatformReturnDataEmpty             = 8006,
    MGAdErrorCodeCacheNotFoundThePlatform                 = 8007,
    
    MGAdErrorCodeThirdPlatformOtherLoadFailed             = 9007,
    MGAdErrorCodeThirdPlatformOtherShowFailed             = 9008
};

