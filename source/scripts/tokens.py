# ******************************************************************************
# ******************************************************************************
#
#		Name : 		tokens.py
#		Purpose : 	RPL/32 Tokens Class
#		Author : 	Paul Robson (paul@robsons.org.uk)
#		Created : 	3rd October 2019
#
# ******************************************************************************
# ******************************************************************************

# ******************************************************************************
#
#					Encapsulate language tokens and values
#
# ******************************************************************************

class RPLTokens(object):
	def __init__(self):
		if RPLTokens.tokens is None:										# Create static member
			tokens = [x for x in self.getTokenSource().upper().split()]		# Convert to list
			tokens.append(" ")												# Space is a token
			tokens.sort()													# sort them.
			RPLTokens.tokens = {} 											# add them all 
			for i in range(0,len(tokens)): 									# map name -> token
				RPLTokens.tokens[tokens[i]] = i + 0x10
			assert len(tokens)+0x10 < 0x80,"Too many tokens"				# check count.

	def getTokens(self):
		return RPLTokens.tokens

	def getTokenSource(self):
		return """
		++		--		<<		>> 
		+ 		-		*		/		mod		
		and		or 		xor
		<= 		>= 		=		<> 		> 		<
		negate	not 	abs		alloc
		@ 		! 		c@ 		c! 		w@ 		w!
		dup		drop 	over 	nip 	swap	empty
		for 	index 	next
		repeat 	until
		if 		else 	then		
		def 	; 		&
		sys 	list	new 	old		run		stop	end 
		^		[]		{-}		
"""		
RPLTokens.tokens = None														# Static tokens

if __name__ == "__main__":
	s = RPLTokens()
	print(s.getTokens())