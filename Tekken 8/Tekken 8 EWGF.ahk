#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Initialize a toggle variable to track whether macros are active (default is false)
macroActive := false

ShowTrayTip(StatusText) {
    TrayTip,
    TrayTip, Macro Status, %StatusText%, 3
}

; F5 to toggle macro mode on/off
$f5::
{
    macroActive := !macroActive
    if (macroActive) {
        ShowTrayTip("Macro Mode ON")
    } else {
        ShowTrayTip("Macro Mode OFF")
    }
}
return

; F6 to exit the script
$f6::
ExitApp
return

; Dash back (q)
$q::
{
    if (macroActive) {
        Send {a down}
        Sleep 80
        Send {s down}
        Sleep 30
        Send {s up}
        Sleep 30
        Send {d down}
        Sleep 30
        Send {d up}
        Sleep 80
        Send {a up}
    } else {
        Send {Blind}q
    }
}
return

; Dash front (c)
$c::
{
    if (macroActive) {
        while (GetKeyState("c", "P")) {
            sleep 25
            Send {d down}
            Sleep 35
            Send {d up}
            Sleep 50
            Sendinput {s down}
            Sleep 50
            sendinput {d down}
            Sleep 50
            Sendinput {s up}{d up}
            Sleep 35
            Sendinput {d down}
            sleep 25
            Sendinput {d up}
        }
    } else {
        Send {Blind}c
    }
}
return

; e key macro
$e::
{
    if (macroActive) {
        Send, {D Down}
        Sleep, 50
        Send, {D Up}
        Sleep, 30
        Send {s down}
        Sleep 50
        Send {d down}{i down}
        Sleep, 30
        Send {s up}{d up}{i up}
        Sleep, 480
    } else {
        Send {Blind}e
    }
}
return

; r key macro
$r::
{
    if (macroActive) {
        Send, {D Down}
        Sleep, 50
        Send, {D Up}
        Sleep, 30
        Send {s down}
        Sleep 50
        Send {d down}{u down}
        Sleep, 30
        Send {s up}{d up}{u up}
        Sleep, 480
    } else {
        Send {Blind}r
    }
}
return
