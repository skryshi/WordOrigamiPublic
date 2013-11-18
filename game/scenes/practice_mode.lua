-- Copyright 2013 Arman Darini
local scene = Storyboard.newScene()
local LevelClass = require("game.level")

----------------------------------------------------------
function scene:timer(event)
--	print("scene:timer")
	if event.remaining <= 0 then
		timer.cancel(self.timers.level)
		Storyboard.purgeScene("game.scenes.practice_mode")
		Storyboard.gotoScene("game.scenes.practice_mode")
	end
end

----------------------------------------------------------
function scene:getData(event)
	if "success" == event.result then
		self:play()
	else
	end
end

----------------------------------------------------------
function scene:loadLevel()
	Runtime:addEventListener("getData", self)
	self.level = LevelClass.new()
	self.level:load()
end

----------------------------------------------------------
function scene:play()
	self.view.content.lattice = display.newGroup()
	self.view.content:insert(self.view.content.lattice)
	
	self.lattice:init({ layer = self.view.content.lattice, level = self.level })
	self.lattice:play()
	self.view.content.lattice.anchorChildren = true
	self.view.content.lattice.x = Game.centerX
	self.view.content.lattice.y = Game.centerY

	self.timers.level = timer.performWithDelay(1000, function()
		Game.timeRemaining = Game.timeRemaining - 1
		Runtime:dispatchEvent({ name = "timer", remaining = Game.timeRemaining })
	end, 0)
	
	Runtime:addEventListener("timer", self)
end

----------------------------------------------------------
function scene:createScene(event)
	self.timers = {}
	self.transitions = {}

	self.view.content = display.newGroup()
	self.view.ui = display.newGroup()
	self.view:insert(self.view.ui)
	self.view:insert(self.view.content)

	self.ui = require("game.ui_common").new()
	self.lattice = require("game.lattice").new()

	Game.timeRemaining = Game.duration
	
	self.ui:init({ layer = self.view.ui, pathToImage = "assets/images/sheet-1x.png" })
	self.ui:showBackground()
	self.ui:showHeader({ time = Game.duration })
	self.ui:showWordBox()

	self:loadLevel()
end

----------------------------------------------------------
function scene:willEnterScene(event)
end

----------------------------------------------------------
function scene:exitScene(event)
	Runtime:removeEventListener("timer", self)
	Runtime:removeEventListener("getData", self)
	self.ui:removeSelf()
	
	for k, _ in pairs(self.timers) do
		timer.cancel(self.timers[k])
		self.timers[k] = nil
	end
	for k, _ in pairs(self.transitions) do
		transition.cancel(self.transitions[k])
		self.transitions[k] = nil
	end
end

----------------------------------------------------------
scene:addEventListener("createScene", scene)
scene:addEventListener("willEnterScene", scene)
scene:addEventListener("exitScene", scene)

return scene