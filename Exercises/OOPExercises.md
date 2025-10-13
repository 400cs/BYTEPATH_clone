### 6. Create a Circle class that receives x, y and radius arguments in its constructor, has x, y, radius and creation_time attributes and has update and draw methods. The x, y and radius attributes should be initialized to the values passed in from the constructor and the creation_time attribute should be initialized to the relative time the instance was created (see love.timer). The update method should receive a dt argument and the draw function should draw a white filled circle centered at x, y with radius radius (see love.graphics). An instance of this Circle class should be created at position 400, 300 with radius 50. It should also be updated and drawn to the screen.

```lua
Circle = Object:extend()

function Circle:new(x, y, radius)
    self.x, self.y, self.radius = x, y, radius
    Circle.creation_time = love.timer.getTime()
end

function Circle:update(dt)

end

function Circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
```

```lua
-- In main.lua
function love.load()
    circle = Circle(400, 300, 50)
end
```

### 7. Create an HyperCircle class that inherits from the Circle class. An HyperCircle is just like a Circle, except it also has an outer ring drawn around it. It should receive additional arguments line_width and outer_radius in its constructor. An instance of this HyperCircle class should be created at position 400, 300 with radius 50, line width 10 and outer radius 120.

```lua
HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, line_width, outer_radius)
    HyperCircle.super.new(self, x, y, radius)
    self.line_width, self.outer_radius = line_width, outer_radius
    Circle.creation_time = love.timer.getTime()
end

function HyperCircle:update(dt)
    HyperCircle.super.update(self, dt)
end

function HyperCircle:draw()
    HyperCircle.super.draw(self)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.circle("line", self.x, self.y, self.outer_radius)
    love.graphics.setLineWidth(1)
end
```
```lua
-- In main.lua
function love.load()
	hyperCircle = HyperCircle(400, 300, 50, 10, 120)
end
```

### 8. What is the purpose of the : operator in Lua? How is it different from . and when should either be used?
In Lua, the : operator is used for method invocation where the first agrument is self, while the . operator is used for accessing table fields, which can also be methods.

**Author's Answer:** The : operator in Lua is used as a shorthand for passing self as the first argument of a function when calling it. For instance, both of these lines are the same thing:

 
```lua
instance.method(instance, ...)

instance:method(...)
```
This is a very common pattern in Lua when you have functions that are operating on some object that are also defined on that object, which happens often with object oriented programming. For instance, let's say we have a table that contains fields x, y and add in it. x and y are values, and add is a function adds those two values together and returns them. One way to define this would be like this:

 
```lua
local t = {}

t.x = 5

t.y = 4

t.add = function(self)

    return self.x + self.y

end
```
Note that the add function receives a self argument. This argument corresponds to a table that contains that x and y attributes which we want to add. If we call it like this:

 
```lua
t:add()
```
Then we're passing the t table itself to the add function, and so the return result will be 9. Similarly, we could call it like this:

 
```lua
t.add(t)
```
And we'd achieve the same result. We could also define another table ```u``` with different ```x``` and ```y``` values, and then call ```t.add(u)``` and we'd get a different result other than 9, however this is generally not what people do. In general the way objects are built in Lua are like more like the first example where we called ```t:add()``` , since the table will be operating on its own values instead of on another table's values.

### 9. Suppose we have the following code:

```lua
function createCounterTable()
    return {
        value = 1,
        increment = function(self) self.value = self.value + 1 end,
    }
end

function love.load()
    counter_table = createCounterTable()
    counter_table:increment()
end
```
### What is the value of counter_table.value? Why does the increment function receive an argument named self? Could this argument be named something else? And what is the variable that self represents in this example?
counter_table.value is 2. ```increment``` function receive an argument named ```self```, so that the function uses the attributes of the tables (```value```) that calls it . If the argument is named something else than the argument is refering to something else bysides the table calling it, i.e. another table that isn't the the table calling ```increment()```. ```self``` represents the table returned from ```createCounterTable()```.

**Author's Answer:**This question expands on the previous question to test if you really understood the idea that tables can have functions defined in them that will change the table's own attributes.

