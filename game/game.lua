-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local GameClass = {
		debug = false,
		w = display.contentWidth,
		h = display.contentHeight,
		centerX = display.contentCenterX,
		centerY = display.contentCenterY,
--		font = "AveriaLibre-Bold",
		font = "Cabin-Regular",
		fontBold = "Cabin-Bold",
		controlsBlocked = false,
		level = 1,
		levelCompleted = false,
		score = 0,
		duration = 120,
		timeRemaining = 0,
	}

	----------------------------------------------------------
	function GameClass:init(o)
		return self
	end

	----------------------------------------------------------
	function GameClass:removeSelf()
	end

	----------------------------------------------------------
	GameClass:init(o)

	return GameClass
end

return class
