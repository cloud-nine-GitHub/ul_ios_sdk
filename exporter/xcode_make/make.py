#!/bin/python
# -*- coding: utf-8 -*-

import tools
import sys
import json
import os
import shutil
import plistlib
from mod_pbxproj import XcodeProject









##### make相关 #####
def make_by_config(rootPath, config):
	print "make_by_config", config["channel"]

	# 1. 生成参数
	src_project_path = os.path.join(rootPath, config["src_project_path"])
	dst_project_path = os.path.join(rootPath, "_proj.ios_%s" % config["channel"])
	sdk_path = os.path.join(sys.path[0], "..", "..", "modules")
	codes_path = os.path.join(sys.path[0], "..", "..", "codes")
	exporter_script = os.path.join(sdk_path, "..", "exporter", "xcode_exporter", "exporter.py")



	print "  path", src_project_path, dst_project_path

	# 2. 创建子工程
	if os.path.exists(dst_project_path):
		print "  os.removedirs(%s)" % dst_project_path
		shutil.rmtree(dst_project_path)

	print "  shutil.copytree(%s, %s)" % (src_project_path, dst_project_path)
	shutil.copytree(src_project_path, dst_project_path)

	# 删除build
	if os.path.exists(os.path.join(dst_project_path, "build")):
		shutil.rmtree(os.path.join(dst_project_path, "build"))

	xcodeproj_filename = os.path.join(dst_project_path, "%s.xcodeproj" % config["project_name"])
	pbxproj_filename = os.path.join(xcodeproj_filename, "project.pbxproj")

	print "  XcodeProject.Load(%s)" % pbxproj_filename
	project = XcodeProject.Load(pbxproj_filename)

	# 3rdparts  ulsdk
	ulsdk_group = project.get_or_create_group("ulsdk")
	if config.has_key("3rdparts"):
		for _, f in enumerate(config["3rdparts"]):
			print "  project.add_folder(%s, parent = group_3rdparts)" % os.path.join(sdk_path, f)
			project.add_folder(os.path.join(sdk_path, f), parent = ulsdk_group)
			# 3d特殊处理
			if config.has_key("game_type") and config["game_type"] == "3d":
				# 添加-fno-objc-arc
				dirs = os.listdir(os.path.join(sdk_path, f))
				print "dirs %s" % dirs
				for i in dirs:                             # 循环读取路径下的文件并筛选输出
				    if os.path.splitext(i)[1] == ".mm":   # 筛选mm, m文件
			        	fileId = project.get_file_id_by_path("../../../prj.ulsdk/UISDK/ios/" + f + "/" + i)
			        	# print "fileId(%s)" % fileId
			        	files = project.get_build_files(fileId)
			        	# print "files %s" % files
			        	for file in files:
			        		file.add_compiler_flag("-fno-objc-arc")

			        # 特殊处理2个文件夹
				    if os.path.splitext(i)[0] == "ZYNetworkAccessibity" or os.path.splitext(i)[0] == "Utils":
				    	dirs1 = os.listdir("../../../prj.ulsdk/UISDK/ios/ULSDK/ZYNetworkAccessibity")
				    	if os.path.splitext(i)[0] == "Utils":
				    		dirs1 = os.listdir("../../../prj.ulsdk/UISDK/ios/ULSDK/Utils")
				    	print "dirs1 %s" % dirs1
				    	for j in dirs1:
				    		if os.path.splitext(j)[1] == ".m" or os.path.splitext(j)[1] == ".mm":
				    			fileId1 = project.get_file_id_by_path("../../../prj.ulsdk/UISDK/ios/ULSDK/ZYNetworkAccessibity/" + j)
				    			if os.path.splitext(i)[0] == "Utils":
				    				fileId1 = project.get_file_id_by_path("../../../prj.ulsdk/UISDK/ios/ULSDK/Utils/" + j)
				    			files1 = project.get_build_files(fileId1)
				    			for file1 in files1:
				    				file1.add_compiler_flag("-fno-objc-arc")

	# codes
	if config.has_key("codes"):
		# 在ulsdk目录下再创建codes目录
		group_codes = project.get_or_create_group("codes", parent = ulsdk_group)
		for _, f in enumerate(config["codes"]):
			project.add_folder(os.path.join(codes_path, f), parent = group_codes)

	# preprocessors
	if config.has_key("preprocessors"):
		for _, p in enumerate(config["preprocessors"]):
			print "  project.add_preprocessor(%s)" % p
			project.add_preprocessor(p)

	# search_path
	if config.has_key("header_search_paths"):
		print "  project.add_header_search_paths(%s)" % config["header_search_paths"]
		project.add_header_search_paths(config["header_search_paths"])
	if config.has_key("framework_search_paths"):
		print "  project.add_framework_search_paths(%s)" % config["framework_search_paths"]
		project.add_framework_search_paths(config["framework_search_paths"])
	if config.has_key("libaray_search_paths"):
		print "  project.add_library_search_paths(%s)" % config["libaray_search_paths"]
		project.add_library_search_paths(config["libaray_search_paths"])

	# 3d特殊处理
	if config.has_key("game_type") and config["game_type"] == "3d":
		if config.has_key("enable_bitcode"):
			# enable_bitcode
			for _, flag in enumerate(config["enable_bitcode"]):
				print " project.enable_bitcode(%s)" % (flag)
				if config["enable_bitcode"]=="NO":
					project.add_flags({"ENABLE_BITCODE":"NO"})

		if config.has_key("enable_objective-c_exceptions"):
			# enable_objective-c_exceptions
			for _, flag in enumerate(config["enable_objective-c_exceptions"]):
				if config["enable_objective-c_exceptions"]=="YES":
					print " project.c_exceptions(%s) " % config["enable_objective-c_exceptions"]
					project.add_flags({"GCC_ENABLE_OBJC_EXCEPTIONS": ["YES"]})

	# enable_modules
	if config.has_key("enable_modules") and config["enable_modules"] == "YES":
		project.add_flags({"CLANG_ENABLE_MODULES": ["YES"]})
			
	# other_link
	if config.has_key("other_link_flags"):
		for _, flag in enumerate(config["other_link_flags"]):
			print "  project.add_other_ldflags(%s)" % (flag)
			project.add_other_ldflags(flag)
			# weak_references_in_manual_retain_release
			if config.has_key("weak_references_in_manual_retain_release") and config["weak_references_in_manual_retain_release"]=="YES":
				project.add_flags({"CLANG_ENABLE_OBJC_WEAK":"YES"})

	# framework
	if config.has_key("frameworks"):
		group_Frameworks = project.get_or_create_group("Frameworks")
		for _, f in enumerate(config["frameworks"]):
			print "  project.add_file_if_doesnt_exist(%s, parent = group_Frameworks)" % f
			project.add_file_if_doesnt_exist(f, parent = group_Frameworks, tree = "SDKROOT")

	# resources
	if config.has_key("resources"):
		project.remove_group_by_name("Resources")
		# group_Resources = project.get_or_create_group(config["project_name"])
		group_Resources = project.get_or_create_group("Resources")
		for _, r in enumerate(config["resources"]):
			print "  project.add_file(%s, parent = group_Resources, create_build_files = True)" % os.path.join(rootPath, r)
			project.add_file(os.path.join(rootPath, r), parent = group_Resources, create_build_files = True)
	
	# C Language Dialect  gcc_c_language_standard
	if config.has_key("gcc_c_language_standard"):
		# 先删除本身的，再添加配置里面的
		project.remove_single_valued_flag("GCC_C_LANGUAGE_STANDARD")
		project.add_flags({"GCC_C_LANGUAGE_STANDARD" : config["gcc_c_language_standard"]})

	# Objective-C Automatic Reference Counting CLANG_ENABLE_OBJC_ARC
	if config.has_key("clang_enable_objc_arc"):
		# 先删除本身的，再添加配置里面的
		project.remove_single_valued_flag("CLANG_ENABLE_OBJC_ARC")
		project.add_flags({"CLANG_ENABLE_OBJC_ARC" : config["clang_enable_objc_arc"]})

	# embeded binaries
	if config.has_key("embeded"):
		project.add_embed_binaries(config["embeded"], config["scheme"])

	
	# 修改包名 package_name
	if config.has_key("package_name"):
		project.remove_single_valued_flag("PRODUCT_BUNDLE_IDENTIFIER")
		project.add_flags({"PRODUCT_BUNDLE_IDENTIFIER" : config["package_name"]})
		print "package_name===", config["package_name"]

	# 修改应用名 app_name
	if config.has_key("app_name"):
		project.remove_single_valued_flag("PRODUCT_NAME")
		project.add_flags({"PRODUCT_NAME" : config["app_name"]})
		print "app_name===", config["app_name"]

	project.save()

	# Info.plist
	info_plist_filename = os.path.join(dst_project_path, config["info_plist_path"], "Info.plist")
	# 3d特殊处理
	if config.has_key("game_type") and config["game_type"] == "3d":
		info_plist_filename = os.path.join(dst_project_path, "Info.plist")

	info_data = plistlib.readPlist(info_plist_filename)

	if info_data["CFBundleShortVersionString"]:
		info_data["CFBundleShortVersionString"] = config["version"]
	if info_data["CFBundleVersion"]:
		info_data["CFBundleVersion"] = config["build_version"]

	# 去掉UIMainStoryboardFile
	if info_data.has_key("UIMainStoryboardFile"):
		del info_data["UIMainStoryboardFile"]

	# 打上mod
	info_mod = config["info_plist_mod"]
	if info_mod != None:
		for k, v in info_mod.items():
			info_data[k] = v

	plistlib.writePlist(info_data, info_plist_filename)

	# 3. 打包
	if config["b_export"] and config["b_export"] == True:
		args = [
			"--channel=%s" % config["channel"],
			"--export_path=%s" % os.path.join(rootPath, "package"),
			"--project_path=%s" % dst_project_path,
			"--project_name=%s" % config["project_name"],
			"--scheme=%s" % config["scheme"],
			"--teamid=%s" % config["team_id"],
			"--version=%s_%s" % (config["version"], config["build_version"]),
			]

		for _, m in enumerate(config["export_methods"]):
			args.append("--%s" % m)

		cmd = "python %s %s" % (exporter_script, " ".join(args))
		print cmd
		cd = os.getcwd()
		os.chdir(dst_project_path)
		os.system(cmd)
		os.chdir(cd)

	else:
		print "config set b_export to false, do not export."




##### main #####
def main():
	if len(sys.argv) < 2:
		print "argv is error!"
		print "usage: python make.py config_path root_path"
		return

	filename = sys.argv[1]
	root_path = sys.argv[2]

	# filename = "make_config.json"
	# rootPath = "/Users/ulmini-two/work/ude2/prj.game12/client/frameworks/runtime-src"

	print "filename", filename
	print "root_path", root_path

	datas = tools.parseJson(filename)

	# print datas

	for (channel, data) in datas.items():
		data["channel"] = channel
		if not data["b_skip"]:
			make_by_config(root_path, data)


main()