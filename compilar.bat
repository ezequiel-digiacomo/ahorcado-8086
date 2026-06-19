@echo off
TASM BEEP60.asm
TLINK /t BEEP60.obj

TASM promain.asm
TASM proylib.asm
TLINK promain.obj + proylib.obj

BEEP60
PROMAIN
