local is_windows = package.config:sub(1,1) == '\\'
local ORIGINAL_MAIN_LUA = [[require("L5")

function setup()
  size(400, 400)

  -- Set the program title
  windowTitle("Basic sketch")

  describe('Draws a yellow background')
end

function draw()
  -- Fills the background with the color yellow
  background(255, 215, 0)
end
]]

-- Determine filename and execution mode
local filename = arg[1]
local is_watcher = (arg[2] == "--watch")

if not filename then
    print("Usage: lua runner.lua <filename> [--watch]")
    return
end

local source_path = "./examples/" .. filename .. '.lua'

-- WATCHER PROCESS
if is_watcher then
    local last_content = ""

    -- Give Love2D a second to launch before we start monitoring it
    os.execute(is_windows and "timeout /t 1 >nul" or "sleep 1")

    while true do
        -- Terminate watcher if Love2D is closed or killed via Ctrl+C
        local check_cmd = is_windows and 'tasklist | find /I "love.exe" >nul' or 'pgrep -x love >/dev/null'
        local success = os.execute(check_cmd)

        if success ~= true then
            -- CLEANUP: Restore the original sketch before breaking
            local clean_f = io.open("main.lua", "w")
            if clean_f then
                clean_f:write(ORIGINAL_MAIN_LUA)
                clean_f:close()
            end
            break
        end

        local src_f = io.open(source_path, "r")
        if src_f then
            local current_content = src_f:read("*a")
            src_f:close()

            -- Sync changes to main.lua
            if current_content ~= last_content then
                last_content = current_content
                local out_f = io.open("main.lua", "w")
                if out_f then
                    out_f:write(current_content)
                    out_f:close()
                end
            end
        end

        -- Poll interval prevents CPU hogging
        os.execute(is_windows and "timeout /t 1 >nul" or "sleep 1")
    end
    return -- End the watcher process here
end

-- MAIN PROCESS
local src_f = io.open(source_path, "r")
if not src_f then
    print("Error: Could not find " .. source_path)
    return
end

-- Initial copy
local content = src_f:read("*a")
src_f:close()
local main_f = io.open("main.lua", "w")
if main_f then
    main_f:write(content)
    main_f:close()
end

-- Spawn watcher in the background (--watch is now arg[2] in the spawned process)
local script_name = arg[0]
local watch_cmd = string.format('lua "%s" "%s" --watch', script_name, filename)

if is_windows then
    os.execute('start /B "" ' .. watch_cmd)
else
    os.execute(watch_cmd .. " &")
end

-- Execute Love2D (blocks until the Love2D window is closed)
os.execute("love .")

-- Cleanup: Restore the default sketch
local clean_f = io.open("main.lua", "w")
if clean_f then
    clean_f:write(ORIGINAL_MAIN_LUA)
    clean_f:close()
end