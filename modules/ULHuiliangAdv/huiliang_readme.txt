添加HTTP权限
	<key>NSAppTransportSecurity</key>
    	<dict>
         	<key>NSAllowsArbitraryLoads</key>
         	<true/>
    	</dict>


增加参数-ObjC

添加依赖库
	CoreGraphics.framework 
	Foundation.framework
	UIKit.framework
	libsqlite3.tbd (在Xccode7以下是libsqlite3.dylib)
	libz.tbd (在Xcode7以下是libz.dylib)
	AdSupport.framework
	StoreKit.framework
	QuartzCore.framework
	CoreTelephony.framework
	MobileCoreServices.framework
	AVFoundation.framework
	WebKit.framework



