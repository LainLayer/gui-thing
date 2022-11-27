import types
import rectangles
import raylib

const
    handleSize*: float32 = 24
    handleColor* = Color(r:  32, g: 200, b: 200, a: 255)

proc drawShading*(r: Rectangle, color: Color = Black) =
    let l = r.resize(-1)
    drawRectangleLinesEx(l, 2.0, Color(r: 255, g: 255, b: 255, a: 32))
    drawRectangleLinesEx(l, 1.0, Color(r: 255, g: 255, b: 255, a: 16))
    drawRectangleLinesEx(r, 1.0, color)

proc drawBackground*(r: Rectangle; t: Texture; color = Raywhite) =
    drawTexturePro(
        t, getTextureRectangle(r, t),
        r, Vector2(x: 0, y: 0), 0.0, color)

proc drawButton*(e: Element; t: Texture; f: Font) =
    var r = e.getRectangle()
    drawBackground(r, t)
    var fsize = e.h.float32
    var tsize = measureTextEx(f ,cstring e.text, fsize, 1.0)
    fsize = min(float32(e.h - 4) * (e.w/e.h), float32(e.h - 4)) * min(e.w.float32/tsize.x, 1.0) * 0.8
    tsize = measureTextEx(f ,cstring e.text, fsize, 1.0)
    drawTextEx(
        f, cstring(e.text),
        Vector2(
            x: e.x.float32 + (e.w / 2) - (tsize.x / 2),
            y: e.y.float32 + (e.h / 2) - (tsize.y / 2)),
        fsize, 1.0, Yellow
    )
    drawShading(r)

proc drawWindow*(e: Element; t: Texture; f: Font) =
    var r = e.getRectangle()
    r.y += 24
    r.height -= 24
    drawBackground(r, t)
    drawShading(r)
    r.y -= 24
    r.height = 24
    drawBackground(r, t, handleColor)
    var fsize = r.height
    var tsize = measureTextEx(f ,cstring e.text, fsize, 1.0)
    fsize = min(float32(r.height - 4) * (r.width/r.height), float32(r.height - 4)) * min(r.width/tsize.x, 1.0) * 0.8
    tsize = measureTextEx(f ,cstring e.text, fsize, 1.0)
    drawTextEx(
        f, cstring(e.text),
        Vector2(
            x: r.x.float32 + 4,
            y: r.y.float32 + (r.height / 2) - (tsize.y / 2)),
        fsize, 1.0, Yellow
    )
    drawShading(r)
