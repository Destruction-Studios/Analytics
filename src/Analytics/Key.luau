local function Key(keyName: string)
	assert(typeof(keyName) == "string", `Key name must be of type 'string' got {typeof(keyName)}`)

	local uniqueKey = newproxy(true)

	getmetatable(uniqueKey).__tostring = function()
		return keyName
	end

	return uniqueKey
end

return Key