The value of ```counter_table.value``` is initially what it was defined to be, which is 1. And then after the ```counter_table:increment()``` call it got changed to 2. ```counter_table:increment()``` is the same as ```counter_table.increment(counter_table)```, which means that the self variable in that function definition, in this example, corresponds to the counter_table variable itself, which is why counter_table.value was able to be incremented in the first place.

If we had defined another table called ```counter_table_2``` which had its ```.value``` attribute defined to 5, and then called ```counter_table.increment(counter_table_2)```, ```counter_table.value``` would still be 1 and ```counter_table_2.value``` would be 6.

### 10. Create a function that returns a table that contains the attributes a, b, c and sum. a, b and c should be initiated to 1, 2 and 3 respectively, and sum should be a function that adds a, b and c together. The final result of the sum should be stored in the c attribute of the table (meaning, after you do everything, the table should have an attribute c with the value 6 in it).
```lua
function createSumTable()
    return {
        a = 1, b = 2, c = 3,
        sum = function(self) self.c = self.a + self.b + self.c end,
    }
end

x = createSumTable()
x:sum()
```
**Author's Answer:** This question expands even further on the same concept to really make sure you get it. If you had to get help from the answers for the previous two questions and you couldn't get close to the answer by yourself then you need to spend more time on this idea before you move on. Understanding this is truly essential to understanding how Lua works.

The question is simply asking for a construct similar to the one used in the previous exercise. First it asks for a function that returns a table that contains attributes a, b, c and sum. Those should be initialized, respectively, to 1, 2, 3 and sum should be a function:

 
```lua
function createSumTable()

    return {

        a = 1,

        b = 2,

        c = 3,

        sum = function()

        end,

    }

end
```
After this it says that ```sum``` should add the previous 3 attributes together, with the final result being stored in the ```c``` attribute. This means that like the previous exercise, the ```sum``` function will receive some table that we'll name ```self```, and it could be any other table, but we'll most likely call the ```sum``` function from the table that contains that function definition itself:

 
```lua
function createSumTable()

    return {

        a = 1,

        b = 2,

        c = 3,

        sum = function(self)

            self.c = self.a + self.b + self.c

        end,

    }

end

​

t = createSumTable()

t:sum()

print(t.c) --> prints 6
```
### 11. If a class has a method with the name of ```someMethod``` can there be an attribute of the same name? If not, why not?
```lua
class.someMethod = ...
function class:someMethod()
end
```
I think should be fine, because the function ```someMethod``` should have ```:``` and the ```()``` while the attribute uses ```.```. *This is not correct.*

**Author's Answer:** It is possible for a table to have a method and an attribute of the same name, however things won't work as expected. Either the method or the attribute will overwrite what was there before and then that identifier will only function as one of them. For instance, if the method ```t.x``` is defined first and it's a function that does something, but then the attribute ```t.x``` is defined as the value 5, in the end it will be the value 5 and not the function, since the value was defined later and overwrote the function definition.

Because objects will be tables in Lua, this means that method names cannot be the same as attribute names, and that you can't have multiple methods with the same name, or multiple attributes with the same name in a Lua object. Of course, because Lua is flexible, there are ways to change this behavior using metatables and do a bunch of tricky things that to the end user will make it seem like you can have multiple definitions under the same name, but no Lua OOP library I know of does that and we won't really need it.

### 12. What is the global table in Lua?
I think it is the table that holds all the global variables.

**Author's Answer:** The global table is Lua is named ```_G``` and it holds references to all global variables in Lua. Whenever you defined a new variable, like ```a = 5```, what you're really doing is saying _G['a'] = 5, and you can access the a variable by saying ```_G.a```, for instance (on top of just saying a normally). 


### 13. Based on the way we made classes be automatically loaded, whenever one class inherits from another we have code that looks like this:
```lua
SomeClass = ParentClass:extend()
```
### Is there any guarantee that when this line is being processed the ParentClass variable is already defined? Or, to put it another way, is there any guarantee that ParentClass is required before SomeClass? If yes, what is that guarantee? If not, what could be done to fix this problem?
IDK, I would think the ```extend()``` method checks or guarantees that ParentClass exist. *This is not correct.*

**Author's Answer:** There is no guarantee that ```ParentClass``` is already defined in that situation. Based on the way we defined the loading of classes, the only thing that we know for sure is that classes are loaded in alphabetical order, other than that the order in which they're loaded, it is undefined. This means that with the way we do it now, there's no way to guarantee one class is always loaded before the other.

