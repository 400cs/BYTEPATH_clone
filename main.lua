Object = require 'libraries/classic/classic' --global var for class library
Input = require 'libraries/boipushy/Input' --global var for input library
Timer = require 'libraries/chrono/Timer' --global var for timer library
Moses = require 'libraries/Moses/moses' --global var for moses library


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

-- -- Use this fuction when the class definitions do not return a table
-- -- meaning they use ex. Circle = Object:extend() instead of local Circle = Object:extend()
-- function requireFiles(files)
--     for _, file in ipairs(files) do
--         local file = file:sub(1, -5)
--         require(file)
--     end
-- end

-- Automatically creates global variables for each class based on the filename
-- Since the class library returns a table, we can assign it to a global variable
function requireFiles(files)
    for _, file in ipairs(files) do
        if file:sub(-4) == '.lua' then
            local file_path = file:sub(1, -5) -- remove .lua extension from filename
            local last_foward_slash_index = file_path:find("/[^/]*$")
            local class_name = file_path:sub(last_foward_slash_index + 1, #file_path) -- or local class_name = file_path:sub(index+1)
			_G[class_name] = require(file_path)
        end
    end
end

function circleAnimation()
	chronotimer:tween(6, circle, {radius = 100}, 'in-out-cubic', function()
		chronotimer:tween(6, circle, {radius = 50}, 'in-out-cubic')
	end)
	chronotimer:after(12, circleAnimation)
end

function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)

	--hyperCircle = HyperCircle(400, 300, 50, 10, 120)
	-- hp_bar_f = {x = 400, y = 300, w = 200, h = 50}
    -- hp_bar_b = {x = 400, y = 300, w = 200, h = 50}

	-- set_x_fg = hp_bar_f.x - hp_bar_f.w/2
	-- set_x_bg = hp_bar_b.x - hp_bar_b.w/2
	
	circle = {x = 400, y = 300, radius = 50}

    input = Input()
    -- input:bind('d', 'damage')
	input:bind("e", 'expand')
	input:bind("s", 'shrink')

	chronotimer = Timer()
	a = 10
	chronotimer:tween(1, _G, {a = 20}, 'linear')
	-- for i = 1, 10 do
	-- 	chronotimer:after(0.5*i, function() print(love.math.random()) end)
	-- end

	-- chronotimer:after(0, function()
	-- 	chronotimer:tween(6, circle, {radius = 100}, 'in-out-cubic', function()
	-- 		chronotimer:tween(6, circle, {radius = 50}, 'in-out-cubic')
	-- 	end)
	-- 	chronotimer:after(12, circleAnimation)
	-- end)
end
	
function love.update(dt)
	--hyperCircle:update(dt)
	-- if input:pressed('damage') then	
	-- 	chronotimer:tween(0.5, hp_bar_f, {w = hp_bar_f.w - 20}, 'in-out-cubic', function()
	-- 		chronotimer:after(0.25, function() 
	-- 			chronotimer:tween(0.5, hp_bar_b, {w = hp_bar_b.w - 20}, 'in-out-cubic', nil, 'bg_tween')
	-- 		end, 'bg_after')
	-- 	end, 'fg')		
	-- end

	if input:pressed('expand') then
		chronotimer:cancel('shrink_tween')
		chronotimer:tween(3, circle, {radius = 100}, 'in-out-cubic', nil, 'expand_tween')
	elseif input:pressed('shrink') then
		chronotimer:cancel('expand_tween')
		chronotimer:tween(3, circle, {radius = 50}, 'in-out-cubic', nil, 'shrink_tween')
	end

	chronotimer:update(dt)
end

function love.draw()
	--hyperCircle:draw()
	
	-- love.graphics.setColor(1, 0, 0)
	-- love.graphics.rectangle('fill', set_x_bg, hp_bar_b.y - hp_bar_b.h/2, hp_bar_b.w, hp_bar_b.h)  --can't use hp_bar_f.x - hp_bar_f.w/2 bc it changes during tween
	-- love.graphics.setColor(0.9, 0.3, 0.1)
	-- love.graphics.rectangle('fill', set_x_fg, hp_bar_f.y - hp_bar_f.h/2, hp_bar_f.w, hp_bar_f.h)
	-- love.graphics.setColor(1, 1, 1)

	love.graphics.circle('fill', circle.x, circle.y, circle.radius)

end

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