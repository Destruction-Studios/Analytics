local AnalyticsService = game:GetService("AnalyticsService")

local Field = require(script.Parent.Field)

local Economy = {}
local EconomyMT = {}
EconomyMT.__index = EconomyMT

function Economy.new(ecoName: string)
	assert(typeof(ecoName) == "string", `Expected 'string' got {typeof(ecoName)}`)
	local self = setmetatable({}, EconomyMT)

	self.Name = ecoName

	return self
end

function EconomyMT:LogSource(
	player: Player,
	earned: number,
	balance: number,
	from: Enum.AnalyticsEconomyTransactionType,
	itemSKU: string?,
	field: any?
)
	assert(typeof(earned) == "number", `Expected 'number' got {typeof(earned)}`)
	assert(typeof(balance) == "number", `Expected 'number' got {typeof(earned)}`)
	assert(
		typeof(from) == "EnumItem" and from:IsA("AnalyticsEconomyTransactionType"),
		`Invalid AnalyticsEconomyTransactionType`
	)
	if field ~= nil and not Field.isGroup(field) then
		error(`Invalid field group {typeof(field)}`)
	end

	AnalyticsService:LogEconomyEvent(
		player,
		Enum.AnalyticsEconomyFlowType.Source,
		self.Name,
		earned,
		balance,
		from.Name,
		itemSKU,
		field
	)
end

function EconomyMT:LogSink(
	player: Player,
	lost: number,
	balance: number,
	from: Enum.AnalyticsEconomyTransactionType,
	itemSKU: string?,
	field: any?
)
	assert(typeof(lost) == "number", `Expected 'number' got {typeof(lost)}`)
	assert(typeof(balance) == "number", `Expected 'number' got {typeof(balance)}`)
	assert(
		typeof(from) == "EnumItem" and from:IsA("AnalyticsEconomyTransactionType"),
		`Invalid AnalyticsEconomyTransactionType`
	)
	if field ~= nil and not Field.isGroup(field) then
		error(`Invalid field group {typeof(field)}`)
	end

	AnalyticsService:LogEconomyEvent(
		player,
		Enum.AnalyticsEconomyFlowType.Source,
		self.Name,
		lost,
		balance,
		from.Name,
		itemSKU,
		field
	)
end

return Economy
