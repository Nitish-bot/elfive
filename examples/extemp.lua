require("L5")
require("L5Sound")

local sound

function setup()
    size(400, 400)

    sound = loadSound("assets/sorry.mp3")
    if sound == nil then
        text("loading sound", 10, 10)
    else
        sound:start()
    end
end

function draw()
	-- Fills the background with the color yellow
	background(255, 215, 0)
end

function mousePressed()
	if sound:isPlaying() then
		sound:pause()
	else
		sound:play()
	end
end

