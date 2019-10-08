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
		self.nextLine = 100
		self.code = []
		self.echo = False
	#
	def addLine(self,txt):
		txt = txt.strip().replace("\t"," ").replace("\n"," ")
		if self.echo:
			sys.stderr.write("{0:5} {1}\n".format(self.nextLine,txt))
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
		h.write("; size {0}".format(len(self.code)))

if __name__ == "__main__":
	src = """

	12345
	54321
	. end
	def star 42 emit ;
	def emit ^a &FFD2 sys ;

""".split("\n")
	program = Program()
	for s in src:
		if s.strip() != "":
			program.addLine(s)
	program.render(sys.stdout)

