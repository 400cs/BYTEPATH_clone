local Rectangle = GameObject:extend()

function Rectangle:new(area, x, y, opts)
    Rectangle.super.new(self, area, x, y, opts)
    self.width, self.height = random(10, 50), random(10, 50)
end

function Rectangle:update(dt)
    Rectangle.super.update(self, dt)
end

function Rectangle:draw()
    love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
end

return Rectangle