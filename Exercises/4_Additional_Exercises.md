# Exercises

### 52. Create a `getGameObjects` function inside the `Area` class that works as follows:
```lua
-- Get all game objects of the Enemy class
all_enemies = area:getGameObjects(function(e)
    if e:is(Enemy) then
        return true
    end
end)

-- Get all game objects with over 50 HP
healthy_objects = area:getGameObjects(function(e)
    if e.hp and e.hp >= 50 then
        return true
    end
end)
```
It receives a function that receives a game object and performs some test on it. If the result of the test is true then the game object will be added to the table that is returned once `getGameObjects` is fully run.

**my solution:**
```lua
function Area:getGameObjects(func)
    local filtered_game_objects = {}
    for _, game_object in ipairs(self.game_objects) do
        if func(game_object) then
            table.insert(filtered_game_objects, game_object)
        end
    end
    return filtered_game_objects
end
```

**answer key's solution:**

We're tasked with creating a function named `getGameObjects` that receives a function that performs a test on an entity. If the entity passes the test then true is returned and that entity is added to a list that will be returned by `getGameObjects`. This exercise is basically asking if you have a good understanding of what passing functions around to other functions as arguments can achieve.
```lua
function Area:getGameObjects(filter)
    local out = {}
    for _, game_object in ipairs(self.game_objects) do
        if filter(game_object) then
            table.insert(out, game_object)
        end
    end
    return out
end
```


### 53. What is the value in `a`, `b`, `c`, `d`, `e`, `f` and `g`?
```lua
a = 1 and 2
b = nil and 2
c = 3 or 4
d = 4 or false
e = nil or 4
f = (4 > 3) and 1 or 2
g = (3 > 4) and 1 or 2
```
**my solution:**

a = 2;
b = nil;
c = 3;
d = 4;
e = 4;
f = 1;
g = 2;

*note from lua doc:*
The logical operators are `and`, `or`, and `not`. Like control structures, all logical operators consider `false` and `nil` as false and anything else as true. The operator `and` returns its first argument if it is false; otherwise, it returns its second argument. The operator `or` returns its first argument if it is not false; otherwise, it returns its second argument:
```lua
    print(4 and 5)         --> 5
    print(nil and 13)      --> nil
    print(false and 13)    --> false
    print(4 or 5)          --> 4
    print(false or 5)      --> 5
```
Both and and or use short-cut evaluation, that is, they evaluate their second operand only when necessary.


**answer key's solution:**

This exercise is asking if you understand how the `and` and `or` operators work and how they can be used to check for certain conditions.

