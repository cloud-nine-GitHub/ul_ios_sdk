#!/bin/python
# -*- coding: utf-8 -*-

import os
import sys
import tools
import getopt
import datetime









##### 导出流程 #####
def export(config):
    # print "tools.createExportOptionsPlist", config["project_path"], config["teamid"]
    #如果有game_type那么说明是3d游戏，决定了uploadBitcodeFlag，这里需要注意下
    tools.createExportOptionsPlist(config["project_path"], config["teamid"], config.has_key("game_type"))

    # 1. clean
    cmd = "xcodebuild -quiet clean -project %s.xcodeproj" % config["project_name"]
    print cmd
    os.system(cmd)

    # 2. archive
    xcarchiveName = os.path.join("build", "%s.xcarchive" % config["project_name"])
    cmd = "xcodebuild -quiet archive -project %s.xcodeproj -scheme %s -archivePath %s -allowProvisioningUpdates" % (config["project_name"], config["scheme"], xcarchiveName)
    print cmd
    os.system(cmd)

    # 3. export appstore
    if config.get("appstore") != None:
        exportPath = os.path.join(config["export_path"], "%s_%s_%s_appstore_%s" % (
            config["project_name"],
            config.get("version") or "VERSION",
            config.get("channel") or "CHANNEL",
            datetime.datetime.now().strftime("%Y%m%d%H%M")
            ))
        cmd = "xcodebuild -quiet -exportArchive -archivePath %s -exportOptionsPlist %s -exportPath %s -allowProvisioningUpdates" % (xcarchiveName, tools.EXPORT_OPTIONS_PLIST_APPSTORE_FILENAME, exportPath)
        print cmd
        os.system(cmd)

    # 4. export adhoc
    if config.get("adhoc") != None:
        exportPath = os.path.join(config["export_path"], "%s_%s_%s_adhoc_%s" % (
            config["project_name"],
            config.get("version") or "VERSION",
            config.get("channel") or "CHANNEL",
            datetime.datetime.now().strftime("%Y%m%d%H%M")
            ))
        cmd = "xcodebuild -quiet -exportArchive -archivePath %s -exportOptionsPlist %s -exportPath %s -allowProvisioningUpdates" % (xcarchiveName, tools.EXPORT_OPTIONS_PLIST_ADHOC_FILENAME, exportPath)
        print cmd
        os.system(cmd)

    tools.deleteExportOptionsPlist(config["project_path"])








##### 使用说明 #####
def usage():
	print "usage:"
	print "  python exporter.py --project_path=/Users/ude2/prj.game12/framework/runtimes-src/proj.game12/ --project_name=game12 --scheme template-mobile --appstore --teamid=1234"
	print "  python exporter.py --project_path=/Users/ude2/prj.game12/framework/runtimes-src/proj.game12/ --project_name=game12 --scheme template-mobile --adhoc --teamid=1234"
	print "  python exporter.py --project_path=/Users/ude2/prj.game12/framework/runtimes-src/proj.game12/ --project_name=game12 --scheme template-mobile --appstore --adhoc --teamid=1234"
	print ""
	print "argv:"
	print "  --appstore             export appstore ipa"
	print "  --adhoc                export adhoc ipa"
	print "  --channel*             channel for export filename"
	print "  --export_path*         export path"
	print "  --project_path         xcode project path"
	print "  --project_name         project name"
	print "  --scheme               scheme name(target name)"
	print "  --teamid               apple team id"
	print "  --version*             version for export filename"











##### 入口 #####
def main():
    # print("Xcode Exporter is running.")

    config = {}

    try:
        opts, args = getopt.getopt(
            sys.argv[1:],
            "",
            # ["--project_path=/Users/ude2/prj.game12/framework/runtimes-src/proj.ios_mac/", "--project_name=game12", "--scheme=template-mobile", "--appstore", "--adhoc", "--teamid=1234"], "", 
            ["export_path=", "appstore", "adhoc", "project_path=", "project_name=", "teamid=", "scheme=", "version=", "channel=", "help"]
            )

        for _, v in enumerate(opts):
            config[v[0][2:]] = v[1]

        # print sys.argv
        # print config

        # 检查必填字段
        must_keys = ["project_path", "project_name", "teamid", "scheme"]
        for _, key in enumerate(must_keys):
            if config.get(key) == None:
                print "arg: [%s] not found!" % key
                print ""
                usage()
                exit()

        defaults = {
            "export_path":os.path.join(config["project_path"], "build", "export")
            }
        for (k, v) in defaults.items():
            if config.get(k) == None:
                config[k] = v

    except getopt.GetoptError:
        print "argv is wrong!"
        usage()

    if config.get("help"):
        usage()
        exit()

    try:
        # print "config: ", config
        export(config)
    except Exception, e:
        print "export has some error!", e
        raise

    # print("Xcode Exporter is finished.")

main()