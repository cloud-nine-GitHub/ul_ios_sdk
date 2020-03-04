配置APPKEY
	往info.plist文件添加（即key为）MobGiAdsAppkey，类型（Type）为String，值（value）为应用申请的appkey .注：如果没有添加会导致应用闪退

配置第三方APPKEY

	如果有添加谷歌（Admob）广告平台，需要往info.plist文件中添加一个键值对，key为GADApplicationIdentifier，value为谷歌平台申请的对应的应用appkey，value类型为String. 注：如果没有添加会导致应用闪退


添加framework依赖
	把对应文件从SDK文件夹里拖动到Xcode工程配置-General-Embedded Binaries里.注：如果没有添加会导致应用闪退
	·MobGiVideoAd.framework
	·MobGiInterstitialAd.framework
	·MobGiNativeAd.framework
	·MobGiSplashAd.framework
	·MobGiBannerAd.framework
	·MobGiNativeFlowAd.framework
	·CustomAdsModule.framework
	·AdxAdsComponent.framework
	·AggregationAdsComponent.framework
	·AdsBasicFramework.framework
	·SDKCommonModule.framework


添加HTTP权限
	<key>NSAppTransportSecurity</key>
    	<dict>
         	<key>NSAllowsArbitraryLoads</key>
         	<true/>
    	</dict>


增加参数-ObjC

添加依赖库
	·Foundation.framework (option)
	·UIKit.framework (option)
	·AVKit.framework (option)
	·WebKit.framework (option)
	·AdSupport.framework (option)
	·StoreKit.framework (option)
	·CoreTelephony.framework (option) 
	·Passkit.framework (option) 
	·Social.framework (option) 
	·libresolv.tbd
	·libz.tbd
	·libc++.tbd
	·libsqlite3.tbd
	·libsqlite3.0.tbd
	·libxml2.tbd
	·libxml2.2.tbd
	·GLKit.framework 
	·AVFoundation.framework
	·CoreMedia.framework
	·Security.framework
	·CoreVideo.framework
	·CFNetwork.framework
	·MobileCoreServices.framework
	·CoreData.framework
	·CoreMotion.framework
	·EventKit.framework
	·EventKitUI.framework
	·Mapkit.framework
	·MessageUI.framework
	·Twitter.framework
	·CoreGraphics.framework
	·CoreLocation.framework
	·MediaPlayer.framework
	·QuartzCore.framework
	·SystemConfiguration.framework
	·ImageIO.framework
	·CoreFoundation.framework
	·AudioToolbox.framework
	·CoreBluetooth.framework
	·JavaScriptCore.framework
	·WatchConnectivity.framework
	·Photos.framework

添加所需权限
	·NSLocationAlwaysUsageDescription（始终访问位置）
	·NSLocationWhenInUseUsageDescription（使用期间访问位置）
	·NSCalendarsUsageDescription（日历权限）
	·NSPhotoLibraryUsageDescription（相册权限）
	·NSCameraUsageDescription（相机权限）

Enable Bitcode设置为NO
	->工程->build Settings->Enable Bitcode

Enable Modules 设为YES
	->工程->build Settings-> Enable Modules


