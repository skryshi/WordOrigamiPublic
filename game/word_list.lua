-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local WordListClass = {}
	WordListClass.list = {}

	----------------------------------------------------------
	function WordListClass:init(o)
	end

	----------------------------------------------------------
	function WordListClass:add(word)
		print("WordListClass:add", word.spelling)
--		p(self.list)
--		p(self.list[word.spelling])
		if self.list[word.spelling] then
			local alreadyExists = false
			for _, v in pairs(self.list[word.spelling]) do
				if v:isEqual(word) then
					alreadyExists = true
				end
			end
			if not alreadyExists then
				-- same word, different path, add
				self.list[word.spelling][#self.list[word.spelling] + 1] = word
			end
		else
			-- new word, add
			self.list[word.spelling] = { word }
		end
	end
	
	----------------------------------------------------------
	function WordListClass:hasWord(word)
		if not self.list[word.spelling] then
			return false
		else
			for _, v in ipairs(self.list[word.spelling]) do
				if v:isEqual(word) then
					return true
				end
			end
		end
		return false
	end

	----------------------------------------------------------
	function WordListClass:hasWordSpelling(word)
		return not not self.list[word.spelling]
	end

	----------------------------------------------------------
	function WordListClass:removeSelf()
	end

	----------------------------------------------------------
	WordListClass:init(o)

	return WordListClass
end

return class
