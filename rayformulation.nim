import raylib, math, sugar, sequtils, strformat, zero_functional, strutils, lenientops

type Vec*[N : static int] = array[N, float]

type Cam3* = object
    pos* : Vec[3]
    fovX*, fovY* : float # radians
    pitch*, yaw*, roll* : float # also radians
    senSize* : Vec[2]
    focLen* : float
    zNear*, zFar* : float

type Mat[N,M : static int] = array[N * M, float] # N rows by M columns

func `[]`[N, M](m : Mat[N, M], i, j : SomeInteger) : float = m[i * N + j]

func `*`[N, M, I](m : Mat[N, M], m1 : Mat[M, I]) : Mat[N, I] =
    for i in 0..<N:
        for j in 0..<M:
            result[i, j] += m[i, j] * m[j, i]

func `*`[N, M](m : Mat[N, M], v : Vec[M]) : Vec[M] =
    for i in 0..<N:
        for j in 0..<M:
          result[i] += m[i, j] * v[j]

func makevec2(v : Vec[2]) : Vector2 =
    Vector2(x : v[0], y : v[1])

template vec*(args : varargs[SomeNumber]) : untyped =
    var res : Vec[args.len]
    for i, arg in args:
        res[i] = float args[i]
    res

const
    screenRect = vec(1920, 1080)
    aspectRatio = 16/9

var
    defCam3 = Cam3()

func x*(v : Vec) : float = v[0]
func y*(v : Vec) : float = v[1]
func z*(v : Vec) : float = v[2]
func w*(v : Vec) : float = v[3]

func `+`*[N](v, v1 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i] + v1[i]

func `-`*[N](v, v2 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i] - v2[i]

func `*`*[N](v, v1 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i] * v1[i]

func `*`*[N](s : SomeNumber, v : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = s * v[i]

func `/`*[N](v : Vec[N], n : SomeNumber) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i]/n

func `/`*[N](v, v1 : Vec[N]) : Vec[N] =
    for i in 0..<v.len:
        result[i] = v[i] / v1[i]

func xy*(v : Vec) : Vec[2] = vec(v.x, v.y)

proc setDefCam3*(c : Cam3) =
    defCam3 = c

func screenNormal*(v : Vec[3], c : Cam3 = defCam3) : Vec[2] =
    let d = v.z - c.pos.z
    let m1 : Mat[4, 4] = [
      1/(aspectRatio * tan(c.fovX/2)), 0, 0, 0,
      0, 1/tan(c.fovX/2), 0, 0,
      0, 0, c.zFar/(c.zFar - c.zNear), -1,
      0, 0, c.zNear * c.zFar/(c.zFar - c.zNear), 0
    ]
    let v1 = m1 * vec(v.x, v.y, v.z, 1.float)
    let ndc = vec(v1.x, v1.y, v1.z)/v1.w
    return ndc.xy/ndc.z * screenRect

proc drawTri3*(verts : varargs[Vec[3]], col : Color) =
    var norms : array[3, Vector2]
    for i in 0..<verts.len:
        norms[i] = makevec2 verts[i].screenNormal*screenRect
    debugEcho norms
    DrawTriangle(norms[0], norms[1], norms[2], col)
