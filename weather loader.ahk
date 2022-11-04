#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Include, JSON.ahk
#Include, utils.ahk

; setup ui
Gui, Color, Aqua
Gui, Font, q5
Gui, Font, s15 Bold Underline
Gui, Add, Text, x10 y5 +Center, Weather For:
Gui, Font, s12 Norm
Gui, Add, Edit, x145 y5 w181 +ReadOnly +Left vWeatherDate, %WeatherDate%
Gui, Add, Picture, x194 y117 w130 h130 vImageLocation, %ImageLocation%
Gui, Font, s20
Gui, Add, Edit, x10 y41 w80 h39 +ReadOnly +Center vWeatherF, %WeatherF%
Gui, Font, s11
Gui, Add, Edit, x95 y55 w43 +ReadOnly +Center vWeatherC, %WeatherC%
Gui, Add, Edit, x194 y55 w131 r3 +ReadOnly +Center +Wrap -VScroll vWeatherCondition, %WeatherCondition%
Gui, Add, Text, x0 y95 w85 +Right, Humidity:
Gui, Add, Text, x0 y117 w85 +Right, Barometer:
Gui, Add, Text, x0 y139 w85 +Right, Dewpoint:
Gui, Add, Text, x0 y161 w85 +Right, Visibility:
Gui, Add, Text, x0 y183 w85 +Right, Wind Speed:
Gui, Add, Text, x0 y205 w85 +Right, Wind Chill:
Gui, Add, Text, x0 y227 w85 +Right, Heat Index:
Gui, Font, s9
Gui, Add, Edit, x88 y94 w105 +ReadOnly +Left vWeatherHumidity, %WeatherHumidity%
Gui, Add, Edit, x88 y116 w105 +ReadOnly +Left vWeatherBarometer, %WeatherBarometer%
Gui, Add, Edit, x88 y138 w105 +ReadOnly +Left vWeatherDewpoint, %WeatherDewpoint%
Gui, Add, Edit, x88 y160 w105 +ReadOnly +Left vWeatherVisibility, %WeatherVisibility%
Gui, Add, Edit, x88 y182 w105 +ReadOnly +Left vWeatherWindSpeed, %WeatherWindSpeed%
Gui, Add, Edit, x88 y204 w105 +ReadOnly +Left vWeatherWindChill, %WeatherWindChill%
Gui, Add, Edit, x88 y226 w105 +ReadOnly +Left vWeatherHeatIndex, %WeatherHeatIndex%
Gui, Font, s12
Gui, Add, Button, x10 y260 gPrevious, Previous
Gui, Add, Button, x89 y260 gFirst, First
Gui, Add, Button, x231 y260 gLast, Last
Gui, Add, Button, x279 y260 gNext, Next
DisableAll()
Gui, Show, w335, Weather Loader v1.3
GuiControl,, WeatherDate, Loading...
Gui, Submit, NoHide

; initialize objects
JSONFiles := object()
PNGFiles := object()
WeatherArray := object()

; sort .json files by date created to have them load in correct order
numOfFiles := 0
currentFileNum := 0
Loop, Files, .\Weather Dumps\*.json, R
{	
	numOfFiles++
	GuiControl,, WeatherDate, Locating file %numOfFiles%
    FileList = %FileList%%A_LoopFileTimeCreated%-%A_LoopFileLongPath%`n
}
Sort, FileList, N
Loop, Parse, FileList, `n
{
    SubStrStartingPos := InStr(A_LoopField, "-", false)
    SortedFile := SubStr(A_LoopField, SubStrStartingPos + 1)
    if (SortedFile){
		currentFileNum++
		GuiControl,, WeatherDate, Loading file %currentFileNum%/%numOfFiles%
		FileRead, CurrentFile, %SortedFile%
		JSONFiles.Push(CurrentFile)
    }
}
; ^ credit: https://autohotkey.com/board/topic/93779-how-to-sort-folders-by-create-date/?p=590877
FileList := ""

; load the .json file information into arrays, one for each day
for index, element in JSONFiles{
	numOfFiles := JSONFiles.Length()
	GuiControl,, WeatherDate, Inputting file %index%/%numOfFiles%
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
	%day%["Wind_Speed"] := weather.Wind_Speed
	%day%["Wind_Chill"] := weather.Wind_Chill
	%day%["Heat_Index"] := weather.Heat_Index
	%day%["Last_update"] := weather.Last_update
}

; sort .png files by date created to have them load in correct order
numOfFiles := 0
currentFileNum := 0
Loop, Files, .\Weather Dumps\*.png, R
{
	numOfFiles++
	GuiControl,, WeatherDate, Locating image %numOfFiles%
    FileList = %FileList%%A_LoopFileTimeCreated%-%A_LoopFileLongPath%`n
}
Sort, FileList, N
Loop, Parse, FileList, `n
{
    SubStrStartingPos := InStr(A_LoopField, "-", false)
    SortedFile := SubStr(A_LoopField, SubStrStartingPos + 1)
    if (SortedFile){
		currentFileNum++
		GuiControl,, WeatherDate, Loading image %currentFileNum%/%numOfFiles%
		PNGFiles.Push(SortedFile)
    }
}
; ^ credit: https://autohotkey.com/board/topic/93779-how-to-sort-folders-by-create-date/?p=590877
FileList := ""

; load the .png file information into arrays, one for each day
for index, element in PNGFiles{
	GuiControl,, WeatherDate, Inputting image %index%/%numOfFiles%
	day := "day" . index
	%day%["image"] := element
}

; setup first page
page := 1
Populate(page)
EnableAll()
GuiControl, Disable, Previous
GuiControl, Disable, First
Gui, Submit, NoHide
Return

; previous button
Previous:
	page--
	if (page < 2) {
		GuiControl, Disable, Previous
		GuiControl, Disable, First
	} else {
		GuiControl, Enable, Next
		GuiControl, Enable, Last
	}
	Populate(page)
	Return

; first button
First:
	page := 1
	GuiControl, Disable, First
	GuiControl, Disable, Previous
	GuiControl, Enable, Next
	GuiControl, Enable, Last
	Populate(page)
	Return

; last button
Last:
	page := JSONFiles.Length()
	GuiControl, Disable, Last
	GuiControl, Disable, Next
	GuiControl, Enable, Previous
	GuiControl, Enable, First
	Populate(page)
	Return

; next button
Next:
	page++
	if (page >= JSONFiles.Length()) {
		GuiControl, Disable, Next
		GuiControl, Disable, Last
	} else {
		GuiControl, Enable, Previous
		GuiControl, Enable, First
	}
	Populate(page)
	Return

GuiClose:
	ExitApp
	Return