For the variable `a` the result is 2. Whenever two variables are true in an `and` operation, the second variable will always be the returned result. This is useful in a number of situations, like in the previous exercise the line `if e.hp and e.hp >= 50 then` is asking if `e.hp`exists, and then if it does, checking if that value is over 50. If `e.hp` doesn't exist, then that will be `nil` and the next check won't even be run (and if it was run it would result in an an error, since it would be asking if `nil >= 50` which can't be done). In this way we can check to see if a certain attribute exists and then use that attribute in some way all in the same line instead of doing something like this:

 ```lua
if e.hp then
    if e.hp >= 50 then
    
    end
end
```
For the variable `b` the result is `nil`. In Lua only `nil` and `false` are false values, so there's no way for this to be anything else. Like I just said, if the first element of an `and` operation is false, then the second one is not even checked, so in this case the value 2 is irrelevant.

For the variable `c` the result is 3. Whenever two variables are true in an `or` operation, the first variable will always be the returned result. This is useful in a number of situations, like whenever we do stuff like `opts = opts or {}`. If the `opts` that's passed in is `nil`, then the `or` will return the empty table. But if the `opts` value is defined then it will just return `opts` itself. Using `or` like this we can check to see if some value that was passed in was actually passed in or not instead of doing something like this:

```lua
if not opts then
    opts = {}
end
```
For the variable `d` the result is 4. If one of the elements in an `or` operation is false then it will just return the one that's true. For the variable `e` the result is 4 as well and the same logic can be used to explain it.

For the variable `f` the result is 1. First, `(4 > 3)` is true, so the whole thing parses out to `true and 1 or 2`. `and` takes precedence over `or`, so first we parse `true and 1` which returns 1. Now we have `1 or 2` left, which parses out to 1 again.

For the variable `g` the result is 2. First, `(3 > 4)` is false, so the whole thing parses out to `false and 1 or 2`. Then we parse `false and 1` which is false, and finally we're left with `false or 2`, which is 2.


### 54. Create a function named `printAll` that receives an unknown number of arguments and prints them all to the console. `printAll(1, 2, 3)` will print 1, 2 and 3 to the console and `printAll(1, 2, 3, 4, 5, 6, 7, 8, 9)` will print from 1 to 9 to the console, for instance. The number of arguments passed in is unknown and may vary.
**my solution**
```lua
function printAll(...)
    local args = {...}
    for _, arg in ipairs(args) do 
        print(arg)
    end
end
```
This question is asking for your understanding of the `...` construct in Lua. Whenever you define the arguments of a function as `...`, it means that the function can receive an unknown amount of arguments and that you'll deal with separating them inside. So, our function could look like this:
```lua
function printAll(...)
    local args = {...}
    for _, arg in ipairs(args) do
        print(arg)
    end
end
```
So we just capture all the arguments passed in inside the table args and then we simply go over that table and print each value.

### 55. Similarly to the previous exercise, create a function named `printText` that receives an unknown number of strings, concatenates them all into a single string and then prints that single string to the console.
```lua
function printText(...)
    local args = {...}
    local str = ""
    for _, arg in ipairs(args) do
        str = str .. arg
    end
    print(str)
end
```

### 56. How can you trigger a garbage collection cycle?
By dereferencing all instances of that variable, setting all references to nil. For example, `a = game_object("gun")` and an area called `EquipStage` has a self.game_objects = {a = game_object("gun"), ...}, both instances of this `a` need to be set to `nil` for this object to be garbage collected.

**answer key's solution:**

The `collectgarbage` function can be used to do a number of things related to the garbage collector. As the link states, calling it like `collectgarbage("collect")` will perform a full garbage collection cycle.


### 57. How can you show how much memory is currently being used up by your Lua program?
`collectgarbage("count")`

"count": Returns the total memory in use by Lua in Kbytes. The value has a fractional part, so that it multiplied by 1024 gives the exact number of bytes in use by Lua.


### 58. How can you trigger an error that halts the execution of the program and prints out a custom error message?
error (message [, level])
Raises an error with message as the error object. This function never returns.

**answer key's solution:**

We can use the error function to do this. I personally rarely use this function in game code, but if you're building a library and you want to lock off certain paths of execution it's useful to halt execution when those paths are activated and tell the user how they used your library inappropriately. It's a way better thing to do than just failing silently.


### 59. Create a class named `Rectangle` that draws a rectangle with some width and height at the position it was created. Create 10 instances of this class at random positions of the screen and with random widths and heights. When the d key is pressed a random instance should be deleted from the environment. When the number of instances left reaches 0, another 10 new instances should be created at random positions of the screen and with random widths and heights.
**my solution:**
```lua
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
```

```lua
local RectangleRoom = Object:extend()

function RectangleRoom:new()
    self.area = Area()
    self:createTenRandom()
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
```

### 60. Create a class named `Circle` that draws a circle with some radius at the position it was created. Create 10 instances of this class at random positions of the screen with random radius, and also with an interval of 0.25 seconds between the creation of each instance. After all instances are created (so after 2.5 seconds) start deleting once random instance every [0.5, 1] second (a random number between 0.5 and 1). After all instances are deleted, repeat the entire process of recreation of the 10 instances and their eventual deletion. This process should repeat forever.
**my solution:**
```lua
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
```

```lua
local Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()

    local function process()
        self.timer:cancel('create_process')
        self.timer:cancel('remove_process')

        self.timer:every(0.25, function()
		    self.area:addGameObject('Circle', random(0,800), random(0, 600))
	    end, 10, nil, 'create_process')
    
        self.timer:after(2.5,function()
            self.timer:every(random(0.5, 1), function()
                table.remove(self.area.game_objects, random(1, #self.area.game_objects))
                if #self.area.game_objects == 0 then
                process()
                end
            end, 10, nil, 'remove_process')
        end)
    end
    
    process()
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
**answer key's solution:**

First we create the default `Circle` class:

```lua
Circle = GameObject:extend()
​
function Circle:new(area, x, y, opts)
    Circle.super.new(self, area, x, y, opts)
    self.r = random(10, 50)
end
​
function Circle:update(dt)
    Circle.super.update(self, dt)
end
​
function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, self.r)
end
```
Now we need to create 10 instances of this class, but with an interval of 0.25 between the creation of each instance:

```lua
function Stage:new()
    ...
    for i = 1, 10 do
        timer:after(i*0.25, function()
            self.area:addGameObject('Circle', random(0, 800), random(0, 600))
        end)
    end
