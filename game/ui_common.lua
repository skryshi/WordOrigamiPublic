-- Copyright 2013 Arman Darini

--local view = require("views.view_class")

local class = {}
class.new = function(o)
	local UIClass = {}
	UIClass.layer = nil
	UIClass.pathToImage = nil
	UIClass.sheetUIInfo = nil
	UIClass.sheetUI = nil
	UIClass.timers = {}
	UIClass.transitions = {}

	----------------------------------------------------------
	function UIClass:init(o)
		print("UIClass:init")
		p(o)
		o = o or {}
		self.layer = o.layer
		self.pathToImage = o.pathToImage or "images/default.png"
		self:setSheet(self.pathToImage)

		Runtime:addEventListener("score", self)		
		Runtime:addEventListener("timer", self)
		Runtime:addEventListener("word", self)
		return self
	end

	----------------------------------------------------------
	function UIClass:score(event)
		self:updateHeader({ score = event.score })
	end

	----------------------------------------------------------
	function UIClass:timer(event)
--		print("UIClass:timer")
		self:updateHeader({ timer = event.remaining })
	end

	----------------------------------------------------------
	function UIClass:word(event)
		print("UIClass:word")
		p(event)
		if "completed" == event.phase and "success" == event.result then
			self:updateWordBox({ word = event.word, score = "+"..event.score })
			self:highlight()
		elseif "completed" == event.phase and "failure" == event.result then
			self:updateWordBox({ word = event.word, score = "" })
			self:shakeWordBox()
		elseif "completed" == event.phase and "repeat" == event.result then
			self:updateWordBox({ word = event.word, score = "" })
		else
			self:updateWordBox({ word = event.word, score = "" })
		end
	end

	----------------------------------------------------------
	function UIClass:getLayer()
		return self.layer
	end
	
	----------------------------------------------------------
	function UIClass:setSheet(pathToImage)
		pathToInfo, _ = string.gsub(pathToImage, "/", ".")
		pathToInfo = string.sub(pathToInfo, 1, #pathToInfo - 4)
		self.sheetUIInfo = require(pathToInfo)
		self.sheetUI = graphics.newImageSheet(pathToImage, self.sheetUIInfo:getSheet())		
	end

	----------------------------------------------------------
	function UIClass:showBackground()
--		local frame = self.sheetUIInfo:getFrameIndex("bg")
--		self.layer.bg = display.newImageRect(self.layer, self.sheetUI, frame, self.sheetUIInfo:getSheet().frames[frame].width, self.sheetUIInfo:getSheet().frames[frame].height)
		self.layer.bg = display.newRect(self.layer, 0, 0, Game.w, Game.h)
		self.layer.bg.x = Game.centerX
		self.layer.bg.y = Game.centerY
		self.layer.bg:setFillColor(200/255)
		return self.layer.bg
	end

	----------------------------------------------------------
	function UIClass:showHeader(o)
		self.layer.header = display.newGroup()
		
		local frame = self.sheetUIInfo:getFrameIndex("play_header")
		self.layer.header.bg = display.newImageRect(self.layer.header, self.sheetUI, frame, self.sheetUIInfo:getSheet().frames[frame].width, self.sheetUIInfo:getSheet().frames[frame].height)
		
		self.layer.header.timer = display.newText(self.layer.header, Helpers.formatAsTime(o.time), 0, 0, Game.font, 20)
		self.layer.header.timer:setFillColor(0)
		self.layer.header.timer.anchorX = 0
		self.layer.header.timer.x = -Game.w * 0.5 + 10
		self.layer.header.timer.y = -3

		self.layer.header.score = display.newText(self.layer.header, "0", 0, 0, Game.font, 20)
		self.layer.header.score:setFillColor(1)
		self.layer.header.score.x = 0
		self.layer.header.score.y = -3

		self.layer:insert(self.layer.header)
		self.layer.header.x = Game.centerX
		self.layer.header.y = self.layer.header.height * 0.5
		
		return self.layer.header
	end
	
	----------------------------------------------------------
	function UIClass:updateHeader(o)
		if o and o.timer then self.layer.header.timer.text = Helpers.formatAsTime(o.timer) end
		if o and o.score then self.layer.header.score.text = o.score end
	end

	----------------------------------------------------------
	function UIClass:showWordBox(o)
		self.layer.wordbox = display.newGroup()
		
		local frame = self.sheetUIInfo:getFrameIndex("word_bar")
		self.layer.wordbox.bg = display.newImageRect(self.layer.wordbox, self.sheetUI, frame, self.sheetUIInfo:getSheet().frames[frame].width, self.sheetUIInfo:getSheet().frames[frame].height)
		
		self.layer.wordbox.word = display.newText(self.layer.wordbox, "", 0, 0, Game.font, 25)
		self.layer.wordbox.word:setFillColor(0.5)
		self.layer.wordbox.word.anchorX = 0
		self.layer.wordbox.word.x = -Game.w * 0.5 + 5
		self.layer.wordbox.word.y = -4

		self.layer.wordbox.score = display.newText(self.layer.wordbox, "", 0, 0, Game.font, 20)
		self.layer.wordbox.score:setFillColor(0.5)
		self.layer.wordbox.score.anchorX = 1
		self.layer.wordbox.score.x = Game.w * 0.5 - 5
		self.layer.wordbox.score.y = -4

		self.layer:insert(self.layer.wordbox)
		self.layer.wordbox.x = Game.centerX
		self.layer.wordbox.y = self.layer.header.height + self.layer.wordbox.height * 0.5
		
		return self.layer.wordbox
	end
	
	----------------------------------------------------------
	function UIClass:updateWordBox(o)
		if o and o.word then self.layer.wordbox.word.text = o.word:upper() end
		if o and o.score then self.layer.wordbox.score.text = o.score end
	end

	----------------------------------------------------------
	function UIClass:highlight()
		transition.to(self.layer.wordbox.score, { iterations = 1, time = 500, xScale = 2, yScale = 2, transition = easing.continuousLoop, onComplete = function() self.layer.wordbox.score.xScale = 1; self.layer.wordbox.score.yScale = 1; end })
	end

	----------------------------------------------------------
	function UIClass:shakeWordBox()
--		transition.to(self.layer.wordbox.word, { delta = true, iterations = 3, time = 200, x = 5, transition = easing.continuousLoop })
--	there is a bug in easing.continuousLoop, so use this until it's fixed
		transition.to(self.layer.wordbox.word, { delta = true, iterations = 3, time = 200, x = self.layer.wordbox.word.x + 5, transition = easing.continuousLoop })
	end

	----------------------------------------------------------
	function UIClass:removeSelf()
		Runtime:removeEventListener("score", self)
		Runtime:removeEventListener("timer", self)
		Runtime:removeEventListener("word", self)

		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end
	end

	return UIClass
end

return class