位置权限
	SDK 不会主动获取应用位置权限，当应用本身有获取位置权限逻辑时，需要在应用的 info.plist 添加相应配置信息，避免 App Store 审核被拒：

   // 应用根据实际情况配置
   Privacy - Location When In Use Usage Description
   Privacy - Location Always and When In Use Usage Description
   Privacy - Location Always Usage Description
   Privacy - Location Usage Description


增加参数-ObjC

添加依赖库
	AdSupport.framework	4.7.2及以后版本	
	CoreLocation.framework	同上	
	QuartzCore.framework	同上	
	SystemConfiguration.framework	同上	
	CoreTelephony.framework	同上	
	libz.tbd	同上	或者是libz.dylib
	Security.framework	同上	
	StoreKit.framework	同上	
	libxml2.tbd	同上	
	AVFoundation.framework	同上	
	WebKit.framework	同上	可选

添加HTTP权限
	<key>NSAppTransportSecurity</key>
    	<dict>
         	<key>NSAllowsArbitraryLoads</key>
         	<true/>
    	</dict>

