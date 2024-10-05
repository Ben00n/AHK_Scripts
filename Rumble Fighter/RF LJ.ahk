#SingleInstance
#Persistent
CoordMode,Mouse,screen
CoordMode,Pixel,screen
SendMode Input
SetWorkingDir %A_ScriptDir%

Gui, 1: Color, Black
Gui, 1:Font, cwhite
Gui, 1:Add,Text, x4 y3, Currently running
Gui, 1:+AlwaysOnTop
Gui, 1:Show, x1800 y3, RF LJ


Stop:=0
while(Stop==0)
{
if(GetKeyState("CTRL"))
{
	Send, {Space Down}
	Sleep, 14
	Send, {Space Up}
	Sleep, 14
	Send, {Space Down}
	Sleep, 14
	Send, {Space Up}
	Sleep, 14
	Send, {Space Down}
	Sleep, 14
	Send, {Space Up}
}
}

F4::
Stop=1


GuiClose:
ExitApp