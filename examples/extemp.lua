require("L5")
require("L5Sound")

local sound
local hasStarted = false

function setup()
	size(400, 400)

	sound = loadSound("assets/sorry.mp3")
	sound2 = loadSound("assets/sorry.mp3")
end

function draw()
	-- Fills the background with the color yellow
	background(255, 215, 0)

	if sound == nil or sound2 == nil then
		text("loading sound", 10, 10)
	elseif not hasStarted then
		sound:start()
		sound2:start()
		hasStarted = true
	end
end

function mouseClicked()
	if sound:isPlaying() then
		sound:pause()
	else
		sound:play()
	end
end

function keyPressed()
	if key == "p" then
		if sound2:isPlaying() then
			sound:pause()
		else
			sound:play()
		end
	end
end
