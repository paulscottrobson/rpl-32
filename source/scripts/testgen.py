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
from tokens import *

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
		sys.stderr.write("*** Test # "+str(seed)+" "+self.getName()+" ***\n")
		self.tokens = RPLTokens().getTokens()
	#
	def create(self,count = 1,echo = False):
		self.program = Program()
		self.program.echo = echo
		self.createBody(count,self.program)
		self.program.addLine("stop")
		self.program.render(sys.stdout)
	#
	def createBody(self,count,prg):
		for i in range(0,count):
			self.generateOne(prg)
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

	def getName(self):
		return "Maths"

	def generateOne(self,prg):
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

# ******************************************************************************
#
#								unary tests
#
# ******************************************************************************

class UnaryTest(TestProgram):
	def __init__(self,seed = None):
		TestProgram.__init__(self,seed)
		self.options = "not,negate,abs,++,--,>>,<<".split(",")

	def getName(self):
		return "Unary"
		
	def generateOne(self,prg):
		ok = False
		while not ok:
			ok = True
			result = None
			op = self.options[random.randint(0,len(self.options)-1)]
			n1 = self.getInteger()
			if op == "not":
				result = n1 ^ 0xFFFFFFFF
			if op == "abs":
				result = abs(n1)
			if op == "negate":
				result = (-n1) & 0xFFFFFFFF
			if op == "++" or op == "--":
				result = n1+(1 if op == "++" else -1)
				ok = self.inRange(n1)
			if op == "<<" or op == ">>":
				result = (n1 << 1) if op == "<<" else (n1 >> 1) & 0x7FFFFFFF
				result = result & 0xFFFFFFFF
		prg.addLine(self.c(n1)+" "+op+" "+self.c(result)+" = assert")

# ******************************************************************************
#
#						assignment/identifier  tests
#
# ******************************************************************************

class AssignmentTest(TestProgram):

	def getName(self):
		return "Assignment"
		
	def createBody(self,count,prg):
		self.variables = {}
		while len(self.variables.keys()) != count:
			newVar = "".join([chr(random.randint(0,25)+97) for x in range(0,random.randint(1,5))])
			if newVar.upper() not in self.tokens:
				self.variables[newVar] = self.getInteger()			
		vList = [x for x in self.variables.keys()]
		for k in vList:
			prg.addLine(self.c(self.variables[k])+" ^"+k)
		self.check(prg)
		for p in range(1,5):
			for n in range(0,count >> 1):
				v = vList[random.randint(0,len(vList)-1)]
				self.variables[v] = self.getInteger()
				prg.addLine(self.c(self.variables[v])+" ^"+v)
			self.check(prg)

	def check(self,prg):
		for k in self.variables.keys():
			prg.addLine(self.c(self.variables[k])+" "+k+ " = assert")

if __name__ == "__main__":
	t = 0 if len(sys.argv) == 1 else int(sys.argv[1])
	if t == 0:
		AssignmentTest(53167).create(200,True)
	if t == 1:
		MathTest().create(500)
	if t == 2:
		UnaryTest().create(500)
	if t == 3:
		AssignmentTest().create(200)
