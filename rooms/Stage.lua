local Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()

    local function process()
        --self.timer:cancel('create_process')
        --self.timer:cancel('remove_process')

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
    self.area:draw()
end

return Stage