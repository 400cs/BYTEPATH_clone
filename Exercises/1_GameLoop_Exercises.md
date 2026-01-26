### 1. What is the role that Vsync plays in the game loop? It is enabled by default and you can disable it by calling love.window.setMode with the vsync attribute set to false. 
Vsync limits the dt in game loop so that the frame rate is equal to the refresh rate. This is usually 60 fps.

**Authors answer:**
When Vsync is enabled the game will be kept at a frame rate consistent with your monitor's refresh rate. In most cases this means that it will automatically be capped at 60fps. To test that this is the case, we can create a variable named frame which will count the frame we're in. We start it at 0 and increase it by 1 every frame:

```lua
function love.load()

    frame = 0

end

​

function love.update(dt)

    frame = frame + 1

    print(frame)

end
```
And if you run this you should see the number printed go up by about 60 every second.

However, if you turn Vsync off by calling ```love.window.setMode(800, 600, {vsync = false})``` in love.load and then run it again, you'll see that it goes up much faster. This is because by default the love.run function contains almost no code to keep the while true loop from going super sonic fast, which means that it will do just that.
```lua
function love.load()
	frame = 0
	love.window.setMode(800, 600, {vsync = false})
end

function love.update(dt)
	frame = frame + 1
	print(dt)
end

function love.draw()
	love.graphics.print("Frame: "..frame, 400, 300)
end

```
The only thing that does keep it in check somewhat is the love.timer.sleep(0.001) call, which is explained in the love.run page. As explained there, if Vsync is disabled, this call is used to keep the FPS capped at 1000, to decrease CPU usage and give the OS control for a bit every frame.

For the next exercises we'll assume that Vsync is enabled. The Fix Your Timestep article makes the same assumption, but also does a good job of outlining the problems with each method and also considering what happens with each when Vsync might be turned off.


### 2. Implement the Fixed Delta Time loop from the Fix Your Timestep article by changing love.run.
```lua
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
```

**Authors answer:**
We want to implement the Fixed Delta Time loop. As the article states, this one uses a fixed delta of 1/60s. In the default love.run function the delta changes based on the value returned by love.timer.getDelta, and that changes based on the time taken between the two last frames. So the default implementation is definitely not a fixed delta of 1/60s. To achieve that, we need to first remove the sections that change the delta in any way. So this piece of code will be removed:

 
```lua
if love.timer then

    love.timer.step()

    dt = love.timer.getDelta()

end
```
And then we need to define our dt variable to the value we want it to have, which is 1/60:

 
```lua
local dt = 1/60
```
And so the love.run function would look like this:

 
```lua
function love.run()

    if love.math then love.math.setRandomSeed(os.time()) end

    if love.load then love.load(arg) end

    

    local dt = 1/60

​

    -- Main loop time.

    while true do

        -- Process events.

        if love.event then

            love.event.pump()

            for name, a,b,c,d,e,f in love.event.poll() do

                if name == "quit" then

                    if not love.quit or not love.quit() then

                        return a

                    end

                end

                love.handlers[name](a,b,c,d,e,f)

            end

        end

​

        -- Call update and draw

        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

    

        if love.graphics and love.graphics.isActive() then

            love.graphics.clear(love.graphics.getBackgroundColor())

            love.graphics.origin()

            if love.draw then love.draw() end

            love.graphics.present()

        end

​

        if love.timer then love.timer.sleep(0.001) end

    end

end
```
The problems with this approach are explained in the article, but that's how you'd do it if you wanted to for some reason.

**Article:** In many ways this code is ideal. If you're lucky enough to have your delta time match the display refresh rate, and you can ensure that your update loop takes less than one frame worth of real time, then you already have the perfect solution for updating your physics simulation and you can stop reading this article.

But in the real world you may not know the display refresh rate ahead of time. VSYNC could be turned off, or you could be running on a slow computer which cannot update and render your frame fast enough to present it at 60fps.

In these cases your simulation will run faster or slower than you intended.


### 3. Implement the Variable Delta Time loop from the Fix Your Timestep article by changing love.run.
```lua
-- Default LÖVE loop, which is the same as Variable Delta Time loop
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	local dt = 1/60

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
```

**Authors answer:**
Now we want to implement the Variable Delta Time loop. The way this is described is as follows:

    Just measure how long the previous frame takes, then feed that value back in as the delta time for the next frame.

If we go back to the description of the love.timer.step and love.timer.getDelta functions that are used in the default love.run implementation, it turns out that that's exactly what they do. So there seems to be no differences between the default love.run implementation and the Variable Delta Time loop. This is what it looks like: *same as mine-Default LÖVE loop*

**Article:** But there is a huge problem with this approach which I will now explain. The problem is that the behavior of your physics simulation depends on the delta time you pass in. The effect could be subtle as your game having a slightly different "feel" depending on framerate or it could be as extreme as your spring simulation exploding to infinity, fast moving objects tunneling through walls and players falling through the floor!

One thing is for certain though and that is that it's utterly unrealistic to expect your simulation to correctly handle any delta time passed into it. To understand why, consider what would happen if you passed in 1/10th of a second as delta time? How about one second? 10 seconds? 100? Eventually you'll find a breaking point.


### 4. Implement the Semi-Fixed Timestep loop from the Fix Your Timestep article by changing love.run.
```lua
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
    local max_dt = 1/60

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then 
            dt = love.timer.step()
        end

        while dt > 0 do
            local current_dt = min(dt, max_dt)
            -- Call update and draw
            if love.update then love.update(current_dt) end -- will pass 0 if love.timer is disabled
            dt = current_dt - max_dt
        end

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
```

**Authors answer:**
 Now for the Semi-fixed Timestep loop. We should now add an upper-bound for the dt value as well as making sure that if that value goes above that limit, we divide the timestep into multiple parts. We can achieve that by simply changing what happens around the love.update call:
 
