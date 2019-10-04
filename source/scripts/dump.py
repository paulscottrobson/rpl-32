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
