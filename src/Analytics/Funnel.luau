local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")

local Field = require(script.Parent.Field)

local Funnel = {}
local FunnelMT = {}
FunnelMT.__index = FunnelMT

function Funnel.new(funnelName: string)
	assert(typeof(funnelName) == "string", `Expected 'string' got {typeof(funnelName)}`)
	local self = setmetatable({}, FunnelMT)

	self.Name = funnelName
	self._steps = nil
	self._id = ""

	return self
end

function FunnelMT:Unique(key: string?): typeof(Funnel.new())
	key = key or HttpService:GenerateGUID()
	local new = Funnel.new(self.Name):SetSteps(self._steps)

	new._id = key

	return new
end

function FunnelMT:SetSteps(steps)
	assert(#steps <= 100 and #steps > 0, "Steps array has either too many or too little keys")
	local last = 0
	for i, step in steps do
		if i > last + 1 then
			error(`Steps array skips from index {last} to index {i}`)
		end
		assert(typeof(step) == "string", `Invalid step at index {step}`)
		last = i
	end

	self._steps = steps

	return self
end

function FunnelMT:LogOnboardStep(player: Player, step: number, field: any)
	assert(self._steps[step], `Invalid step {step}`)
	if field ~= nil and not Field.isGroup(field) then
		error(`Invalid field group`)
	end

	AnalyticsService:LogOnboardingFunnelStepEvent(player, step, self._steps[step], field)
end

function FunnelMT:LogFunnelStep(player: Player, step: number, field: any)
	assert(self._steps[step], `Invalid step {step}`)
	if field ~= nil and not Field.isGroup(field) then
		error(`Invalid field group`)
	end
	if not self._id or self._id == "" then
		warn(`Funnel has no id`)
		return
	end

	AnalyticsService:LogFunnelStepEvent(player, self.Name, self._id, step, self._steps[step], field)
end

return Funnel