```lua
while dt > 0 do

    local current_dt = math.min(dt, upper_dt)

    if love.update then love.update(current_dt) end

    dt = dt - current_dt

end
```

The dt variable corresponds to frameTime and current_dt corresponds to deltaTime. We also use upper_dt, which can be defined where dt is initialized like local upper_dt = 1/60. And all that looks like this:
 
```lua
function love.run()

    if love.math then love.math.setRandomSeed(os.time()) end

    if love.load then love.load(arg) end

    if love.timer then love.timer.step() end

​

    local dt = 0

    local upper_dt = 1/60

​

    while true do

        if love.event then

            love.event.pump()

            for name, a,b,c,d,e,f in love.event.poll() do

                if name == 'quit' then

                    if not love.quit or not love.quit() then

                        return a

                    end

                end

                love.handlers[name](a,b,c,d,e,f)

            end

        end

​

        if love.timer then

            love.timer.step()

            dt = love.timer.getDelta()

        end

​

        while dt > 0 do

            local current_dt = math.min(dt, upper_dt)

            if love.update then love.update(current_dt) end

            dt = dt - current_dt

        end

​

        if love.graphics and love.graphics.isActive() then

            love.graphics.clear(love.graphics.getBackgroundColor())

            love.graphics.origin()

            if love.draw then love.draw() end

            love.graphics.present()

        end

​

        if love.timer then love.timer.sleep(0.001) end

    end

end
```

**Article:** The benefit of this approach is that we now have an upper bound on delta time. It's never larger than this value because if it is we subdivide the timestep. The disadvantage is that we're now taking multiple steps per-display update including one additional step to consume any the remainder of frame time not divisible by dt. This is no problem if you are render bound, but if your simulation is the most expensive part of your frame you could run into the so called "spiral of death".

What is the spiral of death? It's what happens when your physics simulation can't keep up with the steps it's asked to take. For example, if your simulation is told: "OK, please simulate X seconds worth of physics" and if it takes Y seconds of real time to do so where Y > X, then it doesn't take Einstein to realize that over time your simulation falls behind. It's called the spiral of death because being behind causes your update to simulate more steps to catch up, which causes you to fall further behind, which causes you to simulate more steps...

So how do we avoid this? In order to ensure a stable update I recommend leaving some headroom. You really need to ensure that it takes significantly less than X seconds of real time to update X seconds worth of physics simulation. If you can do this then your physics engine can "catch up" from any temporary spike by simulating more frames. Alternatively you can clamp at a maximum # of steps per-frame and the simulation will appear to slow down under heavy load. Arguably this is better than spiraling to death, especially if the heavy load is just a temporary spike.

### 5. Implement the Free the Physics loop from the Fix Your Timestep article by changing love.run.
```lua
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
	local fixed_dt = 1/60
	local accumulator = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		accumulator = accumulator + dt
		while accumulator >= fixed_dt do
			-- Call update and draw
			if love.update then love.update(fixed_dt) end -- will pass 0 if love.timer is disabled
			accumulator = accumulator - fixed_dt
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
```

**Authors Answer:**
 Finally, the Free the Physics loop, which is similar to the previous solution, except that we constrain ourselves to only go with fixed steps. The benefits that come from this is that our simulations are going to be more well behaved and predictable even under various different circumstances.

The only thing we really need to do is setup everything that happens around the love.update call as the pseudocode from the article shows:

```lua
accumulator = accumulator + dt

while accumulator >= fixed_dt do

    if love.update then love.update(fixed_dt) end

    accumulator = accumulator - fixed_dt

end
```
And so this follows the same logic as the previous exercise, where if the frame time exceeds a certain value, then we subdivide the timestep into multiple parts (but this time they're parts of fixed size). The accumulator and fixed_dt variables can be set up outside the while loop and it all looks like this:


**Article:** Now let's take it one step further. What if you want exact reproducibility from one run to the next given the same inputs? This comes in handy when trying to network your physics simulation using deterministic lockstep, but it's also generally a nice thing to know that your simulation behaves exactly the same from one run to the next without any potential for different behavior depending on the render framerate.

But you ask why is it necessary to have fully fixed delta time to do this? Surely the semi-fixed delta time with the small remainder step is "good enough"? And yes, you are right. It is good enough in most cases but it is not exactly the same due to to the limited precision of floating point arithmetic.

What we want then is the best of both worlds: a fixed delta time value for the simulation plus the ability to render at different framerates. These two things seem completely at odds, and they are - unless we can find a way to decouple the simulation and rendering framerates.

Here's how to do it. Advance the physics simulation ahead in fixed dt time steps while also making sure that it keeps up with the timer values coming from the renderer so that the simulation advances at the correct rate. For example, if the display framerate is 50fps and the simulation runs at 100fps then we need to take two physics steps every display update. Easy.

What if the display framerate is 200fps? Well in this case it we need to take half a physics step each display update, but we can't do that, we must advance with constant dt. So we take one physics step every two display updates.

Even trickier, what if the display framerate is 60fps, but we want our simulation to run at 100fps? There is no easy multiple. What if VSYNC is disabled and the display frame rate fluctuates from frame to frame?

If you head just exploded don't worry, all that is needed to solve this is to change your point of view. Instead of thinking that you have a certain amount of frame time you must simulate before rendering, flip your viewpoint upside down and think of it like this: the renderer produces time and the simulation consumes it in discrete dt sized steps.

Notice that unlike the semi-fixed timestep we only ever integrate with steps sized dt so it follows that in the common case we have some unsimulated time left over at the end of each frame. This left over time is passed on to the next frame via the accumulator variable and is not thrown away.