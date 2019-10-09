# ******************************************************************************
# ******************************************************************************
#
#		Name : 		makelib.py
#		Purpose : 	Generate library file
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	9th October 2019
#
# ******************************************************************************
# ******************************************************************************

import os

libFile = "scripts/libs/cx16.lib"
#
#		Load and preprocess
#
src = [x.strip() for x in open(libFile).readlines() if not x.startswith(";")]
src = [x.replace(".",os.sep) for x in src]
#
#		Work through them all, copy to stdout
#
for section in src:
	for root,dirs,files in os.walk(".."+os.sep+"library"+os.sep+section):
		for f in [x for x in files if x.endswith(".asm")]:
			asm = root + os.sep + f
			code = [x.rstrip() for x in open(asm).readlines()]
			print("\n".join(code))
			