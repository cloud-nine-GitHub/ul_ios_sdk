#!/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import shutil
import csv
import codecs




##### make #####
def make(path):
	gitignore_filename = os.path.join(path, ".gitignore")

	# .gitignore
	ignores = [
		"package",
		"_proj*",
		"build",
		]
	lines = []
	if os.path.exists(gitignore_filename):
		# 已经存在，提取数据
		f = open(gitignore_filename, "rb")
		try:
			lines = f.readlines()
		finally:
			f.close()
	# print "lines", lines

	# print "liens", lines
	for key in ignores:
		# print key
		key = "%s\n" % key
		if not key in lines:
			lines.append(key)

	# print "lines", lines

	f = open(gitignore_filename, "wb")
	try:
		f.writelines(lines)
	finally:
		f.close()


	# make_config
	if os.path.exists(os.path.join(path, "__make_config")):
		print "__make_config already exists"
	else:
		shutil.copytree("__make_config", os.path.join(path, "__make_config"))

	# sh
	cd = os.getcwd()
	print "cd is:",cd
	print "path",path

	sh_lines = []
	#使用ruby环境
	sh_lines.append('rvm use system\n')
	#sh_lines.append('root_path=$(pwd)/..\n')
	sh_lines.append('root_path=%s\n' % path)
	# sh_lines.append('xcode_make_path=%s\n' % os.path.relpath(cd, os.path.join(path, "__make_config")))
	sh_lines.append('xcode_make_path=%s\n' % cd)
	sh_lines.append('python $xcode_make_path/make.py %s/__make_config/make_config.json $root_path\n' % path)

	sh_filename = os.path.join(path, "__make_config", "make.sh")
	f = open(sh_filename, "wb")
	try:
		f.writelines(sh_lines)
	finally:
		f.close()






##### init csv ####
def addcsv(gamename,rootpath):
	ID="0"
	paths=[]
	with open('../xcode_allexporter/exporter.csv','rb') as csvfile:
		reader = csv.DictReader(csvfile)
		paths=[row['游戏根目录'] for row in reader]
		# print "已有配置项路基：",paths
	with open('../xcode_allexporter/exporter.csv','rb') as csvfile:
		reader = csv.DictReader(csvfile)
		for ids in reader:
			if int(ID)<int(ids['ID']):
				ID=ids['ID']
		print "已有配置项：",ID
	for path in paths:
		if path==rootpath:
			print "该游戏已经写入csv，修改游戏名请自行修改csv"
			return
	with open('../xcode_allexporter/exporter.csv','ab') as csvfile:
		# csvfile.write(codecs.BOM_UTF8)
		fieldnames=['ID','是否出包','游戏名','游戏根目录']
		writer=csv.DictWriter(csvfile, fieldnames=fieldnames)
		if ID!='0':
			ID=str(int(ID)+1)
		else:
			ID='1'
		lingstring={'ID':ID,'是否出包':'FALSE','游戏名':gamename,'游戏根目录':rootpath}
		writer.writerow(lingstring)
		print "写入csv成功"
		csvfile.close()

##### main #####
def main():
	# if len(sys.argv) <= 1:
	# 	print "root_path not found!"
	# 	print "please take proj.ios_mac's root path with arg."
	# 	print "like: '/Users/ulmini-two/work/ude2/prj.game12/client/frameworks/runtime-src"
	# 	return

	# # root_path = sys.argv[1]
	# root_path = "/Users/ulmini-two/work/ude2/prj.game12/client/frameworks/runtime-src"
	all_the_text = open('xcode_make.txt').read()
	print all_the_text

	root_name = raw_input("请输入游戏名称:\n")
	# print "root_name", root_name
	root_path = raw_input("请输入游戏工程根目录:\n")
	root_path = root_path.strip()

	# print "root_path", root_path

	addcsv(root_name,root_path)

	make(root_path)

	print "success!"

main()