------------------- SOUND ---------------------
function loadSound(_filename)
	local success, result = pcall(love.audio.newSource, _filename)

	if success then
		return result
	else
		error("Failed to load image '" .. _filename .. "': " .. tostring(result))
	end
end