One way to solve this is to simply manually load classes that other classes depend on and then automatically load all other classes. In the game there are only a few classes that fit this definition so this is a suitable solution.


### 14. Suppose that all class files do not define the class globally but do so locally, like:
```lua
local ClassName = Object:extend()
...
return ClassName
```
### How would the requireFiles function need to be changed so that we could still automatically load all classes?
The ```requireFiles``` function would need to assign a global varible for each class. I am unsure of how to implement it. 
```lua
-- my first try
function requireFiles(files)
    for _, file in ipairs(files) do
        if file.sub(-4) == '.lua' then
            local last_foward_slash_index = file:match'^.*()/'
            print(last_foward_slash_index)
            local index = file:find("/[^/]*$")
            print(index)
            local class_name = file:sub(index)
            print(class_name)
            local file_path = file:sub(1, -5)
            _G[class_name] = require(file_path)
        end
    end
end

-- Automatically creates global variables for each class based on the filename
-- Since the class library returns a table, we can assign it to a global variable
function requireFiles(files)
    for _, file in ipairs(files) do
        if file:sub(-4) == '.lua' then
            local file_path = file:sub(1, -5) -- remove .lua extension from filename
            local last_foward_slash_index = file_path:find("/[^/]*$")
            local class_name = file_path:sub(last_foward_slash_index + 1, #file_path)
			--the # operator in Lua is used to get the length of a string or a table
			-- or local class_name = file_path:sub(index+1)
			_G[class_name] = require(file_path)
        end
    end
end
```

**Author's Answer:** In this new way of doing it, the class is returned instead of automatically being assigned to a global variable. So the only thing we have to change in the requireFiles function is making sure that assignment to a global variable happens. The way the current function looks is like this:

 
```lua
function requireFiles(files)

    for _, file in ipairs(files) do

        local file = file:sub(1, -5)

        require(file)

    end

end
```
If we print the file variable we'll get strings like this, for instance: ```objects/ObjectName``` , where ```ObjectName``` will be the name of some class, and there will be multiple of those strings. What we want to do is take ```ObjectName``` out of this full ```objects/ObjectName``` string, and then use that as the name of our global variable, so essentially we'll be doing ```_G[ObjectName] = require(file)```. The only thing we have to do then is successfully remove the class name from the full path that we have in the ```file``` variable.

