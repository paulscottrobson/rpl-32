# ******************************************************************************
# ******************************************************************************
#
#		Name : 		makeprogram.py
#		Purpose : 	Create a program tokenised in RPL/32
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	3rd October 2019
#
# ******************************************************************************
# ******************************************************************************

from tokeniser import *
import sys

# ******************************************************************************
#
#									Program class
#
# ******************************************************************************

class Program(object):
	def __init__(self):
		self.tokeniser = Tokeniser()
		self.nextLine = 1000
		self.code = []
	#
	def addLine(self,txt):
		txt = txt.strip().replace("\t"," ").replace("\n"," ")
		code = self.tokeniser.tokenise(txt)
		self.code.append(len(code)+3)
		self.code.append(self.nextLine & 0xFF)
		self.code.append(self.nextLine >> 8)
		self.code += code
		self.nextLine += 10
	#
	def render(self,h):
		s = ",".join(["${0:02x}".format(x) for x in self.code])	
		h.write("; **** Generated by makeprogram.py ****\n")		
		h.write("\t.byte {0}\n".format(s))

if __name__ == "__main__":
	src = """
	12345 144 ^z 991 ^a
	42 ^dennis 2- ^the.menace
	514 ^dennis 512- dup ^the ^the.menace
	54321 stop
	def bcd 1 2 3
	def bat.cc 4 5 6	
	def hello.world
""".split("\n")
	program = Program()
	for s in src:
		if s.strip() != "":
			program.addLine(s)
	program.render(sys.stdout)

