#SingleInstance, Force
#Persistent
SetWorkingDir, %A_ScriptDir%
CoordMode,Mouse,screen
CoordMode, ToolTip

; Set the URL of your Pastebin raw link
pastebinURL := ""

;Set the UUID for your machine to bypass authentication
machineUUID := ""

; Fetch the key list from Pastebin
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
http.Open("GET", pastebinURL)
http.Send()

; Check if the request was successful
if (http.Status = 200)
{
    keyList := http.ResponseText
    keyArray := StrSplit(keyList, "`n") ; Split the key list into an array
}
If (machineUUID = UUID())
{
	MsgBox Welcome, Admin.
}
else
{
    ; Prompt the user for a key
    InputBox, enteredKey, Enter Key, Please enter your key: , , 300, 125

    ; Check if the entered key is empty
    if (enteredKey = "")
    {
        MsgBox, Failed to authenticate.
        ExitApp
    }
    ; Check if the entered key is valid
    else if (IsKeyValid(enteredKey, keyArray))
    {
        MsgBox, You have logged in successfully.
	}
    else
    {
        MsgBox, Invalid key
        ExitApp
    }
}

IsKeyValid(key, keyArray)
{
    for index, value in keyArray
    {
        if (StrReplace(value, "`r", "") = key)
            return true
    }
    return false
}


;Settings Reads
IniRead,ReadRunTimes,settings.ini,MainStatistics,FledTimes
IniRead,ReadHATimes,settings.ini,MainStatistics,HATimes
IniRead,ReadShinyTimes,settings.ini,MainStatistics,ShinyTimes
IniRead,ReadGamePath,settings.ini,GamePath,Path

TimeCounter = 0
RunCounter = %ReadRunTimes%
HACounter = %ReadHATimes%
ShinyCounter = %ReadShinyTimes%

Gui, 2:Add,Button, x35 y25 w150 h20 gStart, Start
Gui, 2:Add,CheckBox, x150 y70 cAqua Checked vShinyCheck1 gShinyCheck, Shiny
Gui, 2:Add,CheckBox, x150 y90 cLime vHiddenAbillityCheck1 gHiddenAbillityCheck, HA
Gui, 2:Add, Button, x150 y125 w60 h40 gOpenGame , Open PokeOne
Gui, 2:Add,Text, x15 y70 w100 cWhite vReadRunTimes gRun_Counter, Times Fled: %ReadRunTimes%
Gui, 2:Add,Text, x15 y90 w100 cWhite vReadHATimes gHA_Counter, HA Found: %ReadHATimes%
Gui, 2:Add,Text, x15 y110 w100 cWhite vReadShinyTimes gShiny_Counter, Shinies Found: %ReadShinyTimes%
Gui, 2:Add, Text, x10 y150 w100 cYellow vCounter, Time Elapsed: %TimeCounter%
Gui, 2:Color, Black
Gui, 2: Submit, NoHide
Gui, 2: +AlwaysOnTop

Gui, 2:Show, x1300 y180, Benoon Bot
return

; Define the function to update the counter
UpdateCounter:
TimeCounter++
GuiControl, 2:, Counter, Time Elapsed: %TimeCounter%
return

OpenGame:
IfWinNotExist, ahk_exe PokeOne.exe
{
	Run,%ReadGamePath%
}                                                           ;Open the game BTN
IfWinExist, ahk_exe PokeOne.exe
{
	MsgBox, Already Running
}
return

Shiny_Counter:
Gui,Submit,NoHide
ShinyCounter++
IniWrite,%ShinyCounter%,settings.ini,MainStatistics,ShinyTimes
IniRead,ReadShinyTimes,settings.ini,MainStatistics,ShinyTimes
GuiControl,,ReadShinyTimes, Shinies Found: %ReadShinyTimes%
return

