Object = require 'libraries/classic/classic' --global var for class library
Input = require 'libraries/boipushy/Input' --global var for input library
Timer = require 'libraries/chrono/Timer' --global var for timer library
fn = require 'libraries/Moses/moses' --global var for table operation library

GameObject = require 'GameObject'
require 'utils'


function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)

	local room_files = {}
	recursiveEnumerate('rooms', room_files)
	requireFiles(room_files)
	
	timer = Timer()
	input = Input()
	
	current_room = nil
	gotoRoom('Stage')

	-- input:bind('f1', function() gotoRoom('CircleRoom') end)
    -- input:bind('f2', function() gotoRoom('RectangleRoom') end)
    -- input:bind('f3', function() gotoRoom('PolygonRoom') end)
end
	
function love.update(dt)
	timer:update(dt)
	if current_room then current_room:update(dt) end
end

function love.draw()
	if current_room then current_room:draw() end
end

function gotoRoom(room_type, ...)
	 print("Going to room: " .. room_type)
    current_room = _G[room_type](...)
end

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	 for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.getInfo(file, 'file') then
            table.insert(file_list, file)
        elseif love.filesystem.getInfo(file, 'directory') then
            recursiveEnumerate(file, file_list)
        end
    end
end

-- Automatically creates global variables for each class based on the filename
-- Since the class library returns a table, we can assign it to a global variable
function requireFiles(files)
    for _, file in ipairs(files) do
        if file:sub(-4) == '.lua' then
            local file_path = file:sub(1, -5) -- remove .lua extension from filename
            local last_foward_slash_index = file_path:find("/[^/]*$")
            local class_name = file_path:sub(last_foward_slash_index + 1, #file_path) -- or local class_name = file_path:sub(index+1)
			print(class_name)
			_G[class_name] = require(file_path)
        end
    end
end

-- Use this fuction when the class definitions do not return a table
-- meaning they use ex. Circle = Object:extend() instead of local Circle = Object:extend()
-- function requireFiles(files)
--     for _, file in ipairs(files) do
--         local file = file:sub(1, -5)
--         require(file)
--     end
-- end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end