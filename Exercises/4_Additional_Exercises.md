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

***my solution:***
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

***answer key's solution***

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
***my solution***
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


***answer key's solution***

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


### 55. Similarly to the previous exercise, create a function named `printText` that receives an unknown number of strings, concatenates them all into a single string and then prints that single string to the console.


### 56. How can you trigger a garbage collection cycle?


### 57. How can you show how much memory is currently being used up by your Lua program?


### 58. How can you trigger an error that halts the execution of the program and prints out a custom error message?


### 59. Create a class named `Rectangle` that draws a rectangle with some width and height at the position it was created. Create 10 instances of this class at random positions of the screen and with random widths and heights. When the d key is pressed a random instance should be deleted from the environment. When the number of instances left reaches 0, another 10 new instances should be created at random positions of the screen and with random widths and heights.


### 60. Create a class named `Circle` that draws a circle with some radius at the position it was created. Create 10 instances of this class at random positions of the screen with random radius, and also with an interval of 0.25 seconds between the creation of each instance. After all instances are created (so after 2.5 seconds) start deleting once random instance every [0.5, 1] second (a random number between 0.5 and 1). After all instances are deleted, repeat the entire process of recreation of the 10 instances and their eventual deletion. This process should repeat forever.


### 61. Create a `queryCircleArea` function inside the Area class that works as follows:
```lua
-- Get all objects of class 'Enemy' and 'Projectile' in a circle of 50 radius around point 100, 100
objects = area:queryCircleArea(100, 100, 50, {'Enemy', 'Projectile'})
```
It receives an x, y position, a radius and a list of strings containing names of target classes. Then it returns all objects belonging to those classes inside the circle of radius radius centered in position x, y.


### 62. Create a getClosestGameObject function inside the Area class that works follows:
```lua
-- Get the closest object of class 'Enemy' in a circle of 50 radius around point 100, 100
closest_object = area:getClosestObject(100, 100, 50, {'Enemy'})
It receives the same arguments as the queryCircleArea function but returns only one object (the closest one) instead.
```

### 63. How would you check if a method exists on an object before calling it? And how would you check if an attribute exists before using its value?


### 64. Using only one for loop, how can you write the contents of one table to another?
