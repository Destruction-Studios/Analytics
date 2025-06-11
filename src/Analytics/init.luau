local RunService = game:GetService("RunService")

if RunService:IsClient() then
	error(`Analytics can not be run on client`)
end

local Field = require(script.Field)
local Event = require(script.Event)
local Economy = require(script.Economy)
local Funnel = require(script.Funnel)

local Analytics = {
	Field = Field,
	Event = Event,
	Funnel = Funnel,
	Economy = Economy,
}

return Analytics
