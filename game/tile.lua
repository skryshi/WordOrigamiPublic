-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local TileClass = {}
	TileClass.layer = nil
	TileClass.view = nil
	TileClass.sheetInfo = require("assets.images.sheet-1x")
	TileClass.sheet = graphics.newImageSheet("assets/images/sheet-1x.png", TileClass.sheetInfo:getSheet())
	TileClass.letter = nil
	TileClass.category = nil
	TileClass.timers = {}
	TileClass.transitions = {}
	
	TileClass.animationSequences =
	{
		base = {
			{ name = "unselected", frames = { TileClass.sheetInfo:getFrameIndex("tile_base") } },
			{ name = "selected", frames = { TileClass.sheetInfo:getFrameIndex("tile_base_sel") } },
		},
		dl = {
			{ name = "unselected", frames = { TileClass.sheetInfo:getFrameIndex("tile_dl") } },
			{ name = "selected", frames = { TileClass.sheetInfo:getFrameIndex("tile_dl_sel") } },
		},
		dw = {
			{ name = "unselected", frames = { TileClass.sheetInfo:getFrameIndex("tile_dw") } },
			{ name = "selected", frames = { TileClass.sheetInfo:getFrameIndex("tile_dw_sel") } },
		},
		tl = {
			{ name = "unselected", frames = { TileClass.sheetInfo:getFrameIndex("tile_tl") } },
			{ name = "selected", frames = { TileClass.sheetInfo:getFrameIndex("tile_tl_sel") } },
		},
		tw = {
			{ name = "unselected", frames = { TileClass.sheetInfo:getFrameIndex("tile_tw") } },
			{ name = "selected", frames = { TileClass.sheetInfo:getFrameIndex("tile_tw_sel") } },
		},
	}

	----------------------------------------------------------
	function TileClass:init(o)
		self.layer = o.layer
		self.letter = o.letter
		
		self:show()
		return self
	end

	----------------------------------------------------------
	function TileClass:show()
		self.view = display.newGroup()
		self.layer:insert(self.view)

		self.view.owner = self
		
		if 2 == self.letter.lmult then
			self.category = "dl"
		elseif 3 == self.letter.lmult then
			self.category = "tl"
		elseif 2 == self.letter.wmult then
			self.category = "dw"
		elseif 3 == self.letter.wmult then
			self.category = "tw"
		else
			self.category = "base"
		end
		
		self.view.bg = display.newSprite(self.view, self.sheet, self.animationSequences[self.category])
		self:unselect()
		--	the next 3 lines fix a bug in Corona with sprites ignoring sourceHeight and soruceWidth
		local frame = self.sheetInfo:getFrameIndex("tile_base")
		self.view.bg.width = self.sheetInfo:getSheet().frames[frame].sourceWidth
		self.view.bg.height = self.sheetInfo:getSheet().frames[frame].sourceHeight
		
		self.view.letter = display.newText(self.view, self.letter.spelling:upper(), 0, 0, Game.font, 40)
		self.view.letter:setFillColor(0)
		self.view.letter.y = -4

		self.view.score = display.newText(self.view, self.letter.score, 0, 0, Game.font, 13)
		self.view.score:setFillColor(0)
		self.view.score.x = self.view.width * 0.5 - 14
		self.view.score.y = -self.view.height * 0.5 + 14

		self.view.anchorChildren = true
		
		self.layer:insert(self.view)
	end

	----------------------------------------------------------
	function TileClass:getWidth()
		local frame = self.sheetInfo:getFrameIndex("tile_base")
		return self.sheetInfo:getSheet().frames[frame].sourceWidth
	end

	----------------------------------------------------------
	function TileClass:getHeight()
		local frame = self.sheetInfo:getFrameIndex("tile_base")
		return self.sheetInfo:getSheet().frames[frame].sourceHeight
	end

	----------------------------------------------------------
	function TileClass:grow()
		if "selected" == self.view.bg.sequence then
--			transition.to(self.view, { iterations = 1, time = 200, xScale = 1.075, yScale = 1.075, transition = easing.continuousLoop, onComplete = function() self.view.xScale = 1; self.view.yScale = 1; end })
--	there is a bug in easing.continuousLoop, so use this until it's fixed
			transition.to(self.view, { iterations = 1, time = 200, xScale = 2.075, yScale = 2.075, transition = easing.continuousLoop, onComplete = function() self.view.xScale = 1; self.view.yScale = 1; end })
		end
	end

	----------------------------------------------------------
	function TileClass:shake()
		if "selected" == self.view.bg.sequence then
			transition.to(self.view, { time = 100, rotation = -3, iterations = 1, onComplete = function() 
				transition.to(self.view, { time = 200, rotation = 6, iterations = 3, transition = easing.continuousLoop, onComplete = function() 
					transition.to(self.view, { time = 100, rotation = 0, iterations = 1 })
				end })
			end })
		end
	end

	----------------------------------------------------------
	function TileClass:select()
		self.view.bg:setSequence("selected")
		self.view.bg:play()
		self.view.bg.xScale = 1.2
		self.view.bg.yScale = 1.2
	end

	----------------------------------------------------------
	function TileClass:unselect()
		self.view.bg:setSequence("unselected")
		self.view.bg:play()
		self.view.bg.xScale = 1
		self.view.bg.yScale = 1
	end
	
	----------------------------------------------------------
	function TileClass:unscale()
		self.view.bg.xScale = 1
		self.view.bg.yScale = 1
	end

	----------------------------------------------------------
	function TileClass:removeSelf()
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end	
		display.remove(self.view)
	end

	----------------------------------------------------------
	TileClass:init(o)

	return TileClass
end

return class