HA_Counter:
Gui,Submit,NoHide
HACounter++
IniWrite,%HACounter%,settings.ini,MainStatistics,HATimes
IniRead,ReadHATimes,settings.ini,MainStatistics,HATimes
GuiControl,,ReadHATimes, HA Found: %ReadHATimes%
return

Run_Counter:
Gui,Submit,NoHide
RunCounter++
IniWrite,%RunCounter%,settings.ini,MainStatistics,FledTimes
IniRead,ReadRunTimes,settings.ini,MainStatistics,FledTimes
GuiControl,,ReadRunTimes, Times Fled: %ReadRunTimes%
return

ShinyCheck:
Gui,Submit, NoHide
if(ShinyCheck1==1)
{
    ImageSearch, Loc_XShiny1, Loc_YShiny1, 0,0, A_ScreenWidth, A_ScreenHeight, shiny.png
	if(ErrorLevel==0)
	{
		ShinyWasNotFound=0 ;Found
		return
    }
	else if(ErrorLevel==1)
	{
		ShinyWasNotFound=1 ;WasntFound
		return
	}
}

HiddenAbillityCheck:
Gui,Submit, NoHide
if(HiddenAbillityCheck1==1)
{
	ImageSearch, Loc_XHiddenAbillity, Loc_YHiddenAbillity, 0,0, A_ScreenWidth, A_ScreenHeight, hiddenabillity.png
	if (ErrorLevel==0)
	{
		HiddenAbillityWasNotFound=0
		return
	}
	else if(ErrorLevel==1)
	{
		HiddenAbillityWasNotFound=1
		return
	}
}

