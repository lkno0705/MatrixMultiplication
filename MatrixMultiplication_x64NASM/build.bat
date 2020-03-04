@echo off
echo Assembling
nasm -f win64 main.s -o main.obj
nasm -f win64 lib.s -o lib.obj
echo Linking
golink /entry:Start /console kernel32.dll user32.dll main.obj lib.obj