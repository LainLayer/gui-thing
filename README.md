# gui-thing
An attempt at a GUI library for raylib (nim), heavily work in progress.

# How it looks

![A screenshot](https://github.com/LainLayer/gui-thing/blob/master/screenshot.png?raw=true "Screenshot")

# Usage

```nim
import raylib
import gui

initWindow(800, 800, "GUI Demo")

initGui() # loads the needed assets

# ... whatever raylib initializing here ...

while not windowShouldClose():
   panel(getScreenWidth().float32 - sideWidth, 0, sideWidth, getScreenHeight().float32) # resizes with the window
   window(200, 250, 600, 300, "Test window")
   button(10, 10,  180, 30, "Test button") # location relative to parent
   
   updateGui() # performs all the GUI logic
   
   if not uiInUse:
     # ... your actual program goes here ...
   
   beginDrawing()
   beginMode2D camera
   endMode2D() # end whatever mode you started
   
   drawGui() # draws the GUI on the screen
   
closeWindow()
   
```
