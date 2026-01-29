local RectangleRoom = Object:extend()

function RectangleRoom:new()
    self.area = Area()
    self:createTenRandom() --self so it passes the a RectangleRoom object/instance
    input:bind('d', 'removeRectangle')
end

function RectangleRoom:update(dt)
    if input:pressed('removeRectangle') then
        table.remove(self.area.game_objects, random(1, #self.area.game_objects))
    end
    if #self.area.game_objects == 0 then
        self:createTenRandom()
    end
    self.area:update(dt)
end

function RectangleRoom:draw()
    self.area:draw()
    -- love.graphics.rectangle('fill', 400 - 100/2, 300 - 50/2, 100, 50)
end

function RectangleRoom:createTenRandom()
    for i=1,10 do
        self.area:addGameObject('Rectangle',random(0,800), random(0,600))
    end
end

return RectangleRoom