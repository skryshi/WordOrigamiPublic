-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local WordClass = {}
	WordClass.spelling = ""
	WordClass.score = 0
	WordClass._letters = {}

	----------------------------------------------------------
	function WordClass:addLetters(letters)
		for _, v in ipairs(letters) do
			self:addLetter(v)
		end
	end

	----------------------------------------------------------
	function WordClass:addLetter(letter)
		self._letters[#self._letters + 1] = letter
		self.spelling = self.spelling .. letter.spelling
		self:_updateScore()
	end
	
	----------------------------------------------------------
	function WordClass:_updateScore()
		self.score = 0
		local wmult = 1
		for _, v in ipairs(self._letters) do
			self.score = self.score + v.score * v.lmult
			wmult = wmult * v.wmult
		end
		self.score = self.score * wmult
	end
	
	----------------------------------------------------------
	function WordClass:isEqual(word)
		return Json.encode(self.letters) == Json.encode(word.letters)
	end
	
	----------------------------------------------------------
	function WordClass:isEqualSpelling(word)
		return Json.encode(self.spelling) == Json.encode(word.spelling)
	end

	----------------------------------------------------------
	function WordClass:hasLetter(letter)
		for _, v in ipairs(self._letters) do
			if v:isEqual(letter) then
				return true
			end
		end
		return false
	end
	
	----------------------------------------------------------
	function WordClass:getLastLetter()
		return self._letters[#self._letters]
	end
	
	----------------------------------------------------------
	function WordClass:removeSelf()
	end

	----------------------------------------------------------
	return WordClass
end

return class
