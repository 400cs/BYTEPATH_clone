# Game Size Exercises
### 65. Take a look at Steam's Hardware Survey in the primary resolution section. The most popular resolution, used by almost half the users on Steam is 1920x1080. This game's base resolution neatly multiplies to that. But the second most popular resolution is 1366x768. 480x270 does not multiply into that at all. What are some options available for dealing with odd resolutions once the game is fullscreened into the player's monitor?
**Use blackbars**, maybe do something with the camera, **multiply by a non-integer**

One option available is to just multiply the screen by non-integer numbers. To fit the base resolution of `480x270` in a screen size of `1366x768`, we would need to set `sx` and `sy` to be 2.84. The problem with this approach is that for different resolutions sx and sy might be different, which would lead to distortions, and even if they are the same, multiplying by a non-integer number can make the screen look off in a number of ways.

Another option is to always multiply by integers but then fill the screen with borders whenever there are pixels left. For instance, suppose the user has a screen size of `1440x900` and we want to fit our game into it. We'll go to the closest possible integer multiplication, which is `1440x810` with the integer being 3, and then we'll see how many pixels are left horizontally and vertically. In this case horizontally it fits perfectly, but vertically there's about 90 pixels left. So what we do is draw the canvas offset by 45, and then draw our borders above and below it, each covering the entire size of the screen in width, and with 45 as height. The problem with this approach is that it can look a little weird.


### 66. Pick a game you own that uses the same or a similar technique to what we're doing here (scaling a small base resolution up). Usually games that use pixel art will do that. What is that game's base resolution? How does the game deal with odd resolutions that don't fit neatly into its base resolution? Change the resolution of your desktop and run the game various times with different resolutions to see what changes and how it handles the variance.
vampire suriviors, idk the base resolution, but uses the 3:2 ratio, so 1920x1280, 960x640, etc. The game 1st deals with resolution by not being full screened and just uses a window thats smaller than the monitor. The 2nd way the game deals with resolution is to stretch the screen to fullfill a list of resolutions, it doesn't always look pretty.


The game I chose was FTL. The base resolution of it appears to be 1280x720, as this image shows:

This game deals with resolution issues in 4 ways. The first is that the game is just not fullscreened and happens entirely on a window that's smaller than the monitor. This is the easiest solution. The second is that it stretches the screen to fit the full screen size. This makes the game look a little ugly. The third is that it uses horizontal and vertical borders and keeps the game at the minimum resolution possible, that looks like this:

Because my full screen size is 1920x1080, the base resolution of 1280x720 only fits once, which means that it can't be expanded further, so the black borders cover the rest of the screen. This solution looks off too. The final solution is to just fullscreen the game and force a friendly native resolution on the computer of the player whenever the game is fullscreened. This essentially changes the monitor's resolution when the game has to focus to a certain target size.

Most of these solutions are not ideal but they're about the best that can be done. Most pixel art games that I've seen face issues like this and there's no one size fits all solution that is perfect. It's all about compromises here and there.

