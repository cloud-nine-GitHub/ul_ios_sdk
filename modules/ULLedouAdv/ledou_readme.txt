����APPKEY
	��info.plist�ļ���ӣ���keyΪ��MobGiAdsAppkey�����ͣ�Type��ΪString��ֵ��value��ΪӦ�������appkey .ע�����û����ӻᵼ��Ӧ������

���õ�����APPKEY

	�������ӹȸ裨Admob�����ƽ̨����Ҫ��info.plist�ļ������һ����ֵ�ԣ�keyΪGADApplicationIdentifier��valueΪ�ȸ�ƽ̨����Ķ�Ӧ��Ӧ��appkey��value����ΪString. ע�����û����ӻᵼ��Ӧ������


���framework����
	�Ѷ�Ӧ�ļ���SDK�ļ������϶���Xcode��������-General-Embedded Binaries��.ע�����û����ӻᵼ��Ӧ������
	��MobGiVideoAd.framework
	��MobGiInterstitialAd.framework
	��MobGiNativeAd.framework
	��MobGiSplashAd.framework
	��MobGiBannerAd.framework
	��MobGiNativeFlowAd.framework
	��CustomAdsModule.framework
	��AdxAdsComponent.framework
	��AggregationAdsComponent.framework
	��AdsBasicFramework.framework
	��SDKCommonModule.framework


���HTTPȨ��
	<key>NSAppTransportSecurity</key>
    	<dict>
         	<key>NSAllowsArbitraryLoads</key>
         	<true/>
    	</dict>


���Ӳ���-ObjC

���������
	��Foundation.framework (option)
	��UIKit.framework (option)
	��AVKit.framework (option)
	��WebKit.framework (option)
	��AdSupport.framework (option)
	��StoreKit.framework (option)
	��CoreTelephony.framework (option) 
	��Passkit.framework (option) 
	��Social.framework (option) 
	��libresolv.tbd
	��libz.tbd
	��libc++.tbd
	��libsqlite3.tbd
	��libsqlite3.0.tbd
	��libxml2.tbd
	��libxml2.2.tbd
	��GLKit.framework 
	��AVFoundation.framework
	��CoreMedia.framework
	��Security.framework
	��CoreVideo.framework
	��CFNetwork.framework
	��MobileCoreServices.framework
	��CoreData.framework
	��CoreMotion.framework
	��EventKit.framework
	��EventKitUI.framework
	��Mapkit.framework
	��MessageUI.framework
	��Twitter.framework
	��CoreGraphics.framework
	��CoreLocation.framework
	��MediaPlayer.framework
	��QuartzCore.framework
	��SystemConfiguration.framework
	��ImageIO.framework
	��CoreFoundation.framework
	��AudioToolbox.framework
	��CoreBluetooth.framework
	��JavaScriptCore.framework
	��WatchConnectivity.framework
	��Photos.framework

�������Ȩ��
	��NSLocationAlwaysUsageDescription��ʼ�շ���λ�ã�
	��NSLocationWhenInUseUsageDescription��ʹ���ڼ����λ�ã�
	��NSCalendarsUsageDescription������Ȩ�ޣ�
	��NSPhotoLibraryUsageDescription�����Ȩ�ޣ�
	��NSCameraUsageDescription�����Ȩ�ޣ�

Enable Bitcode����ΪNO
	->����->build Settings->Enable Bitcode

Enable Modules ��ΪYES
	->����->build Settings-> Enable Modules


