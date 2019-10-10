import math

spriteData = [ 0 ] * 512 		# 32 x 32 4 bit colour

def setPixel(spr,x,y,c):
	offset = (x >> 1) + y * 16
	mask = 0xF0
	c = c & 0x0F
	if x % 2 != 1:
		mask = 0x0F
		c = c << 4
	spriteData[offset] = (spriteData[offset] & mask) | c

for x in range(0,32):
	for y in range(0,32):
		c = (x >> 3) * 4 + (y >> 3)
		c = 15 if c == 0 else c
		x1 = math.sqrt((x-16)*(x-16)+(y-16)*(y-16))
		if x1 <= 15:
			setPixel(spriteData,x,y,c)

h = open("DEMO","wb")
h.write(bytes(spriteData))
h.close()