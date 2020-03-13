添加依赖：
	libc++.tbd
	libresolv.9.tbd
	libsqlite3.tbd
	libxml2.tbd
	libz.tbd
	Accelerate.framework
	AdSupport.framework
	AudioToolbox.framework
	AVFoundation.framework
	CFNetwork.framework
	CoreFoundation.framework
	CoreGraphics.framework
	CoreLocation.framework
	CoreTelephony.framework
	CoreMedia.framework
	CoreMotion.framework
	CoreVideo.framework
	EventKit.framework
	Foundation.framework
	GLKit.framework
	iAd.framework
	ImageIO.framework
	MediaPlayer.framework
	MessageUI.framework
	MobileCoreServices.framework
	QuartzCore.framework
	SafariServices.framework
	Security.framework
	Social.framework
	StoreKit.framework
	SystemConfiguration.framework
	VideoToolbox.framework
	WatchConnectivity.framework
	WebKit.framework
	JavaScriptCore.framework
	UIKit.framework
	GameController.framework


	如果你使用 cocos2d-x 还需要额外添加依赖 GameController.framework

	注意！WatchConnectivity.framework 为广告商 AdColony 所依赖，该系统库可能导致某些旧版本的 Unity3D 出包的 iap 无法通过苹果审核，可通过更新 Unity3D 版本或删除 AdColony.framework 和 WatchConnectivity.framework 来解决

	注意！如果想要支持iOS8.0或更早的版本，必须将 CoreFoundation.framework 及 WatchConnectivity.framework 等只有iOS9.0以上才能够使用的库设置为Optional，同时TGSDK会限制相关SDK的启动



申请相关权限

	由于广告商 Adcolony 提供的广告 SDK 依赖 EventKit.framework ，根据苹果官方文档的说明，自 iOS 10.0 之后需要申请相关的权限否则会导致程序的崩溃。所以需要在 Info.plist 文件中加入如下配置项
	<key>NSCalendarsUsageDescription</key>
	<string>Some ad content may create a calendar event.</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Some ad content may require access to the photo library.</string>
	<key>NSCameraUsageDescription</key>
	<string>Some ad content may access camera to take picture.</string>
	<key>>NSMotionUsageDescription</key>
	<string>Some ad content may require access to accelerometer for interactive ad experience.</string>


编译设置
	在 Build Settings ----> Other Linker Flags 设置项目中增加 -ObjC 配置项


BitCode 支持

	从 1.6.1 版本开始 iOS 版本（含对 Unity 的支持）的广告 SDK 支持 iOS 的 BitCode 技术，使用者可以放心的打开项目对 BitCode 的支持。

	【注意】支持 BitCode 后 SDK 本身的体积会有一定的增大，用户打包的 iOS 工程体积也会相应的增大，但是用户从苹果商店下载到的应用体积会大幅度的减小，所以建议用户请放心开启 BitCode 支持