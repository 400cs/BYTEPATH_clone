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

```
In Unity Rooms are called Scenes. The functions around a Scene are here and they mostly appear to have the same functionality as explained previously. Although they have additional things such as merging scenes and asynchronous loading of scenes, things which we could do in Lua if necessary.

In Godot Rooms are also called Scenes. The functions around a Scene are here and they seem to be the same as well without anything that stands out. There are functions to change from scene to scene, as well as functions to reload scenes and then to communicate with the editor.

In HaxeFlixel Rooms are called States. The functions around a FlxState seem to be what would be expected, except with a few differences that are worth noting. For instance, it has persistentDraw and persistentUpdate functions, which will run even when the state is not an active one. This can be useful in a number of situations like the page explains.

The functions that switch/reload states are here in this sort of global object that has a bunch of assorted functionality in it. While a bit less organized than the previous engines, this generally works fine (and it's what we're doing as well, after all our state changing functions are global functions in a random file).

In Construct 2 Rooms are called Layouts. Construct 2 seems to be mostly UI based so it's hard to get a handle on how things work exactly, but changing between layouts can be done by using events, apparently. It seems hard to get more concrete information based on the documentation alone, though.

In Phaser Rooms are called States. And the functions that operate on states are on a StateManager. This is probably the most standard way of doing things I've seen. Note that each state here also has a reference to a Game object as well as a World object. The World object is the equivalent of an Area (although there's always only one world for Phaser, while in our case we can create multiple areas), and the Game object has no equivalent, but it would be everything that we defined and will define in the main.lua file.
```

### 46. Pick two single player games and break them down in terms of rooms like I did for Nuclear Throne and Isaac. Try to think through things realistically and really see if something should be a room on its own or not. And try to specify when exactly do addRoom or gotoRoom calls would happen.
Age of War:
The way I would separate this in terms of rooms is: Mainmenu, DifficultySelect, Game

Halls of Torrment:
The way I would separate this in terms of rooms is: Lobby, MapSelect, Game, PowerSelect, Inventory

### 47. In a general way, how does the garbage collector in Lua work? (and if you don't know what a garbage collector is then read up on that) How can memory leaks happen in Lua? What are some ways to prevent those from happening or detecting that they are happening?
When there are no references to a varible, it will get garbage collected later.

```
Whenever there are no more references pointing to a variable then eventually that variable will be collected. So if we want an object to be collected in Lua, all we have to do is set the variable that is holding that object to nil. If the object is being held inside a table then all we have to do is remove it from the table. If the object is both inside a table and being pointed to with a variable, then we must do both. If we just remove it from the table or just set the variable to nil then the object won't be collected.

Memory leaks can happen when the developer forgets to remove references to an object, like in the previous example of only removing it from the table that holds it or only setting the variable that points to it to nil. Preventing this from happening is mostly a matter of paying attention and constantly checking to see if there are any execution paths that consistently lead to abnormal memory usage. Further on in the tutorial I'll go over some code that can help with this.
```

# Area Exercises

### 48. Create a Stage room that has an Area in it. Then create a Circle object that inherits from GameObject and add an instance of that object to the Stage room at a random position every 2 seconds. The Circle instance should kill itself after a random amount of time between 2 and 4 seconds.
Stage room
```lua
local Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()
	-- add an instance of that object to the Stage room at a random position every 2 seconds
    self.timer:every(2, function()
		self.area:addGameObject('Circle', random(0,800), random(0, 600))
	end)
end

function Stage:update(dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function Stage:draw()
    self.area:draw()
end

return Stage
```

Circle object
```lua
local Circle = GameObject:extend()

function Circle:new(area, x, y, opts)
    Circle.super.new(self, area, x, y, opts)
	--kill itself after a random amount of time between 2 and 4 seconds
    self.timer:after(random(2, 4), function() self.dead = true end)
end

function Circle:update(dt)
    Circle.super.update(self, dt)
end

function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, 50)
end

return Circle
```

### 49. Create a Stage room that has no Area in it. Create a Circle object that does not inherit from GameObject and add an instance of that object to the Stage room at a random position every 2 seconds. The Circle instance should kill itself after a random amount of time between 2 and 4 seconds.
Similar to #48 but we don't use Area and GameObject class, instead Stage class handles the object creation and removal; and Circle needs to have a dead attribute and a timer instance instead of using GameObject for that. 

tldr: This exercise is essentially asking us to do the Area/GameObject binding manually from scratch.
Stage room
```lua
local Stage = Object:extend()

function Stage:new()
    --self.area = Area()
    self.game_objects = {}
    self.timer = Timer()

    self.timer:every(2, function()
		--self.area:addGameObject('Circle', random(0,800), random(0, 600))
        table.insert(self.game_objects, Circle(random(0,800), random(0, 600)))
	end)
end

function Stage:update(dt)
    --self.area:update(dt)
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            table.remove(self.game_objects, i)
        end
    end

    self.timer:update(dt)
end

function Stage:draw()
    --self.area:draw()
    for  _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

return Stage
```

Circle object
```lua
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
```

### 50. The solution to exercise 1 introduced the random function. Augment that function so that it can take only one value instead of two and it should generate a random real number between 0 and the value on that case (when only one argument is received). Also augment the function so that min and max values can be reversed, meaning that the first value can be higher than the second.


### 51. What is the purpose of the local opts = opts or {} in the addGameObject function?