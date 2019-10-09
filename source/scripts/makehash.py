# ******************************************************************************
# ******************************************************************************
#
#		Name : 		makehash.py
#		Purpose : 	Generate tables for hash files.
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	9th October 2019
#
# ******************************************************************************
# ******************************************************************************

def toIdentifier(c):
	c = ord(c[0].upper())-1 if c != '.' else 31
	return c | 0xC0

def calcHash(s):
	return toIdentifier(s[0]) & 15

import os,re
#
#		Scan generated/library.inc 	for library functions
#
libFunc = {} 									# Function -> Label
for l in [x for x in open("generated"+os.sep+"library.inc").readlines()]:
	if l.find(";;") >= 0:
		m = re.match("^(.*?)\\:\\s*\\;\\;\\s*\\[(.*?)\\]$",l)
		assert m is not None,"Bad library line "+l
		libFunc[m.group(2).strip().upper()] = m.group(1).strip()
#
#		Create entries for each hash, and link them together to make
#		the default hash tables.
#
hashTable = []
labelCount = 1000
libFuncs = [x for x in libFunc.keys()]
hashHeader = [ None ] * 16
for hashNo in range(0,16):
	nextLink = "0"
	for l in libFuncs:
		if calcHash(l) == hashNo:
			currLbl = "libfunc_{0}".format(labelCount)
			print(currLbl+": ; "+l)
			print("\t.word "+nextLink)
			print("\t.dword "+libFunc[l])
			print("\t.word "+currLbl+"_name")
			print("\t.byte 0,'C'")
			#
			print(currLbl+"_name:")
			b = [toIdentifier(c) for c in l.upper()]
			b[-1] = b[-1] | 0xE0
			print("\t.byte "+",".join(["${0:02x}".format(x) for x in b]))
			labelCount += 1
			nextLink = currLbl
	hashTable.append(nextLink)
print(";\n;\tDefault hash table\n;")
print("DefaultHashTable:")
for l in hashTable:
	print("\t.word "+l)