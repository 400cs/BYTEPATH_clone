local Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()

    self.timer:every(2, function()
		self.area:addGameObject('Circle', 400, 300)
	end)
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw()
end

return Stage