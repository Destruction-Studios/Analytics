--[[
	local WEAPON_FIELD = Field.single("Weapons")
	local CLASS_FIELD = Field.single("Class")

	local CustomFields = {}

	CustomFields.Events = {
		M16 = WEAPON_FIELD:Append("M16"),
		WARIOR = CLASS_FIELD:Append("Warior"),
	}

	CustomFields.Groups = {
		WARIOR_M16 = Field.group({ CustomFields.Events.M16L, CustomFields.Events.WARIOR }),
	}
]]

local Key = require(script.Parent.Key)

local GROUP_KEY = Key("Group")
local FIELD_KEY = Key("Field")

local Field = {}
local SingleMT = {}
SingleMT.__index = SingleMT
SingleMT.__tostring = function(self)
	return self.Name
end

function Field.isField(any: any)
	return typeof(any) == "table" and any.Class == FIELD_KEY
end

function Field.isGroup(any: any)
	return typeof(any) == "table" and any.Class == GROUP_KEY
end

function Field.single(fieldName: string)
	assert(typeof(fieldName) == "string", `Expected 'string' got {typeof(fieldName)}`)

	return setmetatable({
		Name = fieldName,
		Class = FIELD_KEY,
	}, SingleMT)
end

function SingleMT:Append(fieldName: string)
	assert(typeof(fieldName) == "string", `Expected 'string' got {typeof(fieldName)}`)
	return Field.single(`{self.Name} - {fieldName}`)
end

function Field.group(keys: { typeof(Field.single) }): any
	local alreadyLooped = {}

	local result = {}
	for i, key in keys do
		assert(Field.isField(key), `Invalid field key`)
		if i > 3 then
			warn(`Can not have more than 3 fields, ignoring extra`)
			break
		end
		if alreadyLooped[key.Name] then
			warn(`Duplicate field {key.Name}, ignoring`)
			continue
		end
		alreadyLooped[key.Name] = true
		result[Enum.AnalyticsCustomFieldKeys[`CustomField0{i}`].Name] = key
	end

	result.Class = GROUP_KEY

	return result
end

return Field
