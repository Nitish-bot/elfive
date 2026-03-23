-- Tell Luacheck we are using LÖVE2D, so it stops complaining about the 'love' global
std = "love"

-- Define project-wide globals that L5 creates
globals = {
    "L5_env", "L5_filter", "htmlColors", "VERSION",
    "width", "height", "mouseX", "mouseY", "pmouseX", "pmouseY",
    "movedX", "movedY", "frameCount", "deltaTime", "focused",
    "key", "keyCode", "keyIsPressed", "mouseIsPressed", "mouseButton",
    "pixels", "displayWidth", "displayHeight"
}

ignore = {
    "111", -- setting non-standard global variable
    "112", -- mutating non-standard global variable
    "113", -- accessing undefined variable (letting it access user functions like draw/setup)
    "211", -- unused variable
    "212", -- unused argument
    "213", -- unused loop variable
    "214", -- used variable with unused hint (fixes the `_x` paradox)
    "231", -- value assigned is unused
}
