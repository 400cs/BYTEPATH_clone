local CircleRoom = Object:extend()

function CircleRoom:new()

end

function CircleRoom:update(dt)

end

function CircleRoom:draw()
    love.graphics.circle('fill', 400, 300, 100)
end

return CircleRoom