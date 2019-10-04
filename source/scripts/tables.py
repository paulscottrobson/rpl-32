# ******************************************************************************
# ******************************************************************************
#
#		Name : 		tables.py
#		Purpose : 	RPL/32 Tables Classes
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	3rd October 2019
#
# ******************************************************************************
# ******************************************************************************

import re,os,sys
from tokens import *

tokens = RPLTokens().getTokens()										# get the tokens
tokenNames = [x for x in tokens.keys()]									# token list
tokenNames.sort(key = lambda x:tokens[x])								# sort them in order.
#
#		Keyword table. Each is preceded by a length, length = 0 => end.
#
print("; *** Generated by tables.py ***\n")
print("KeywordText:")
for i in range(0,len(tokenNames)):
	assert tokens[tokenNames[i]] == i+0x10								# check consistency
	name = tokenNames[i] if tokenNames[i] != "{-}" else "-"				# convert constant minus
	for c in [ord(x) for x in name]:									# check legal 6 bit ASCII
		assert c >= 32 and c < 96
	kbytes = [ord(x) & 0x3F for x in name]								# convert to ASCII
	kbytes.insert(0,len(kbytes))										# insert length
	kbytes = ",".join(["${0:02x}".format(c) for c in kbytes])			# make byte string
	print("\t.byte {0:32} ; ${1:02x} {2}".format(kbytes,i+0x10,tokenNames[i]))
print("\t.byte $00\n")
#
#		Collect addresses from the various routines
#
routines = { }
for root,dirs,files in os.walk(".."):									# scan all source dirs
	for f in files:
		if f.endswith(".asm"):											# check asm files for ;;
			for l in [x for x in open(root+os.sep+f).readlines() if x.find(";;") >= 0]:
				m = re.match("^(.*?)\\:\\s*\\;\\;\\s*\\[(.*)\\]\\s*$",l)# does it match ?
				assert m is not None,"Bad keyword line "+l
				kw = m.group(2).strip().upper()							# keyword
				assert kw not in routines,"Duplicate definition "+kw
				assert kw in tokens,"Unknown keyword "+kw
				routines[kw] = m.group(1)
#
#		Work out the "todo" list.
#
notDone = [ "[]","{-}" ]
missing = [x for x in tokenNames if x not in routines and x not in notDone]
if len(missing) > 0:
	sys.stderr.write("Missing ({1}) {0}\n".format(" ".join([x.lower() for x in missing]),len(missing)))
#
#		Generate a jump table
#
print("KeywordVectorTable:")
for i in range(0,len(tokenNames)):
	handler = routines[tokenNames[i]] if tokenNames[i] in routines else "SyntaxError" 
	print("\t.word {0:32} ; ${1:02x} {2}".format(handler,i+0x10,tokenNames[i]))
print()
#
#		Generate constants
#
for i in range(0,len(tokenNames)):
	s = "KWD_"+tokenNames[i]	
	s = s.replace("{-}","CONSTANT_MINUS")	
	s = s.replace(" ","SPACE").replace("!","PLING").replace("#","HASH").replace("[","LSQPAREN")
	s = s.replace("]","RSQPAREN").replace("*","ASTERISK").replace("+","PLUS").replace("-","MINUS")
	s = s.replace("/","SLASH").replace("<","LESS").replace("=","EQUAL").replace(">","GREATER")
	s = s.replace("@","AT").replace("^","HAT").replace("%","PERCENT").replace("&","AMPERSAND")
	s = s.replace(";","SEMICOLON")
	assert re.match("^[A-Z\\_]*$",s) is not None
	s = "{0} = ${1:02x}".format(s,i+0x10)								# code and write it
	print("{0:32} ; ${1:02x} {2}".format(s,i+0x10,tokenNames[i]))
