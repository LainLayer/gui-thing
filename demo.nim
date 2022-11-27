# import nimraylib_now
import raylib
import raymath
import strformat
import std/random
import gui2
import strutils
import tables

import types

initWindow(800, 800, "GUI Demo")

let iosevka = loadFont("assets/Iosevka Bold Nerd Font Complete Mono.ttf")
let fpsTextSize = measureTextEX(iosevka, "FPS: ", 16.0, 1.0)


var camera = Camera2D(
    target: Vector2(x:0.0, y: 0.0),
    offset: Vector2(x: getScreenWidth() / 2, y: getScreenHeight() / 2),
    rotation: 0.0,
    zoom: 1.0,
)

initGui()

let demoBox: tuple[x,y,width,height: float32] =
    (x: -300, y: -300, width: 600, height: 600)

type Ball = object
    x,y: float32
    v: Vector2  

proc newBall(x, y, vx, vy: float32): Ball =
    Ball(x: x, y: y, v: Vector2(x: vx, y: vy))

var balls: seq[Ball] = @[newBall(0, 0, 2.0, 1.0)]

var showColors = false
var coolWindow = false

144.setTargetFPS



while not windowShouldClose():

    let sideWidth = getScreenWidth() / 8
    panel(getScreenWidth().float32 - sideWidth, 0 + 24, sideWidth, getScreenHeight().float32 - 24)

    var btn: float32 = 10
    for i in 0..<3:
        let wd = sideWidth / 4
        button(btn, 10, wd, getScreenHeight() / 32, "Test " & $i):
            echo "test"
        btn += wd + 5
        

    panel(0, 0, getScreenWidth().float32, 24)
    panel(0, getScreenHeight().float32 - 24, getScreenWidth().float32, 24)
    
    if coolWindow:
        window(30, 160, 200, 230, "My cool window")
        button(10, 10, 180, 30, "cool window button"):
            echo "test 2"

    window(200, 250, 600, 300, "Second window")
    button(10, 10,  180, 30, "based button X1"): echo "test 3"
    button(10, 40,  180, 30, "based button X2"): echo "test 3"
    button(10, 70,  180, 30, "based button X3"): echo "test 3"
    button(10, 100, 180, 30, "based button X4"): echo "test 3"
    button(10, 130, 180, 30, "based button X5"): echo "test 3"


    window(400, 230, 300, 200, "Third window")
    button(10, 10, 80, 30, "third button"):
        echo "hello"

    updateGui()

    let mouseWorldPos = getScreenToWorld2D(getMousePosition(), camera)

    if isKeyPressed(KeyQ): break
    if isKeyPressed(KeyD): coolWindow = not coolWindow
    
    if not uiInUse:
    
        if isKeyPressed(KeyC): showColors = not showColors

        # Spawn new ball
        if isMouseButtonPressed(MouseButtonRight):
            for i in 0..99:
                balls.add(newBall(mouseWorldPos.x, mouseWorldPos.y, rand(-4.0..4.0).float32, rand(-4.0..4.0).float32))

        # Enable panning via mouse
        if isMouseButtonDown(MouseButtonLeft):
            var delta = getMouseDelta()
            delta *= float32(-1.0/camera.zoom)
            camera.target += delta
        
        # Enable zooming with mousewheel
        var wheel = getMouseWheelMove()
        if wheel != 0:
            camera.offset       = getMousePosition()
            camera.target       = mouseWorldPos
            const zoomIncrement = 0.125
            camera.zoom        += wheel * zoomIncrement
            if camera.zoom < zoomIncrement: camera.zoom = zoomIncrement

    beginDrawing()
    clearBackground Color(r: 24, g: 24, b: 24, a: 255)
    beginMode2D camera        

    # === Demo program === #
    
    const ballRadius: float32 = 5
    for i in 0..<balls.len():
        balls[i].x += balls[i].v.x * getFrameTime() * 100
        balls[i].y += balls[i].v.y * getFrameTime() * 100
        if balls[i].x >= demoBox.x + demoBox.width  - ballRadius or balls[i].x <= demoBox.x + ballRadius: balls[i].v.x *= -1
        if balls[i].y >= demoBox.y + demoBox.height - ballRadius or balls[i].y <= demoBox.y + ballRadius: balls[i].v.y *= -1
        drawCircle(balls[i].x.int32, balls[i].y.int32, ballRadius, Red)

    
    drawRectangleLines(int32 demoBox.x  ,int32 demoBox.y  , int32 demoBox.width  , int32 demoBox.height  , Red)
    drawRectangleLines(int32 demoBox.x-1,int32 demoBox.y-1, int32 demoBox.width+2, int32 demoBox.height+2, Red)
    drawRectangleLines(int32 demoBox.x-2,int32 demoBox.y-2, int32 demoBox.width+4, int32 demoBox.height+4, Red)
    
    # === Demo program === #

    endMode2D()

    var debugHeight: int32 = 30
    template debug(text: static[string]) =
        drawTextEx(iosevka, cstring(fmt(text)), Vector2(x: 20, y: debugHeight.float32), 16.0, 2.0, White)
        debugHeight += 20
    
    
    debug("number of balls: {balls.len()}")
    debug("UI in use: {uiInUse}")

    
    debug("drag: {drag}")
    debug("dragging: {dragging}")
    
    debug("window memory:")
    for key, val in mem:
        debug(" - {key}: {mem[key]}")
    

    debug("stack:")
    for index, e in stack:
        debug(" [{index}] - {e}")

    proc printColor(color: static[string]) =
        const
            red       = fromHex[uint8](color[0..1])
            green     = fromHex[uint8](color[2..3])
            blue      = fromHex[uint8](color[4..5])
            textColor = Color(r: red, g: green, b: blue, a: 255)
            
        drawTextEx(iosevka, cstring(color.toUpper() & " " & $textColor), Vector2(x: 20, y: debugHeight.float32), 16.0, 2.0, textColor)
        debugHeight += 20

    if showColors:
        printColor "fde8d1"
        printColor "171215"
        printColor "141414"
        printColor "d45113"
        printColor "5b6c5d"
        printColor "edd382"
        printColor "f8dda4"
        printColor "929982"
        printColor "4e937a"
        printColor "fcddbc"
        printColor "626262"
        printColor "f08452"
        printColor "8da090"
        printColor "f3e1ab"
        printColor "fae9c3"
        printColor "b5baaa"
        printColor "82bda7"
        printColor "fde8d1"
    
    
    # === GUI code goes here === #



    drawGui()

    # === GUI code goes here === #

    let bottomTextHeight = getScreenHeight().float32 - 12 - fpsTextSize.y/2
    drawTextEX(iosevka, cstring("FPS: "), Vector2(x: 8, y: bottomTextHeight), 16.0, 1.0, White)
    drawTextEX(iosevka, cstring(fmt"{getFPS()}"), Vector2(x: 8 + fpsTextSize.x, y: bottomTextHeight), 16.0, 1.0, Yellow)

    endDrawing()

closeWindow()
