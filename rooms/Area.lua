local Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            table.remove(self.game_objects, i)
        end
    end
end

function Area:draw()
    for  _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    game_object.class = game_object_type
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:getGameObjects(func)
    local filtered_game_objects = {}
    for _, game_object in ipairs(self.game_objects) do
        if func(game_object) then
            table.insert(filtered_game_objects, game_object)
        end
    end
    return filtered_game_objects
end

function Area:queryCircleArea(x, y, radius, object_types)
    local game_object_within_area = {}

    --go through all game_objects
    for _,game_object in ipairs(self.game_objects) do
        
        -- get the filtered game_object
        if fn.include(object_types, game_object.class) then
            local d = distance(x, y, game_object.x, game_object.y)
            
            --check if filtered game_object is within the area
            if d <= radius then
                table.insert(game_object_within_area, game_object)
            end
        end
    end
    
    return game_object_within_area
end

return Area