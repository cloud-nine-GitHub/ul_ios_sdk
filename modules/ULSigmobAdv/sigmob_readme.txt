添加HTTP权限
	<key>NSAppTransportSecurity</key>
    	<dict>
         	<key>NSAllowsArbitraryLoads</key>
         	<true/>
    	</dict>

添加定位权限(非必须)
	工程info.plist文件设置，点击右边的information Property List后边的 "+" 展开
	添加Privacy - Location When In Use Usage Description

增加参数-ObjC

添加依赖库
	+ StoreKit.framework
	+ CFNetwork.framework
	+ CoreMedia.framework
	+ AdSupport.framework
	+ CoreMotion.framework
	+ MediaPlayer.framework
	+ CoreGraphics.framework
	+ AVFoundation.framework
	+ CoreLocation.framework
	+ CoreTelephony.framework
	+ SafariServices.framework
	+ MobileCoreServices.framework
	+ WebKit.framework
	+ SystemConfiguration.framework
	+ AdSupport.framework
	+ libc++.tbd
	+ libz.tbd
	+ libsqlite3.tbd


语言配置
	注意 : 开发者<font color=red>必须</font>在这里设置所支持的语言,否则会有语言显示的问题. 
	**例如 : 支持中文 添加 Chinese**

