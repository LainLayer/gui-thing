import raylib
import rectangles
import types
import graphics
import tables
import algorithm
# import std/options

type Drag = enum
    fromOutside, fromInside, notDragging

var
    bgTex: Texture
    font: Font
    stack*: seq[Element] = @[]
    topParent: int
    mem*: Table[string, Element] = initTable[string, Element]()
    uiInUse*: bool = false
    dragging*: bool = false
    drag*: Drag = notDragging
    spawnCounter: int = 1
    


proc zMinMax(): tuple[min, max: int] =
    result = (min: high(int), max: low(int))
    for title, w in mem:
        if w.z > result.max:
            result.max = w.z
        if w.z < result.min:
            result.min = w.z

proc panel*(x,y,w,h: float32) =
    var p = Panel(x,y,w,h)
    p.z = 0
    stack.add p
    topParent = stack.len - 1
    

proc buttonCore*(x,y,w,h: float32; text: string; cb: proc()) =
    var b = Button(x,y,w,h, text)

    if topParent == -1: return
    
    var par = stack[topParent]
    if par.kind == Window:
        par = mem[stack[topParent].text]

    b.x += stack[topParent].x
    b.z  = stack[topParent].z
    if stack[topParent].kind == Window:
        b.y += stack[topParent].y + handleSize
    else:
        b.y += stack[topParent].y

    stack.add b        

template button*(x,y,w,h: float32; text: string; body: untyped): untyped =
    buttonCore(x,y,w,h,text, proc() = body)

proc remember(w: var Element) =
    if mem.hasKey(w.text):
        w = mem[w.text]
    else:
        w.z = spawnCounter
        inc spawnCounter
        mem[w.text] = w


proc window*(x,y,w,h: float32; title: string) =
    var w = Window(x,y,w,h, title)
    w.remember()
    stack.add w
    topParent = stack.len - 1
    

proc draw(e: Element) =        
    case e.kind:
    of Button:
        drawButton(e, bgTex, font)
    of Window:
        drawWindow(e, bgTex, font)
    else:
        let r = e.getRectangle()
        drawBackground(r, bgTex)
        drawShading(r)

    
iterator windows(): Element =
    for s in stack:
        if s.kind == Window:
            yield s

iterator zchildren(e: Element): int =
    for idx, s in stack:
        if s.z == e.z:
            case s.kind:
            of Window, Panel: discard
            else: yield idx

proc handleFocus() =
    for w in windows():
        let r = w.getRectangle()
        if r.underMouse():
            let zs = zMinMax()
            for i in mem[w.text].zchildren():
                stack[i].z = zs.max + 1
            mem[w.text].z = zs.max + 1
            for k,v in mem:
                for i in mem[k].zchildren():
                    stack[i].z -= zs.min - 1
                mem[k].z -= zs.min - 1
            stack.sort(compareByZ, Ascending)
            break 


proc handleDragging() =
    stack.sort(compareByZ, Descending)
    for w in windows():
        var r = w.getRectangle()
        r.height = handleSize
        if r.underMouse() or dragging:
            dragging  = true
            let delta = getMouseDelta()
            mem[w.text].x += delta.x
            mem[w.text].y += delta.y
            for i in mem[w.text].zchildren():
                stack[i].x += delta.x
                stack[i].y += delta.y
        stack.sort(compareByZ, Ascending)
        break


proc checkDragSource() =
    for e in stack:
        let r = e.getRectangle()
        if r.underMouse():
            drag = fromInside
            break
        drag = fromOutside

proc updateGui*() =

    if isMouseButtonUp(MouseButtonLeft):
        uiInUse = false
        dragging = false
        drag = notDragging

    
    if isMouseButtonPressed(MouseButtonLeft):
        if drag != fromOutside:
            stack.sort(compareByZ, Descending)
            handleFocus()

    if isMouseButtonDown(MouseButtonLeft):
        if drag == notDragging or dragging:
            handleDragging() 
        if drag == notDragging:
            checkDragSource()

    if drag == fromInside:
        uiInUse = true

    stack.sort(compareByZ, Ascending)



proc drawGui*() =     
    for e in stack:
        e.draw()

    stack.setLen(0)
    topParent = -1
    

proc initGui*() =
    bgTex = loadTexture("assets/obsidian.png")
    font  = loadFont("assets/Iosevka Bold Nerd Font Complete Mono.ttf")
