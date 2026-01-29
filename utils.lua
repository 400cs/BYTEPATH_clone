---@diagnostic disable: lowercase-global
function UUID()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

-- function random(min, max)
--     local min, max = min or 0, max or 1
--     return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
-- end

function random(min, max)
    if not max then
        return love.math.random()*min
    else
        if min > max then 
            min, max  = max, min
        end
        return love.math.random()*(max - min) + min
    end
end

function distance(x1, y1, x2, y2)
    return math.sqrt( (y1 - y2)^2 + (x1 - x2)^2 )
end