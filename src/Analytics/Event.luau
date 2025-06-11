--[[
	local CustomFields = require(path.to.fields)

	local CustomEvents = {}

	CustomEvents.WARIOR_M16_KILL = CustomEvent.new("Kill")

	--Somewhere else
	local function onEnemyKilled(player: Player, amountOfEnemies: number)
		CustomEvents.WARIOR_M16_KILL:Log(player, amountOfEnemies, CustomFields.WARIOR_M16)
	end
]]

local AnalyticsService = game:GetService("AnalyticsService")

local Field = require(script.Parent.Field)

local takenEvents = {}

local CustomEvent = {}
local CustomEventMT = {}
CustomEventMT.__index = CustomEventMT
function CustomEventMT:__tostring()
	return `CustomEvent<{self.Name}>`
end

function CustomEvent.new(eventName: string)
	assert(typeof(eventName) == "string", `Expected 'string' got {typeof(eventName)}`)
	assert(not takenEvents[eventName], `Custom event '{eventName}' has already been created`)

	takenEvents[eventName] = true

	local self = setmetatable({}, CustomEventMT)

	self.Name = eventName

	return self
end

function CustomEventMT:Log(player: Player, value: number?, fields: any)
	if fields ~= nil and not Field.isGroup(fields) then
		error(`Invalid field group {typeof(fields)}`)
	end
	AnalyticsService:LogCustomEvent(player, self.Name, value, fields)
end

return CustomEvent
