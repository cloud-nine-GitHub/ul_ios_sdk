���������
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


	�����ʹ�� cocos2d-x ����Ҫ����������� GameController.framework

	ע�⣡WatchConnectivity.framework Ϊ����� AdColony ����������ϵͳ����ܵ���ĳЩ�ɰ汾�� Unity3D ������ iap �޷�ͨ��ƻ����ˣ���ͨ������ Unity3D �汾��ɾ�� AdColony.framework �� WatchConnectivity.framework �����

	ע�⣡�����Ҫ֧��iOS8.0�����İ汾�����뽫 CoreFoundation.framework �� WatchConnectivity.framework ��ֻ��iOS9.0���ϲ��ܹ�ʹ�õĿ�����ΪOptional��ͬʱTGSDK���������SDK������



�������Ȩ��

	���ڹ���� Adcolony �ṩ�Ĺ�� SDK ���� EventKit.framework ������ƻ���ٷ��ĵ���˵������ iOS 10.0 ֮����Ҫ������ص�Ȩ�޷���ᵼ�³���ı�����������Ҫ�� Info.plist �ļ��м�������������
	<key>NSCalendarsUsageDescription</key>
	<string>Some ad content may create a calendar event.</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Some ad content may require access to the photo library.</string>
	<key>NSCameraUsageDescription</key>
	<string>Some ad content may access camera to take picture.</string>
	<key>>NSMotionUsageDescription</key>
	<string>Some ad content may require access to accelerometer for interactive ad experience.</string>


��������
	�� Build Settings ----> Other Linker Flags ������Ŀ������ -ObjC ������


BitCode ֧��

	�� 1.6.1 �汾��ʼ iOS �汾������ Unity ��֧�֣��Ĺ�� SDK ֧�� iOS �� BitCode ������ʹ���߿��Է��ĵĴ���Ŀ�� BitCode ��֧�֡�

	��ע�⡿֧�� BitCode �� SDK ������������һ���������û������ iOS �������Ҳ����Ӧ�����󣬵����û���ƻ���̵����ص���Ӧ����������ȵļ�С�����Խ����û�����Ŀ��� BitCode ֧��