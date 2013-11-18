-- Copyright 2013 Arman Darini
local TileClass = require("game.tile")
local WordClass = require("game.word")
local WordListClass = require("game.word_list")
local LetterClass = require("game.letter")
local LevelClass = require("game.level")

local class = {}
class.new = function(o)
	local LatticeClass = {}
	LatticeClass.view = nil
	LatticeClass.layer = nil
	LatticeClass.sheetInfo = require("assets.images.sheet-1x")
	LatticeClass.sheet = graphics.newImageSheet("assets/images/sheet-1x.png", LatticeClass.sheetInfo:getSheet())		
	LatticeClass.timers = {}
	LatticeClass.transitions = {}
	LatticeClass.currentWord = WordClass.new()
	LatticeClass.letters = {}
	LatticeClass.wordList = nil
	LatticeClass.playedWordList = nil
	LatticeClass.vertices = {}
	LatticeClass.width = 4
	LatticeClass.height = 4
	LatticeClass.tileSpaceX = 0
	LatticeClass.tileSpaceY = 0
	LatticeClass.pathLine = {}
	LatticeClass.pathTiles = {}
	
	----------------------------------------------------------
	function LatticeClass:init(o)
		self.layer = o.layer
		self.level = o.level
		self.playedWordList = WordListClass.new()
		self:_create()
		return self
	end

	----------------------------------------------------------
	function LatticeClass:_create()
		print("LatticeClass:_create")

		self.letters = {}
		for _, v in pairs(self.level.board) do
			if self.letters[v.i] then
				self.letters[v.i][v.j] = LetterClass.new(v)
			else
				self.letters[v.i] = { [v.j] = LetterClass.new(v) }
			end
		end
		p(self.letters)

		self.wordList = WordListClass.new()
		local word
		for _, v in pairs(self.level.words) do
			for _, w in ipairs(v) do
				word = WordClass.new()
				for _, u in ipairs(w) do