To achieve this we can first find the last ```/``` character. It has to be the last because the full path can have other folders in it in the future, like ```objects/Enemies/EnemyName```. To do this I just googled "find last specific character in string Lua" and I got this page https://stackoverflow.com/questions/14554193/last-index-of-character-in-string where someone already had the answer for the exact character we need even. So applying that to our case:

 
```lua
local file = file:sub(1, -5)

local last_forward_slash_index = file:find("/[^/]*$")

local class_name = file:sub(last_forward_slash_index+1, #file)
```
First we find the index of the last forward slash using the code from the StackOverflow question. Then we take that index and use the ```string.sub``` function to split the string, from the index found + 1 (because we don't want the forward slash in the final string) to the end of the string. This gets us exactly what we want and so the ```class_name``` variable will contain the name of the class we wanted. Now it's just a matter of loading that globally:

 
```lua
local file = file:sub(1, -5)

local last_forward_slash_index = file:find("/[^/]*$")

local class_name = file:sub(last_forward_slash_index+1, #file)

_G[class_name] = require(file)
```
Another thing that can be done here is that unload a class if it was previously loaded. This might never be useful but it's useful to know that it can be done: by calling ```package.loaded[file] = nil``` before the ```require(file)``` call, we can clear the cache that holds all files that have been previously loaded and force a full reload of that file. This is useful in a number of situations, like if we wanted to implement hot-reloading of our code.

### 15. Suppose we have the following code:
```lua
function love.load()
    input = Input()
    input:bind('mouse1', function() print(love.math.random()) end)
end
```
Will anything happen when mouse1 is pressed? What about when it is released? And held down?

When mouse1 is pressed, it will print a random number in the console/terminal. released? No. And held down? No, prints once even after holding the key down.

**Author's Answer:** For this question all that really has to be done is to test the code and see that whenever ```mouse1``` is pressed (not released nor held) the function runs. This is an alternate thing you can do with the bind function, which is to just bind a key to a function that will be executed when the key is pressed.

###  16. Bind the keypad ```+``` key to an action named ```add```, then increment the value of a variable named ```sum``` (which starts at 0) by 1 every ```0.25``` seconds when the ```add``` action key is held down. Print the value of ```sum``` to the console every time it is incremented.

```lua
function love.load()
    input = Input()
    sum = 0
    input:bind('+', 'add')
end

function love.update(dt)
    if (input:down('add', 0.25)) then 
        sum = sum + 1
        print(sum)
    end
end
```
almost correct: ```+``` is supposed to be ```kp+```.

**Author's Answer:** For this question we need to first bind the keypad + key to an action named add. To do that we need to figure out what's the string used to represent keypad +. The github page links to this page for key constants and says that for the keyboard they are the same, which means that keypad ```+``` is ```kp+```. And so the code looks like this:

 
```lua
function love.load()
    input = Input()
    input:bind('kp+', 'add')
end
```
Then the question asks to increment a sum variable every 0.25 seconds when the add action key is held down and to print the result to the console. This is simply an application of the pressRepeat function:

 
```lua
function love.load()
    input = Input()
    input:bind('kp+', 'add')
    sum = 0
end


function love.update(dt)
    if input:pressRepeat('add', 0.25) then
        sum = sum + 1
        print(sum)
    end
end
```

### 17. Can multiple keys be bound to the same action? If not, why not? And can multiple actions be bound to the same key? If not, why not?
Yes, multiple keys can be bound to the same action. Just bind that key to the action using input:bind(). No, multiple actions can not be bound to the same key, because the bind function replaces the action for a key on each call to bind(). (self.functions[key] = action;)
I was wrong. Multiple actions caan be bound to the same key.

**Author's Answer:** Multiple keys can be bound to the same action. What will happen when an action is checked for is that all the keys will be checked for at the same time, so if any of the keys was pressed an event will be generated for that action. Similarly, multiple actions can be bound to the same key and whenever the key is pressed, all actions bound to it will have an event generated for them.

### 18. If you have a gamepad, bind its DPAD buttons(fup, fdown...) to actions up, left, right and down and then print the name of the action to the console once each button is pressed.

```lua
function love.load()
    input = Input()
    input:bind('fup', 'up')
    input:bind('fleft', 'left')
    input:bind('fright', 'right')
    input:bind('fdown', 'down')
end

function love.update(dt)
    if (input:pressed('fup')) then print("up") end
    if (input:pressed('fleft')) then print("left") end
    if (input:pressed('fright')) then print("right") end
    if (input:pressed('fdown')) then print("down") end
end
```
correct

**Author's Answer:** same 

### 19. If you have a gamepad, bind one of its ```trigger``` buttons (l2, r2) to an action named trigger. Trigger buttons return a value from 0 to 1 instead of a boolean saying if its pressed or not. How would you get this value?
You could check if the value returned from pressing the trigger is greater than 0.5 in order to set it to true else it's false.

I kind of had the right idea, but used the wrong function.

**Author's Answer:** Here we see how values that are not booleans can be used. In the case of triggers, ```down``` can be used to access the value which will be somewhere between 0 and 1, depending on how hard the trigger is being pressed. 
```lua
function love.load()
    ...
    input:bind('l2', 'trigger')
end

​

function love.update(dt)
    ...
    local left_trigger_value = input:down('trigger')
    print(left_trigger_value)
end
```

### 20. Repeat the same as the previous exercise but for the left and right stick's horizontal and vertical position.
Same as the answer for 19
```lua
function love.load()
    ...
    input:bind('leftx', 'left_horizontal')
    input:bind('lefty', 'left_vertical')
    input:bind('rightx', 'right_horizontal')
    input:bind('righty', 'right_vertical')
end

​

function love.update(dt)
    ...
    local left_stick_horizonal = input:down('left_horizontal')
    local left_stick_vertical = input:down('left_vertical')
    local right_stick_horizontal = input:down('right_horizontal')
    local right_stick_vertical = input:down('right_vertical')
    print(left_stick_value, left_stick_vertical)
    print(right_stick_horizontal, right_stick_vertical)
end
```

**Author's Answer:** same

