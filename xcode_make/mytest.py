#!/bin/python
# -*- coding: utf-8 -*-

import tools
import sys
import json
import os
import shutil
import plistlib
from mod_pbxproj import XcodeProject


#project = XcodeProject.Load('/Users/ul_macbookpro01/Desktop/testpbxproj/testpbxproj/testpbxproj.xcodeproj/project.pbxproj')
project = XcodeProject.Load('/Users/ul_macbookpro01/ulwork/ude2/prj.game15/xcode/proj.ios_mac/Unity-iPhone.xcodeproj/project.pbxproj')
# project = XcodeProject.Load('/Users/ul_macbookpro01/ulwork/ude2/prj.game35/xcode/_proj.ios_appstore/Unity-iPhone.xcodeproj/project.pbxproj')
# project = XcodeProject.Load('/Users/ul_macbookpro01/ulwork/ude2/prj.game15/xcode/_proj.ios_appstore/Unity-iPhone.xcodeproj/project.pbxproj')

# project = XcodeProject.Load('/Users/ul_macbookpro01/Desktop/testld/testld.xcodeproj/project.pbxproj')


# add_library_search_paths
# add_framework_search_paths
# project.add_framework_search_paths(['/Users/ul_macbookpro01/Desktop/testpbxproj/Common/CustomAdsModule.framework'])

#project.add_file('/Users/ul_macbookpro01/Desktop/testpbxproj/Common/CustomAdsModule.framework', None, 'SOURCE_ROOT', True, True)

# project.test()

#####################

#乐豆添加的标准库

# print project.source_root

# for obj in project.objects.values():
# 	print obj
# project.add_file_if_doesnt_exist('CoreLocation.framework',None, 'SDKROOT')
# project.add_embed_binaries(['MediaPlayer.framework'],'testld')
# standardFrameworks = ['MediaPlayer.framework']
# project.add_embed_binaries(['MobGiNativeAd.framework'],'Unity-iPhone')
# project.add_single_valued_flag("LD_RUNPATH_SEARCH_PATHS", "$(inherited) @executable_path/Frameworks")
# project.add_single_valued_flag("LD_RUNPATH_SEARCH_PATHS", "$(inherited) @executable_path/Frameworks", "Debug")
# project.test()

# ####################################################################
standardFrameworks = ['Foundation.framework','UIKit.framework','AVKit.framework','WebKit.framework','AdSupport.framework','StoreKit.framework','CoreTelephony.framework','Passkit.framework','Social.framework','libresolv.tbd','libz.tbd','libc++.tbd','libsqlite3.tbd','libsqlite3.0.tbd','libxml2.tbd','libxml2.2.tbd','GLKit.framework','AVFoundation.framework','CoreMedia.framework','Security.framework','CoreVideo.framework','CFNetwork.framework','MobileCoreServices.framework','CoreData.framework','CoreMotion.framework','EventKit.framework','EventKitUI.framework','Mapkit.framework','MessageUI.framework','Twitter.framework','CoreGraphics.framework','CoreLocation.framework','MediaPlayer.framework','QuartzCore.framework','SystemConfiguration.framework','ImageIO.framework','CoreFoundation.framework','AudioToolbox.framework','CoreBluetooth.framework','JavaScriptCore.framework','WatchConnectivity.framework','Photos.framework']
# # print standardFrameworks[0]
group_Frameworks = project.get_or_create_group("Frameworks")
for _, f in enumerate(standardFrameworks):
	print "  project.add_file_if_doesnt_exist(%s, parent = group_Frameworks)" % f
	project.add_file_if_doesnt_exist(f, group_Frameworks, 'SDKROOT')
#################################################################

floder_path = ["/Users/ul_macbookpro01/Desktop/MobGiAds_iOS_SDK_4.7.0_20191011/MobGiAds_iOS_SDK/AggregationSDK","/Users/ul_macbookpro01/Desktop/MobGiAds_iOS_SDK_4.7.0_20191011/MobGiAds_iOS_SDK/AggregationAdThirdSDKs"]

for _, f in enumerate(floder_path):
	project.add_folder(f)
# group_3rdparts = project.get_or_create_group("3rdparts")
# project.add_folder("/Users/ul_macbookpro01/ulwork/ude2/prj.ulsdk/UISDK/xcode_make/../../UISDK/ios/libSource/ledou", parent = group_3rdparts)
# project.add_embed_binaries(['MobGiNativeAd.framework'],'testld')
# target = "testld"
target = "Unity-iPhone"
project.add_embed_binaries(['MobGiVideoAd.framework','MobGiInterstitialAd.framework','MobGiNativeAd.framework','MobGiSplashAd.framework','MobGiBannerAd.framework','MobGiNativeFlowAd.framework','CustomAdsModule.framework','AdxAdsComponent.framework','AggregationAdsComponent.framework','AdsBasicFramework.framework','SDKCommonModule.framework'], target)
#################################################
project.save()




