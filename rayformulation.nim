import raylib, math, sugar, sequtils, strformat, zero_functional, strutils, lenientops

type Vec*[N : static int] = array[N, float]


type Cam3* = object
    pos* : Vec[3]
    lookDir* : Vec[3]
    fovX*, fovY* : float # radians

func makevec2(v : Vec[2]) : Vector2 =
    Vector2(x : v[0], y : v[1])

template vec*(args : varargs[SomeNumber]) : untyped =
    var res : Vec[args.len]
    for i, arg in args:
        res[i] = float args[i]
    res

var
    defCam3 = Cam3()
    screenRect = vec(1920, 1080)

func x*(v : Vec) : float = v[0]
func y*(v : Vec) : float = v[1]
func z*(v : Vec) : float = v[2]

func `-`*[N](v, v2 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
      result[i] = v[i] - v2[i]

func `*`*[N](v, v1 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i] * v1[i]

func `*`*[N](s : SomeNumber, v : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = s * v[i]

func `/`*(v : Vec, n : SomeNumber) : Vec =
    for i in 0..<v.len:
        result[i] = v[i]/n

func `/`*[N](v, v1 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i] / v1[i]

func xy*(v : Vec) : Vec[2] = vec(v.x, v.y)

proc setDefCam3*(c : Cam3) =
    defCam3 = c

func normal*(v : Vec[3], c : Cam3 = defCam3) : Vec[2] =
    let d = abs(c.pos.z - v.z)
    let rect = d*vec(tan(c.fovX/2), tan(c.fovY/2))
    return v.xy/rect

proc drawTri3*(verts : varargs[Vec[3]], col : Color) =
    var norms : array[3, Vector2]
    for i in 0..<verts.len:
        norms[i] = makevec2 verts[i].normal*screenRect
    DrawTriangle(norms[0], norms[1], norms[2], col)
