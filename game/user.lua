-- Copyright 2013 Arman Darini
local class = {}
class.new = function(o)
	local UserClass = {}
	UserClass._persistent = {
		username = nil,
		password = nil,
		version = 2,
		soundVolume = 0.3,
		musicVolume = 1,
		credits = 100,
		wins = 0,
		losses = 0,
		rating = 0,
		avatar = "avatar_01",
	}

	----------------------------------------------------------
	function UserClass:init(o)
		local id = system.getInfo("deviceID")
		p(id)
		self._persistent.username = id
		self._persistent.password = Utils.generateRandomString(12, 15)
		--	put all persistent data into main namespace
		Utils.mergeTable(self, self._persistent)
		return self
	end

	----------------------------------------------------------
	function UserClass:get()
--		self:getFromFile()
		self:getFromMock()
	end

	----------------------------------------------------------
	function UserClass:getFromFile()
		data = Utils.loadTable("user")
		if data and data.version and data.version >= self._persistent.version then
			p("Loaded valid user data")
			Utils.mergeTable(self._persistent, data)
		else
			self:save()
		end
		--	put all persistent data into main namespace
		Utils.mergeTable(self, self._persistent)

		Runtime:dispatchEvent({ name = "network", object = "User", verb = "login", result = "201" })
	end

	----------------------------------------------------------
	function UserClass:getFromMock()
		self._persistent = {
			objectId = "hodsihsd",
			createdAt = "01012013 12:30:30",
			username = "Dragon",
			password = "df23fesad",
			version = 1,
			soundVolume = 0.3,
			musicVolume = 1,
			credits = 100,
			wins = 69,
			losses = 17,
			rating = 1800,
			avatar = "avatar_01",
		}
		--	put all persistent data into main namespace
		Utils.mergeTable(self, self._persistent)

		Runtime:dispatchEvent({ name = "network", object = "User", verb = "login", result = "201" })
	end

	----------------------------------------------------------
	function UserClass:save()
		-- copy all persistent data from main namespace
		for k, _ in pairs(self._persistent) do
			if self[k] then
				self._persistent[k] = self[k]
			end
		end
		Utils.saveTable(self._persistent, "user")
	end

	----------------------------------------------------------
	function UserClass:print()
		for k, _ in pairs(self._persistent) do
			p(self[k])
		end
	end

	----------------------------------------------------------
	function UserClass:removeSelf()
	end

	----------------------------------------------------------
	UserClass:init(o)

	return UserClass
end

return class