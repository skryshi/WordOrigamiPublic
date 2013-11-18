-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local LevelClass = {}
	LevelClass._persistent = {
		board = nil,
		words = nil
	}

	----------------------------------------------------------
	function LevelClass:init(o)
		return self
	end

	----------------------------------------------------------
	function LevelClass:load()
		self:loadFile()
--		self:loadMock()
	end
	
	----------------------------------------------------------
	function LevelClass:loadFile()
		data = Utils.loadTable("levels/1.json", system.ResourceDirectory)
		if data then
			p("Loaded valid level data")
			Utils.mergeTable(self._persistent, data)
		else
			p("No level data found")
		end
		--	put all persistent data into main namespace
		Utils.mergeTable(self, self._persistent)

		Runtime:dispatchEvent({ name = "getData", result = "success" })
	end

	----------------------------------------------------------
	function LevelClass:loadMock()
		local board = {
			{ i = 1, j = 1, l = "n", s = 1, lm = 1, wm = 1 },
			{ i = 2, j = 1, l = "t", s = 1, lm = 1, wm = 2 },
			{ i = 3, j = 1, l = "u", s = 1, lm = 1, wm = 3 },
			{ i = 4, j = 1, l = "i", s = 1, lm = 1, wm = 1 },
			{ i = 1, j = 2, l = "p", s = 1, lm = 2, wm = 1 },
			{ i = 2, j = 2, l = "c", s = 1, lm = 3, wm = 1 },
			{ i = 3, j = 2, l = "h", s = 1, lm = 1, wm = 1 },
			{ i = 4, j = 2, l = "o", s = 1, lm = 1, wm = 1 },
			{ i = 1, j = 3, l = "r", s = 1, lm = 1, wm = 1 },
			{ i = 2, j = 3, l = "v", s = 1, lm = 1, wm = 1 },
			{ i = 3, j = 3, l = "e", s = 1, lm = 1, wm = 1 },
			{ i = 4, j = 3, l = "e", s = 1, lm = 1, wm = 1 },
			{ i = 1, j = 4, l = "r", s = 1, lm = 1, wm = 1 },
			{ i = 2, j = 4, l = "y", s = 1, lm = 1, wm = 1 },
			{ i = 3, j = 4, l = "s", s = 1, lm = 1, wm = 1 },
			{ i = 4, j = 4, l = "u", s = 1, lm = 1, wm = 1 },
		}

		local words = {
			["nth"] = {	{ { 1, 1 }, { 2, 1 }, { 3, 2 } } },
			["use"] = {	{ { 4, 4 }, { 3, 4 }, { 3, 3 } },
									{ { 4, 4 }, { 3, 4 }, { 4, 3 } },
								},
		}
		self._persistent.board = board
		self._persistent.words = words
		--	put all persistent data into main namespace
		Utils.mergeTable(self, self._persistent)
		
		Runtime:dispatchEvent({ name = "getData", result = "success" })
	end

	----------------------------------------------------------
	function LevelClass:print()
		for k, _ in pairs(self._persistent) do
			p(self[k])
		end
	end

	----------------------------------------------------------
	function LevelClass:removeSelf()
	end

	----------------------------------------------------------
	LevelClass:init(o)

	return LevelClass
end

return class


