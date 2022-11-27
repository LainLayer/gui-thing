import raylib
import types

proc getTextureRectangle*(r: Rectangle, t: Texture): Rectangle =
    result.x      = float32(t.width ) * (r.x      / getScreenWidth().float32 )
    result.y      = float32(t.height) * (r.y      / getScreenHeight().float32)
    result.width  = float32(t.width ) * (r.width  / getScreenWidth().float32 )
    result.height = float32(t.height) * (r.height / getScreenHeight().float32)

proc getRectangle*(e: Element): Rectangle =
    Rectangle(x: e.x.float32, y: e.y.float32, width: e.w.float32, height: e.h.float32)

proc resize*(r: Rectangle, s: float32): Rectangle =
    result = r
    result.x -= s
    result.y -= s
    result.width  += s*2
    result.height += s*2

proc underMouse*(r: Rectangle): bool =
    let pos = getMousePosition()
    return pos.x >= r.x and
           pos.y >= r.y and
           pos.x <= r.x + r.width and
           pos.y <= r.y + r.height
           