--					print("u[1]=", u[1] + 1, "u[2]=", u[2] + 1)
					word:addLetter(self.letters[u[1]][u[2]])
				end
				self.wordList:add(word)
			end
		end
	end

	----------------------------------------------------------
	function LatticeClass:touch(event)
		if "began" == event.phase then
			display.getCurrentStage():setFocus(event.target)
		end
		local tile = self:getTileFromXY(event.x, event.y)
		if nil ~= tile and ("began" == event.phase or "moved" == event.phase) then
			local letter = tile.letter
			if self:isInRange(letter) then
				self.pathTiles[#self.pathTiles + 1] = tile
				self:unscaleTiles()
				self.currentWord:addLetter(letter)
				tile:select()
				self:appendPathLine()
				Runtime:dispatchEvent({ name = "word", phase = "modified", word = self.currentWord.spelling })
			end
		elseif "ended" == event.phase or "cancelled" == event.phase then
			display.getCurrentStage():setFocus(nil)

			if self.wordList:hasWord(self.currentWord) and self.playedWordList:hasWord(self.currentWord) then
				Runtime:dispatchEvent({ name = "word", phase = "completed", result = "repeat", word = self.currentWord.spelling })
				self:unselectTiles()
				self.pathTiles = {}
				self:removePathLine()
			elseif self.wordList:hasWord(self.currentWord) then
				self.playedWordList:add(self.currentWord)
				Game.score = Game.score + self.currentWord.score
				Runtime:dispatchEvent({ name = "word", phase = "completed", result = "success", word = self.currentWord.spelling, score = self.currentWord.score })
				Runtime:dispatchEvent({ name = "score", score = Game.score })
				self:growTiles()
				timer.performWithDelay(300, function()
					self:unselectTiles()
					self.pathTiles = {}
					self:removePathLine()
				end, 1)
			else
				Runtime:dispatchEvent({ name = "word", phase = "completed", result = "failure", word = self.currentWord.spelling })
				self.view.bg:removeEventListener("touch", self)
				self:shakeTiles()
				timer.performWithDelay(800, function()
					self:unselectTiles()
					self.pathTiles = {}
					self:removePathLine()
					self.view.bg:addEventListener("touch", self)
				end, 1)
			end
			self.currentWord = WordClass.new()
		end
	end

	----------------------------------------------------------
	function LatticeClass:isInRange(letter)
--		print("LatticeClass:isInRange", letter.i, letter.j, letter.letter)
		if "" == self.currentWord.spelling then
			return true
		end
		if self.currentWord:hasLetter(letter) then
			return false
		end

		v = self.currentWord:getLastLetter()
		if 	(v.i - 1 == letter.i and v.j == letter.j) or
				(v.i + 1 == letter.i and v.j == letter.j) or
				(v.i == letter.i and v.j - 1 == letter.j) or
				(v.i == letter.i and v.j + 1 == letter.j) or
				(v.i - 1 == letter.i and v.j - 1 == letter.j) or
				(v.i - 1 == letter.i and v.j + 1 == letter.j) or
				(v.i + 1 == letter.i and v.j - 1 == letter.j) or
				(v.i + 1 == letter.i and v.j + 1 == letter.j) then
			return true
		end
		return false
	end

	----------------------------------------------------------
	function LatticeClass:showTiles()
		self.view = display.newGroup()
		self.layer:insert(self.view)
		self.view.bg = display.newRect(self.view, 0, 0, Game.w, Game.h)
		self.view.bg.alpha = 0.01
		self.view.bg:addEventListener("touch", self)
		self.vertices = {}
		for i = 1, self.width do
			self.vertices[i] = {}
			for j = 1, self.height do
				self.vertices[i][j] = TileClass.new({ layer = self.view, letter = self.letters[i][j] })
				self.vertices[i][j].view.x = (i - 2.5) * (self.vertices[i][j].view.width + self.tileSpaceX)
				self.vertices[i][j].view.y = (j - 2.5) * (self.vertices[i][j].view.height + self.tileSpaceY) + 50
			end
		end		
	end
	
	----------------------------------------------------------
	function LatticeClass:getTileFromXY(x, y)
		-- this ugly function is needed b/c touch listener is bound to the bg instead of tiles, which is in turn necessary to capture touch out events
		x = x - self.view.bg.width / 2
		y = y - self.view.bg.height / 2
		local widthRange = self.vertices[1][1]:getWidth() / (self.vertices[1][1]:getWidth() + self.tileSpaceX)
		local heightRange = self.vertices[1][1]:getHeight() / (self.vertices[1][1]:getHeight() + self.tileSpaceY)
		local i1, j1, i, j
		i1 = 2.5 + x / (self.vertices[1][1]:getWidth() + self.tileSpaceX)
		j1 = 2.5 + (y - 50) / (self.vertices[1][1]:getHeight() + self.tileSpaceY)
		i = Math.round(i1)
		j = Math.round(j1)
		if i < 1 or i > self.width or widthRange * 0.3 <= Math.abs(i1 - i) then
			i = nil
		end
		if j < 1 or j > self.height or heightRange * 0.3 <= Math.abs(j1 - j) then
			j = nil
		end
		print("getTileFromXY", "X=", widthRange, self.vertices[1][1]:getWidth(), x, i1, i, "Y=", heightRange, y, j1, j)
		if nil ~= i and nil ~= j then
			return self.vertices[i][j]
		else
			return nil
		end
	end

	----------------------------------------------------------
	function LatticeClass:growTiles()
		for _, v in pairs(self.vertices) do
			for _, w in pairs(v) do
				w:grow()
			end
		end
	end
	
	----------------------------------------------------------
	function LatticeClass:shakeTiles()
		for _, v in pairs(self.vertices) do
			for _, w in pairs(v) do
				w:shake()
			end
		end
	end
	
	----------------------------------------------------------
	function LatticeClass:unselectTiles()
		for _, v in pairs(self.vertices) do
			for _, w in pairs(v) do
				w:unselect()
			end
		end
	end
	
	----------------------------------------------------------
	function LatticeClass:unscaleTiles()
		for _, v in pairs(self.vertices) do
			for _, w in pairs(v) do
				w:unscale()
			end
		end
	end
	
	----------------------------------------------------------
	function LatticeClass:appendPathLine()
		if #self.pathTiles > 1 then
			local x1, y1, x2, y2
			x1 = self.pathTiles[#self.pathTiles - 1].view.x
			y1 = self.pathTiles[#self.pathTiles - 1].view.y
			x2 = self.pathTiles[#self.pathTiles].view.x
			y2 = self.pathTiles[#self.pathTiles].view.y

			print("appendPathLine", x1, y1, x2, y2)
			self.pathLine[#self.pathLine + 1] = display.newLine(self.view, x1, y1, x2, y2)
			self.pathLine[#self.pathLine].strokeWidth = 8
			self.pathLine[#self.pathLine]:setStrokeColor(255/255, 189/255, 2/255)
			self.pathLine[#self.pathLine]:toBack()
		end
	end

	----------------------------------------------------------
	function LatticeClass:removePathLine()
		for i = 1, #self.pathLine do
			display.remove(self.pathLine[i])
		end
	end
	
	----------------------------------------------------------
	function LatticeClass:play()
		self:showTiles()
	end

	----------------------------------------------------------
	function LatticeClass:removeSelf()
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end
		for i = 1, #self.vertices do
			self.vertices[i]:removeSelf()
		end
	end

	----------------------------------------------------------
	return LatticeClass
end

return class