Start:
SetTimer, UpdateCounter, 1000
Stop = 0
while(Stop == 0)
{
	ImageSearch, Loc_X, Loc_Y, 0,0, A_ScreenWidth, A_ScreenHeight, try.png
	if(ErrorLevel=2)
	{
		MsgBox,ErrorLevel = 2`Something is wrong, place all the files in a folder on desktop.
		return
	}
	else if(ErrorLevel=1)
	{
		ImageSearch, Loc_XRun, Loc_YRun, 0, 0, A_ScreenWidth, A_ScreenHeight, run.png
		if(ErrorLevel=0)
		{
			ImageSearch, Loc_XHA, Loc_YHA, 0, 0, A_ScreenWidth, A_ScreenHeight, hiddenabillity.png
			if(ErrorLevel=0 && HiddenAbillityCheck1==1)
			{
				gosub, HA_Counter
				SoundPlay, shiny.mp3
				SetTimer, UpdateCounter, Off
				MsgBox, Found HA!
				return
			}

			ImageSearch, Loc_XShiny, Loc_YShiny, 0 , 0, A_ScreenWidth, A_ScreenHeight, shiny.png
			if(ErrorLevel=0)
			{
				gosub, Shiny_Counter
				SoundPlay, shiny.mp3
				SetTimer, UpdateCounter, Off
				MsgBox, Found Shiny!
				return
			}
			else if(ErrorLevel=1)
			{
				;found run but not shiny
				Random,CursorRunDecidor,0,2
				Random,RandomValue,5,30

				if(CursorRunDecidor == 1)
				{
					SendMouse_AbsoluteMove(Loc_XRun + RandomValue, Loc_YRun + RandomValue)
					SendMouse_LeftClick()
					gosub, Run_Counter
				}
				else if(CursorRunDecidor == 2)
				{
					SendMouse_AbsoluteMove(Loc_XRun + RandomValue, Loc_YRun + RandomValue)
					SendMouse_LeftClick()
					gosub, Run_Counter
				}
			}
		}
		else if(ErrorLevel=1)
		{
			Sleep, 666
			Random, RandomMouseDecidor,0,2
			Random, RandomOfRandomMouseDecidor,0,2
			Random, RandomMouseX1,300,1050
			Random, RandomMouseY1,300,1050
			Random, RandomMouseX2,250,1600
			Random, RandomMouseY2,250,1000
			if(RandomMouseDecidor == 1)
			{
				if(RandomOfRandomMouseDecidor == 1)
				{
					SendMouse_AbsoluteMove(RandomMouseX1 , RandomMouseY1)
				}
				else if(RandomOfRandomMouseDecidor == 2)
				{
					SendMouse_AbsoluteMove(RandomMouseX2, RandomMouseY2)
				}
			}
			else if(RandomMouseDecidor == 2)
			{
				if(RandomOfRandomMouseDecidor == 1)
				{
					SendMouse_AbsoluteMove(RandomMouseX2 , RandomMouseY2)
				}
				else if(RandomOfRandomMouseDecidor == 2)
				{
					SendMouse_AbsoluteMove(RandomMouseX1 , RandomMouseY1)
				}
			}
		}
	}
	else if(ErrorLevel=0) ;found try.png
	{
		Random, RandomUpDown, 1,20
		Random, RandomDownUp, 1,20

		Random, RandomLeftWalk, 111,888
		Random, RandomRightWalk, 111,900
		Random, MovementDecidor, 0,2 ;Randoming 1-2 included both
		if (RandomUpDown == 3)
		{
			SendInput {w down}
			Sleep, 202
			SendInput {w up}
			Sleep, 320
			SendInput {s down}
			Sleep, 204
			SendInput {s up}
		}
		else if (RandomDownUp == 3)
		{
			SendInput {s down}
			Sleep, 202
			SendInput {s up}
			Sleep, 310
			SendInput {w down}
			Sleep, 204
			SendInput {w up}
		}
		if(MovementDecidor==1)
		{
			SendInput {a down}
			Sleep,%RandomLeftWalk%
			SendInput,{a up}
			SendInput {d down}
			Sleep,%RandomRightWalk%
			SendInput,{d up}
		}
		else if(MovementDecidor==2)
		{
			SendInput {d down}
			Sleep,%RandomRightWalk%
			SendInput {d up}
			SendInput {a down}
			Sleep,%RandomLeftWalk%
			SendInput {a up}
		}
	}
}
return


2GuiClose:
ExitApp

z::
ExitApp

x::
SetTimer, UpdateCounter, Off
Stop = 1

; helper funcs ;

UUID()
{
	For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
		return obj.UUID	; http://msdn.microsoft.com/en-us/library/aa394105%28v=vs.85%29.aspx
}

; Use DLL calls to bypass lOOp anticheat systems.
;---------------------------------------------------------------------------
SendMouse_LeftClick() { ; send fast left mouse clicks
;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x02) ; left button down
    DllCall("mouse_event", "UInt", 0x04) ; left button up
}


;---------------------------------------------------------------------------
SendMouse_RightClick() { ; send fast right mouse clicks
;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x08) ; right button down
    DllCall("mouse_event", "UInt", 0x10) ; right button up
}


;---------------------------------------------------------------------------
SendMouse_MiddleClick() { ; send fast middle mouse clicks
;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x20) ; middle button down
    DllCall("mouse_event", "UInt", 0x40) ; middle button up
}


;---------------------------------------------------------------------------
SendMouse_RelativeMove(x, y) { ; send fast relative mouse moves
;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y) ; move
}


;---------------------------------------------------------------------------
SendMouse_AbsoluteMove(x, y) { ; send fast absolute mouse moves
;---------------------------------------------------------------------------
    ; Absolute coords go from 0..65535 so we have to change to pixel coords
    ;-----------------------------------------------------------------------
    static SysX, SysY
    If (SysX = "")
        SysX := 65535//A_ScreenWidth, SysY := 65535//A_ScreenHeight
    DllCall("mouse_event", "UInt", 0x8001, "UInt", x*SysX, "UInt", y*SysY)
}


;---------------------------------------------------------------------------
SendMouse_Wheel(w) { ; send mouse wheel movement, pos=forwards neg=backwards
;---------------------------------------------------------------------------
    DllCall("mouse_event", "UInt", 0x800, "UInt", 0, "UInt", 0, "UInt", w)
}