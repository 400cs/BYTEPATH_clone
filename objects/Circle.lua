local Circle = GameObject:extend()

function Circle:new(area, x, y, opts)
    Circle.super.new(self, area, x, y, opts)
    --self.timer:after(random(2, 4), function() self.dead = true end)
    self.radius = random(10, 50)
end

function Circle:update(dt)
    Circle.super.update(self, dt)
    --if self.timer then self.timer:update(dt) end
end

function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Circle