--local Circle = GameObject:extend()
local Circle = Object:extend()

--function Circle:new(area, x, y, opts)
function Circle:new(x, y)
    --Circle.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.dead = false
    self.timer = Timer()
    

    self.timer:after(random(2, 4), function() self.dead = true end)
end

function Circle:update(dt)
    --Circle.super.update(self, dt)
    if self.timer then self.timer:update(dt) end
end

function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, 50)
end

return Circle