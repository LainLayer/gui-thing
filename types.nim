# import algorithm

type
    ElementKind* = enum
        Panel  = 0,
        Window = 1,
        Button = 2,
        Label  = 3
        
    Element* = ref object
        x*,y*,w*,h*: float32
        text*: string
        z*: int
        case kind*: ElementKind:
        of Window, Panel:
            # children*: seq[Element]
            discard
        of Label:
            relation*: int
        else: discard

{.experimental: "callOperator".}
proc `()`*(e: ElementKind; x,y,w,h: float32; text: string = ""): Element =
    result = Element(kind: e, x: x, y: y, w: w, h: h, text: text)

proc compareByZ*(a,b: Element): int =
    if a.z == b.z:
        return cmp(a.kind.int, b.kind.int)
    return cmp(a.z, b.z)
    
        

import strformat
proc `$`*(e: Element): string =
    fmt"{e.kind}: {e.x},{e.y},{e.h},{e.w}; Z: {e.z}; text: {e.text}"
