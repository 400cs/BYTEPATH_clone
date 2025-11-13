# Room Exercises

### 44. Create three rooms: CircleRoom which draws a circle at the center of the screen; RectangleRoom which draws a rectangle at the center of the screen; and PolygonRoom which draws a polygon to the center of the screen. Bind the keys F1, F2 and F3 to change to each room.

This questions asks for the implementation of 3 rooms and some way to change between them. From the example of a Stage room defined at the start of the article we can see that rooms are just objects with an update and draw function, and that those functions are called if the room is currently active. So first, for the room definitions:
```lua
local CircleRoom = Object:extend()

function CircleRoom:new()

end

function CircleRoom:update(dt)

end

function CircleRoom:draw()
    love.graphics.circle('fill', 400, 300, 100)
end

return CircleRoom
```

```lua
local RectangleRoom = Object:extend()

function RectangleRoom:new()

end

function RectangleRoom:update(dt)

end

function RectangleRoom:draw()
    love.graphics.rectangle('fill', 400 - 100/2, 300 - 50/2, 100, 50)
end

return RectangleRoom
```

```lua
local PolygonRoom = Object:extend()

function PolygonRoom:new()

end

function PolygonRoom:update(dt)

end

function PolygonRoom:draw()
    love.graphics.polygon('fill', 400, 300 - 50, 400 + 50, 300, 400, 300 + 50, 400 - 50, 300)
end

return PolygonRoom
```

These three should be created as CircleRoom.lua, RectangleRoom.lua and PolygonRoom.lua in the rooms folder. Then, similarly to how we automatically loaded the objects folder we should do it for the rooms on:

Then, finally, we can bind the keys with the functions needed to change from one room to another:
```lua
function love.load()
	local object_files = {}
	recursiveEnumerate('objects', object_files)
	requireFiles(object_files)

	local room_files = {}
	recursiveEnumerate('rooms', room_files)
	requireFiles(room_files)
	
	current_room = nil

    input = Input()
	input:bind('f1', function() gotoRoom('CircleRoom') end)
    input:bind('f2', function() gotoRoom('RectangleRoom') end)
    input:bind('f3', function() gotoRoom('PolygonRoom') end)

	chronotimer = Timer()
end
	
function love.update(dt)
	chronotimer:update(dt)
	if current_room then current_room:update(dt) end
end

function love.draw()
	if current_room then current_room:draw() end
end

function gotoRoom(room_type, ...)
    current_room = _G[room_type](...)
end
```

If the Simple Room setup is being used then whenever those keys are pressed, a new entire room is being created and the previous one is deleted. It's important to understand this idea.

### 45. What is the closest equivalent of a room in the following engines: Unity, GODOT, HaxeFlixel, Construct 2 and Phaser. Go through their documentation and try to find out. Try to also see what methods those objects have and how you can change from one room to another.
Unity: scenes
similar we implements but has more like asyncload and mergescene
methods: [here](https://docs.unity3d.com/ScriptReference/SceneManagement.SceneManager.html)

GODOT: scenes
methods: [here](https://docs.godotengine.org/en/stable/classes/class_scenetree.html#)

### 46. Pick two single player games and break them down in terms of rooms like I did for Nuclear Throne and Isaac. Try to think through things realistically and really see if something should be a room on its own or not. And try to specify when exactly do addRoom or gotoRoom calls would happen.
Age of War:
The way I would separate this in terms of rooms is: Mainmenu, DifficultySelect, Game

Halls of Torrment:
The way I would separate this in terms of rooms is: Lobby, MapSelect, Game, PowerSelect

### 47. In a general way, how does the garbage collector in Lua work? (and if you don't know what a garbage collector is then read up on that) How can memory leaks happen in Lua? What are some ways to prevent those from happening or detecting that they are happening?
When there are no references to a varible, it will get garbage collected later.