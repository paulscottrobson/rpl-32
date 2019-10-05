# ******************************************************************************
# ******************************************************************************
#
#		Name : 		dump.py
#		Purpose : 	Show status
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	3rd October 2019
#
# ******************************************************************************
# ******************************************************************************

import os,sys

def deek(a):
	return data[a]+(data[a+1] << 8)

def getName(a):
	nw = (((data[a]<<8)+data[a+1]) & 0x7FFF)-0x2000
	s = ""
	while nw != 0:
		c = nw % 28
		c = c+96 if c != 27 else ord('.')
		s = chr(c)+s
		nw = int(nw/28)
	return s+getName(a+2) if data[a] < 128 else s

if not os.path.isfile("dump.bin"):
	sys.exit(0)

data = [x for x in open("dump.bin","rb").read(-1)]
#
#		Get SP in X
#
stackp = data[1]
#
#		Extract the stack
#
data = data[7:65536+7]
stack = []
for i in range(1,stackp+1):
	w = data[0xC00+i]+(data[0xD00+i]<<8)+(data[0xE00+i]<<16)+(data[0xF00+i]<<24)
	w = w if (w & 0x80000000) == 0 else w - 0x100000000	
	stack.append(w)
print("Stack :")
print("\t"+" ".join(["{0}".format(x) for x in stack]))
print("\t"+" ".join(["${0:x}".format(x & 0xFFFFFFFF) for x in stack]))
#
#		Variable Dump
#
print("Statics :")
svar = []
for i in range(0,26):
	p = 0x1000+i*4
	w = data[p+0]+(data[p+1]<<8)+(data[p+2]<<16)+(data[p+3]<<24)
	sw = w if (w & 0x80000000) == 0 else w - 0x100000000	
	#print("{0:x}".format(p))
	#
	if sw != 0:
		svar.append("{0} := {1}".format(chr(i+97),sw))

print("\t"+" ".join(svar))

hashTable = 0x1068
hashCount = 16
print("Variables :")
for i in range(0,hashCount):
	hashEntry = hashTable+i*2
	print("\t# {0:2} ${1:04x}".format(i,hashEntry))
	p = deek(hashEntry)
	while p != 0:
		p2 = deek(p+6)
		done = False
		name = ""
		while not done:
			done = (data[p2] >= 0xE0)
			c = data[p2] & 0x1F
			name = name + (chr(c+65) if c != 31 else '.')
			p2 += 1
		name = name.lower()
		w = data[p+2]+(data[p+3]<<8)+(data[p+4]<<16)+(data[p+5]<<24)
		sw = w if (w & 0x80000000) == 0 else w - 0x100000000	
		print("\t\t${0:04x} [{4}] {1} := {2} ${3:x}".format(p,name,sw,w,chr(data[p+9])))
		p = deek(p)
