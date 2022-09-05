import raylib, math, sugar, sequtils, strformat, zero_functional, strutils, rayformulation, rayformulation, rayformulation, rayformulation

const
    screenWidth = 1920
    screenHeight = 1080
    screenCenter = vec(screenWidth / 2, screenHeight / 2)
    screenRect = vec(screenWidth, screenHeight)

InitWindow screenWidth, screenHeight, "John Nash's Hex"
InitAudioDevice()
SetMasterVolume 1
SetTargetFPS 60

var cam : Cam3

let tri = [vec(screenWidth, screenHeight, 2), vec(0, 0, 2), vec(screenWidth, 0, 4)]

while not WindowShouldClose():
    ClearBackground BLACK 
    BeginDrawing()
    drawTri3 tri, WHITE
    EndDrawing()