end
```
Using the `timer:after` call inside the for loop we can make it so that one instance will get spawned every 0.25 seconds by multiplying i by 0.25 and using that as the argument for the after call.

Now it says that after all the instances are created we need to delete a random one every [0.5, 1] second:

```lua
function Stage:new()
    ...
        
    timer:after(2.5, function()
        timer:every(random(0.5, 1), function()
            table.remove(self.area.game_objects, love.math.random(1, #self.area.game_objects))
        end, 10)
    end)
end
```
So, after the initial 2.5 seconds of creating instances, we create an every timer that will run with an interval of between 0.5 and 1 second and will remove an instance each time it is run.

Now the last thing the exercise asks for is to restart the process again once the number of instances left reaches 0. Similarly to the previous exercise we can just check the number of entities left in game_objects:

```lua
function Stage:new()
    ...
        
    timer:after(2.5, function()
        timer:every(random(0.5, 1), function()
            table.remove(self.area.game_objects, love.math.random(1, #self.area.game_objects))
            if #self.area.game_objects == 0 then
                -- restart
            end
        end)
    end)
end
```
Now the question is what do we put in place of --restart? The exercise asks for this process to repeat forever, so the first instinct would be to put this all into a function, and then call this function from within itself whenever it should be repeated. That would look something like this:

```lua
function Stage:new()
    local function process()
        for i = 1, 10 do
            timer:after(i*0.25, function()
                self.area:addGameObject('Circle', random(0, 800), random(0, 600))
            end)
        end
        
        timer:after(2.5, function()
            timer:every(random(0.5, 1), function()
                table.remove(self.area.game_objects, love.math.random(1, #self.area.game_objects))
                if #self.area.game_objects == 0 then
                    process()
                end
            end)
        end)
    end
    
    process()
end
```
The only problem with this approach is that the first time it is called it will create one every timer, the second time it is called it will create another, and so on. In the end we will have multiple every timers operating at the same time and that will lead to bugs. One easy way to fix it is to label the every timer so that whenever it's called again, the previous one is cancelled.

```lua
timer:every('process_every', random(0.5, 1), function()
    ...
end)
```
And another thing we need to do is to also cancel the previous every timer whenever the process restarts again, or instances will be removed until the next every is called, which is something we don't want:

```lua
local function process()
    timer:cancel('process_every')
    ...
end
```
This exercise is very very tricky and there are many ways to get lost. But this is also the kind of thing that you have to do all the time in games. Understanding and controlling things so that they happen in appropriate orders and at appropriate times is very important, so make sure you understand everything that's happening!


### 61. Create a `queryCircleArea` function inside the Area class that works as follows:
```lua
-- Get all objects of class 'Enemy' and 'Projectile' in a circle of 50 radius around point 100, 100
objects = area:queryCircleArea(100, 100, 50, {'Enemy', 'Projectile'})
```
It receives an x, y position, a radius and a list of strings containing names of target classes. Then it returns all objects belonging to those classes inside the circle of radius radius centered in position x, y.

**my solution:**

```lua
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
```
in utils.lua
```lua
function distance(x1, y1, x2, y2)
    return math.sqrt( (y1 - y2)^2 + (x1 - x2)^2 )
end
```
**answer key's solution:**

The first thing we need to do is to go over all game objects in an Area and check to see if they are of the target classes we want:

 ```lua
function Area:queryCircleArea(x, y, radius, object_types)
    for _, game_object in ipairs(self.game_objects) do
        if fn.any(object_types, game_object.class)
      
        end
    end
end
```
Here I make use of the .class attribute, which holds the name of the class this object belongs to. We didn't define this previously but it can be easily added to every object that is inside the Area in the `addGameObject` function:

 ```lua
function Area:addGameObject(game_object_type, ...)
    ...
    game_object.class = game_object_type
    table.insert(self.game_objects, game_object)
    return game_object
end
```
This is mostly something convenient so we can use the `any` (aka `include`) function from ***moses*** We can achieve all this without this function and instead just looping over the `object_types` list and using ***classic's*** `is` function instead. Either way works but the first one feels cleaner.

Now that we know if the game object is or isn't of the type we're looking for, we can do the actual check to see if it's inside our determined radius or not. To do this we'll use a small function called `distance`, which computes the distance between two points:

 ```lua
function distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))
end
And so with that we can do this:

 
if fn.any(object_types, game_object.class)
    local d = distance(x, y, game_object.x, game_object.y)
    if d <= radius then
    
    end
end
```
Here we simply check the distance between the center of the radius and the center of the object. If that distance is lower than the radius then we'll add that object to a list, which we will then return once the loop is over:

 ```lua
function Area:queryCircleArea(x, y, radius, object_types)
    local out = {}
    for _, game_object in ipairs(self.game_objects) do
        if fn.any(object_types, game_object.class)
            local d = distance(x, y, game_object.x, game_object.y)
            if d <= radius then
                table.insert(out, game_object)
            end
        end
    end
    return out
end
```


### 62. Create a getClosestGameObject function inside the Area class that works follows:
```lua
-- Get the closest object of class 'Enemy' in a circle of 50 radius around point 100, 100
closest_object = area:getClosestObject(100, 100, 50, {'Enemy'})
It receives the same arguments as the queryCircleArea function but returns only one object (the closest one) instead.
```
**my solution:**

```lua
function Area:getClosestGameObject(x, y, radius, object_types)
    local game_objects_within_area = self:queryCircleArea(x, y, radius, object_types)

    fn.sort(game_objects_within_area, function(a, b)
        local a_d = distance(x, y, a.x, a.y)
        local b_d = distance(x, y, b.x, b.y)
        return a_d < b_d
    end)
    
    return game_objects_within_area[1]
end
```
**answer key's solution:**

This one is very similar to the previous exercise, except that instead of returning all objects inside the circle, we just return the one that's closest to the target point. To start with, we can use the function we defined in the previous exercise to get all objects that are actually inside the circle:

```lua
function Area:getClosestObject(x, y, radius, object_types)
    local objects = self:queryCircleArea(x, y, radius, object_types)
end
```
Now what we need to do is to somehow sort this table so that the first objects in it are closer and the last ones are further away. An easy way to do that is using table.sort:

 ```lua
function Area:getClosestObject(x, y, radius, object_types)
    local objects = self:queryCircleArea(x, y, radius, object_types)
    table.sort(objects, function(a, b)
        local da = distance(x, y, a.x, a.y)
        local db = distance(x, y, b.x, b.y)
        return da < db
    end)
end
```
And so with this, we will place objects that have a smaller distance from the target first in the list. Since we know that closer objects are first, to get the closest one all we need to do is return the first object:

```lua
function Area:getClosestObject(x, y, radius, object_types)
    local objects = self:queryCircleArea(x, y, radius, object_types)
    table.sort(objects, function(a, b)
        local da = distance(x, y, a.x, a.y)
        local db = distance(x, y, b.x, b.y)
        return da < db
    end)
    return objects[1]
end
```


### 63. How would you check if a method exists on an object before calling it? And how would you check if an attribute exists before using its value?
Just do if `object.attribute` or `object.method`

We can check if a method or attribute exists by just using a conditional. For instance, if we want to check if `self` has the attribute `damage` then we can do `if self.damage then`. If we want to check if it has the attribute `damage` and if that damage is higher than 10 then we can do `if self.damage and self.damage > 10 then`. The use of the `and` operator like this was explained in a previous exercise.

### 64. Using only one for loop, how can you write the contents of one table to another?
```lua
local new_table = {}
for k, v in pairs(t) do
    new_table[k] = v
end
```
**answer key's solution:**

Suppose we have table a and table b and we want to copy table a to table b. To achieve that we'd do the following:

```lua
for k, v in pairs(a) do
    b[k] = v
end
```
Using the pairs function we can go over all keys and indexes of the source table and then use those to directly set the appropriate values on the target table.