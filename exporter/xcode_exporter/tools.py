#!/bin/python
# -*- coding: utf-8 -*-

import os
import plistlib

EXPORT_OPTIONS_PLIST_APPSTORE_FILENAME = "export_options_appstore.plist"
EXPORT_OPTIONS_PLIST_ADHOC_FILENAME = "export_options_adhoc.plist"








##### 辅助函数 #####
def createExportOptionsPlist(path, teamId, uploadBitcodeFlag):
    print "createExportOptionsPlist"
    print "path", path
    print "teamId", teamId

    appstoreFilename = os.path.join(path, EXPORT_OPTIONS_PLIST_APPSTORE_FILENAME)
    adhocFilename = os.path.join(path, EXPORT_OPTIONS_PLIST_ADHOC_FILENAME)

    deleteExportOptionsPlist(path)

    # 生成文件
    plistlib.writePlist(dict(teamID = teamId, method = "app-store", uploadSymbols = True, uploadBitcode = uploadBitcodeFlag), appstoreFilename)
    plistlib.writePlist(dict(teamID = teamId, method = "ad-hoc", compileBitcode = False), adhocFilename)

def deleteExportOptionsPlist(path):
    appstoreFilename = os.path.join(path, EXPORT_OPTIONS_PLIST_APPSTORE_FILENAME)
    adhocFilename = os.path.join(path, EXPORT_OPTIONS_PLIST_ADHOC_FILENAME)

    # 尝试删除已存在的文件
    if os.path.exists(appstoreFilename):
        os.remove(appstoreFilename)

    if os.path.exists(adhocFilename):
        os.remove(adhocFilename)
