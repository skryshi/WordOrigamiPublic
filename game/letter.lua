-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local LetterClass = {}
	LetterClass.spelling = ""
	LetterClass.score = 0
	LetterClass.lmult = 1
	LetterClass.wmult = 1
	LetterClass.i = nil
	LetterClass.j = nil

	----------------------------------------------------------
	function LetterClass:init(o)
		self.spelling = o.spelling or o.l
		self.score = o.score or o.s
		self.wmult = o.wmult or o.wm
		self.lmult = o.lmult or o.lm
		self.i = o.i
		self.j = o.j
		return self
	end

	----------------------------------------------------------
	function LetterClass:isEqual(letter)
		return self.i == letter.i and self.j == letter.j
	end
	
	----------------------------------------------------------
	function LetterClass:removeSelf()
	end

	----------------------------------------------------------
	LetterClass:init(o)

	return LetterClass
end

return class
