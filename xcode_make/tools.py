#!/bin/python
# -*- coding: utf-8 -*-

import csv
import json

def parseConfig(filename):
	with open(filename, "rb") as csvfile:
		reader = csv.reader(csvfile)

		types = {
			# [index] = type,
		}

		fields = {
			# [index] = name,
		}

		datas = []

		for row in reader:
			cmd = row[0]

			if cmd == "FLDTYPE":
				for i, v in enumerate(row):
					if 0 < i and v != "":
						types[i] = v

				# print "types", types


			elif cmd == "FLDNAME":
				for (i, type) in types.items():
					fields[i] = row[i]

				# print "fields", fields

			elif cmd == "DATA":
				data = {}
				for (i, type) in types.items():
					field = fields[i]

					# print i, type, field, row[i]

					value = None
					if type == "S":
						value = row[i]

					elif type == "T":
						if row[i] == "":
							value = []
						else:
							value = row[i].split(",")

						for k, v in enumerate(value):
							value[k] = v.strip()

					data[field] = value

				datas.append(data)

	return datas

def parseJson(filename):
	file_obj = open(filename)
	try:
	     text = file_obj.read()
	     return json.loads(text)
	finally:
	     file_obj.close()

	return {}
