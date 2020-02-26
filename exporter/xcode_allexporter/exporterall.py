#!/bin/python
# -*- coding: utf-8 -*-
import csv
import os
def exporter(conf):
	print conf['游戏根目录']
	path=conf['游戏根目录']
	 # cmd = "xcodebuild -quiet -exportArchive -archivePath %s -exportOptionsPlist %s -exportPath %s" % (xcarchiveName, tools.EXPORT_OPTIONS_PLIST_APPSTORE_FILENAME, exportPath)
  #       print cmd
  #       os.system(cmd)
	cmd="source %s/__make_config/make.sh" %(path)
	print cmd
	os.system(cmd)
def readCsv():
	with open('exporter.csv','rb') as csvfile:
		reader = csv.DictReader(csvfile)
		for row in reader:
			if row['是否出包']=='TRUE':
				exporter(row)

def main():
	readCsv()

main()