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
    describe('Draws a yellow background')

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
    for x = 0, height do
        for y = 0, width do
            local c = pixelToPoint(x, y)
            local isIn, iter = table.unpack(calculatePointInSet(c))
            if isIn then
                set(x, y, color(0, 0, 0))
            elseif iter > 1 then
                -- FUN COLORING: Math-based RGB banding
                -- We multiply 'iter' by different prime-ish numbers to create offset color cycles.
                -- The '% 255' ensures the colors wrap around instead of maxing out to white.
                local r = (iter * 13) % 255
                local g = (iter * 7) % 255
                local b = (iter * 23) % 255

                set(x, y, color(r, g, b))
            else
                set(x, y, color(55, 55, 55))
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
        x = x3,
        y = y3,
    }
end

function calculatePointInSet(c)
    -- x represents the real part, y represents the imaginary part
    local z = { x = 0, y = 0 }
    -- Mathematically proven that any point greater than
    -- distance 2 will diverge to infinity
    local bounds = 2
    local isIn = true

    local iter = 0
    while iter < 100 do
        z = {
            -- z^2 = (zx + zy*i)^2 = zx^2 + zy^2 * i^2 + (2 * zx * zy)i
            -- z = (zx^2 - zy^2 + cx) + (2 * zx * zy + cy)i
            x = z.x * z.x - z.y * z.y + c.x,
            y = 2 * z.x * z.y + c.y
        }

        if dist(z.x, z.y, 0, 0) > bounds then
            isIn = false
            break
        end

        iter = iter + 1
    end

    return {
        isIn,
        iter,
    }
end