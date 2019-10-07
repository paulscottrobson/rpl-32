# ******************************************************************************
# ******************************************************************************
#
#		Name : 		banner.py
#		Purpose : 	Create Banner.
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	5th October 2019
#
# ******************************************************************************
# ******************************************************************************

from datetime import datetime

build = 3

d = datetime.now().strftime("%d-%b-%Y")

s = "**** RPL/32 Interpreter ****"
s = s + chr(13)+chr(13)

s = s + "Build:"+(str(build) if build > 0 else "Dev")+" Date:"+d
s = s + chr(13)+chr(13)

s = s + chr(0)
b = [ord(c) for c in s.upper()]
print("\t.byte {0}".format(",".join(["${0:02x}".format(n) for n in b])))