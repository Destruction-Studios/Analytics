--[[
	local WEAPON_CAT = Field.single("Weapons")
	local CLASS_CAT = Field.single("Class")

	local CustomFields = {}

	CustomFields.Events = {
		M16_KILL = WEAPON_CAT:Append("M16"),
		WARIOR_KILL = CLASS_CAT:Append("Warior"),
	}

	CustomFields.Groups = {
		WARIOR_M16_KILL = Field.group({ CustomFields.Events.M16_KILL, CustomFields.Events.WARIOR_KILL }),
	}
]]

local Field = {}
local SingleMT = {}
SingleMT.__index = SingleMT
SingleMT.__tostring = function(self)
	return self.Name
end

function Field.single(fieldName: string)
	assert(typeof(fieldName) == "string", `Expected 'string' got {typeof(fieldName)}`)

	return setmetatable({
		Name = fieldName,
	}, SingleMT)
end

function SingleMT:Append(fieldName: string)
	assert(typeof(fieldName) == "string", `Expected 'string' got {typeof(fieldName)}`)
	return Field.single(`{self.Name} - {fieldName}`)
end

function Field.group(keys: { string }): any
	local result = {}
	for i, key in keys do
		assert(tostring(key) == "string", `Expected 'string' for custom field key got '{tostring(key)}`)
		if i > 3 then
			warn(`Can not have more than 3 custom fields, ignoring extra`)
			break
		end
		result[Enum.AnalyticsCustomFieldKeys[`CustomField0{i}`]] = key
	end

	return result
end

return Field
