local Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)  -- our global width & height  
    self.timer = Timer()                                -- gw = 480, gh = 270

    local function process()
        self.timer:cancel('create_process')
        self.timer:cancel('remove_process')

        self.timer:every(0.25, function()
		    self.area:addGameObject('Circle', random(0,800), random(0, 600))
	    end, 10, 'create_process')
    
        self.timer:after(2.5,function()
            self.timer:every(random(0.5, 1), function()
                table.remove(self.area.game_objects, random(1, #self.area.game_objects))
                if #self.area.game_objects == 0 then
                process()
                end
            end, 10, 'remove_process')
        end)
    end
    
    process()
end

function Stage:update(dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas) --redirect all drawing operations to the currently set canvas
    love.graphics.clear()
        love.graphics.circle('line', gw/2,  gh/2, 50)
        self.area:draw()
    love.graphics.setCanvas() --unsets the target canvas so that drawing operations aren't redirected to it

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

return Stage