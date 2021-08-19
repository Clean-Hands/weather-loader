#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include, JSON.ahk

; setup ui
Gui, Color, Aqua
Gui, Font, q5
Gui, Font, s15 Bold Underline
Gui, Add, Text, x10 y5 +Center, Weather For:
Gui, Font, s12 Norm
Gui, Add, Edit, x145 y6 w175 +ReadOnly +Left vWeatherDate, %WeatherDate%
Gui, Add, Edit, x10 y40 w50 +ReadOnly +Center vWeatherF, %WeatherF%
Gui, Add, Edit, x70 y40 w50 +ReadOnly +Center vWeatherC, %WeatherC%
Gui, Add, Edit, x130 y40 w130 +ReadOnly +Center vWeatherCondition, %WeatherCondition%
Gui, Add, Button, x10 y80 gPrevious, Previous
Gui, Add, Button, x270 y80 gNext, Next

; initialize objects
JSONFiles := object()
WeatherArray := object()
DayArray := object()

; sorts .json files by date created to have them load in correct order
Loop, Files, .\Weather Dumps\*.json, R
    FileList = %FileList%%A_LoopFileTimeCreated%-%A_LoopFileLongPath%`n
Sort, FileList, N
Loop, Parse, FileList, `n
{
    SubStrStartingPos := InStr(A_LoopField, "-", false)
    SortedFile := SubStr(A_LoopField, SubStrStartingPos + 1)
    if (SortedFile){
		FileRead, CurrentFile, %SortedFile%
		JSONFiles.Push(CurrentFile)
    }
}
; ^ credit: https://autohotkey.com/board/topic/93779-how-to-sort-folders-by-create-date/

; load the .json file information into arrays, one for each day
for index, element in JSONFiles{
    weather := JSON.Load(element)
	day := "day" . index
	%day% := new WeatherArray
	%day%["lat"] := weather.lat
	%day%["lon"] := weather.lon
	%day%["F"] := weather.F
	%day%["C"] := weather.C
	%day%["Condition"] := weather.Condition
	%day%["Humidity"] := weather.Humidity
	%day%["Barometer"] := weather.Barometer
	%day%["Dewpoint"] := weather.Dewpoint
	%day%["Visibility"] := weather.Visibility
	%day%["Heat_Index"] := weather.Heat_Index
	%day%["Last_update"] := weather.Last_update
	DayArray.Push(day)
}

; setup first page
page := 1
day := "day" . page
WeatherDate := %day%["Last_update"]
GuiControl,, WeatherDate, %WeatherDate%
WeatherF := %day%["F"]
GuiControl,, WeatherF, %WeatherF%
WeatherC := %day%["C"]
GuiControl,, WeatherC, %WeatherC%
WeatherCondition := %day%["Condition"]
GuiControl,, WeatherCondition, %WeatherCondition%

GuiControl, Disable, Previous

Gui, Submit, NoHide
Gui, Show, w330, Weather Loader v0.1
Return

; previous button
Previous:
	page--
	if (page < 2)
		GuiControl, Disable, Previous
	else
		GuiControl, Enable, Next
	
	day := "day" . page
	WeatherDate := %day%["Last_update"]
	GuiControl,, WeatherDate, %WeatherDate%
	WeatherF := %day%["F"]
	GuiControl,, WeatherF, %WeatherF%
	WeatherC := %day%["C"]
	GuiControl,, WeatherC, %WeatherC%
	WeatherCondition := %day%["Condition"]
	GuiControl,, WeatherCondition, %WeatherCondition%
	Return

; next button
Next:
	page++
	if (page >= DayArray.Length())
		GuiControl, Disable, Next
	else
		GuiControl, Enable, Previous

	day := "day" . page
	WeatherDate := %day%["Last_update"]
	GuiControl,, WeatherDate, %WeatherDate%
	WeatherF := %day%["F"]
	GuiControl,, WeatherF, %WeatherF%
	WeatherC := %day%["C"]
	GuiControl,, WeatherC, %WeatherC%
	WeatherCondition := %day%["Condition"]
	GuiControl,, WeatherCondition, %WeatherCondition%
	Return


; save and reload
!s::
Loop{
	Send ^s
	Reload
	Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	MsgBox, 262196, Error, The script could not be reloaded. Would you like to try again?
	IfMsgBox, No
	Exit
}