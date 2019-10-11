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

import os,re

def toIdentifier(c):
	c = ord(c[0].upper())-1 if c != '.' else 31
	return c | 0xC0

def calcHash(s):
	return toIdentifier(s[-1]) & 15

def loadAssembly(libFuncs,asmFile):
	group = None
	l = [x.strip().upper() for x in open(asmFile).readlines() if not x.startswith(";")]
	for l in [x.replace("\t"," ") for x in l if x != ""]:
		if re.match("^\\[\\d\\]$",l) is not None:
			group = int(l[1])
		else:
			m = re.match("^\\$([0-9A-F]+)\\s*(\\w+)$",l)
			assert m is not None,l+" fails"
			libFuncs[m.group(2).strip()] = "${0:X}".format(int(m.group(1),16)+(group << 8)+0xFFFF0000)
			#print(libFuncs[m.group(2).strip()])			
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
#		Load assembly LibFuncs.
#
loadAssembly(libFunc,"assembler.dat")
#
#		Create entries for each hash, and link them together to make
#		the default hash tables.
#
hashTable = []
labelCount = 1000
libFuncs = [x for x in libFunc.keys()]
#
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
			print("\t.byte 0,'{0}'".format('A' if libFunc[l].startswith("$FFFF") else 'C'))
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