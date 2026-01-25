local Stage = Object:extend()

function Stage:new()
    --self.area = Area()
    self.game_objects = {}
    self.timer = Timer()

    self.timer:every(2, function()
		--self.area:addGameObject('Circle', random(0,800), random(0, 600))
        table.insert(self.game_objects, Circle(random(0,800), random(0, 600)))
	end)
end

function Stage:update(dt)
    --self.area:update(dt)
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            table.remove(self.game_objects, i)
        end
    end

    self.timer:update(dt)
end

function Stage:draw()
    --self.area:draw()
    for  _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

return Stage