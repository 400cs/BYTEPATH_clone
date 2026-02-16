local Player = GameObject:extent()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
end

function Player:update(dt)
    Player.super.update(self, dt)
end

function Player:draw()

end

return Player