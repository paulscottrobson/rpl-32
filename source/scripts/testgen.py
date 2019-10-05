# ******************************************************************************
# ******************************************************************************
#
#		Name : 		testgen.py
#		Purpose : 	Generate test programs
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	5th October 2019
#
# ******************************************************************************
# ******************************************************************************

import random,sys
from makeprogram import *

# ******************************************************************************
#
#							Base test program class
#
# ******************************************************************************

class TestProgram(object):
	#
	def __init__(self,seed = None):
		if seed is None:
			random.seed()
			seed = random.randint(0,99999)
		random.seed(seed)
		sys.stderr.write("*** Test # "+str(seed)+ "***\n")
	#
	def create(self,count = 1):
		self.program = Program()
		for i in range(0,count):
			self.generateOne(self.program)
		self.program.addLine("stop")
		self.program.render(sys.stdout)
	#
	def getInteger(self):
		n = random.randint(0,10)
		if n == 0:
			return 0
		if n < 3:
			return random.randint(-10,10)
		if n < 6:	
			return random.randint(-100000,100000)
		return random.randint(-0x7FFFFFFF,0x7FFFFFFF)
	#
	def inRange(self,n):
		return abs(n) < 0x80000000
	#
	def c(self,n):
		return str(n) if n >= 0 else str(abs(n))+"-"

# ******************************************************************************
#
#								arithmetic tests
#
# ******************************************************************************

class MathTest(TestProgram):
	def __init__(self,seed = None):
		TestProgram.__init__(self,seed)
		self.options = "<,>,>=,<=,=,<>,+,-,*,/,and,or,xor".split(",")

	def generateOne(self,prg):
		prg.echo = True
		ok = False
		while not ok:
			ok = True
			result = None
			op = self.options[random.randint(0,len(self.options)-1)]
			n1 = self.getInteger()
			n2 = self.getInteger()
			if op == "+":
				result = n1 + n2
			if op == "-":
				result = n1 - n2
			if op == "*":
				result = n1 * n2
			if op == "/" or op == "mod":
				if n2 == 0:
					ok = False
				else:
					result = int(n1/n2) if op == "/" else abs(n1 % n2)
			if op == "<":
				result = -1 if n1 < n2 else 0
			if op == "<=":
				result = -1 if n1 <= n2 else 0
			if op == ">":
				result = -1 if n1 > n2 else 0
			if op == ">=":
				result = -1 if n1 >= n2 else 0
			if op == "=":
				result = -1 if n1 == n2 else 0
			if op == "<>":
				result = -1 if n1 != n2 else 0
			if op == "and":
				result = n1 & n2
			if op == "or":
				result = n1 | n2
			if op == "xor":
				result = n1 ^ n2

			if ok:
				assert result is not None
				ok = self.inRange(result)

		prg.addLine(self.c(n1)+" "+self.c(n2)+" "+op+" "+self.c(result)+" = assert")

if __name__ == "__main__":
	MathTest().create(500)
