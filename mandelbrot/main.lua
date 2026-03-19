require("L5")

local width = 400.
local height = 400.

local zoom = 1.
local panX = 0.
local panY = 0.

function setup()
	size(width, height)

	-- Set the program title
	windowTitle("Basic sketch")
	describe("Draws a yellow background")

	noStroke()
end

function draw()
	drawMandelbrot()
end

function keyPressed()
	if key == "w" then
		panY = panY - 1 / zoom
	elseif key == "s" then
		panY = panY + 1 / zoom
	elseif key == "a" then
		panX = panX - 1 / zoom
	elseif key == "d" then
		panX = panX + 1 / zoom
	elseif key == "e" then
		zoom = zoom + 5
	elseif key == "q" then
		zoom = zoom - 5
	end
end

function drawMandelbrot()
	loadPixels()

	for x = 0, width - 1 do
		for y = 0, height - 1 do
			local idx = (x + (y * width)) * 4

			local cx, cy = table.unpack(pixelToPoint(x, y))
			local isIn, iter = table.unpack(calculatePointInSet(cx, cy))

			if isIn then
				pixels[idx] = 0
				pixels[idx + 1] = 0
				pixels[idx + 2] = 0
				pixels[idx + 3] = 255
			elseif iter > 1 then
				-- FUN COLORING: Math-based RGB banding
				-- We multiply 'iter' by different prime-ish numbers to create offset color cycles.
				-- The '% 255' ensures the colors wrap around instead of maxing out to white.
				local r = (iter * 13) % 255
				local g = (iter * 7) % 255
				local b = (iter * 23) % 255

				pixels[idx] = r
				pixels[idx + 1] = g
				pixels[idx + 2] = b
				pixels[idx + 3] = 255
			else
				pixels[idx] = 55
				pixels[idx + 1] = 55
				pixels[idx + 2] = 55
				pixels[idx + 3] = 255
			end
		end
	end

	updatePixels()
end

function pixelToPoint(x, y)
	-- Normalize between [-width/2, width/2] and [-height/2, height/2]
	local x1 = x - width / 2
	local y1 = y - height / 2

	-- Noramlize to [-2, 2] range
	local x2 = x1 * 4 / width
	local y2 = y1 * 4 / height

	-- Reduce to zoomed-in range and apply pan offset
	local x3 = x2 / zoom + panX
	local y3 = y2 / zoom + panY

	return {
		x3,
		y3,
	}
end

function calculatePointInSet(cx, cy)
	-- x represents the real part, y represents the imaginary part
	local zx = 0
	local zy = 0
	-- Mathematically proven that any point greater than
	-- distance 2 will diverge to infinity
	local bounds = 2
	local isIn = true

	local iter = 0
	while iter < 100 do
		local zx2 = zx * zx
		local zy2 = zy * zy

		if zx2 + zy2 > bounds * 2 then
			isIn = false
			break
		end

		-- z^2 = (zx + zy*i)^2 = zx^2 + zy^2 * i^2 + (2 * zx * zy)i
		-- z = (zx^2 - zy^2 + cx) + (2 * zx * zy + cy)i
		zy = 2 * zx * zy + cy
		zx = zx2 - zy2 + cx

		iter = iter + 1
	end

	return {
		isIn,
		iter,
	}
end
