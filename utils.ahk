#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Populate(page)
{
    day := "day" . page
    WeatherDate := %day%["Last_update"]
    GuiControl,, WeatherDate, %WeatherDate%
    WeatherF := %day%["F"]
    GuiControl,, WeatherF, %WeatherF%
    WeatherC := %day%["C"]
    GuiControl,, WeatherC, %WeatherC%
    WeatherHumidity := %day%["Humidity"]
    GuiControl,, WeatherHumidity, %WeatherHumidity%
    WeatherBarometer := %day%["Barometer"]
    GuiControl,, WeatherBarometer, %WeatherBarometer%
    WeatherDewpoint := %day%["Dewpoint"]
    GuiControl,, WeatherDewpoint, %WeatherDewpoint%
    WeatherVisibility := %day%["Visibility"]
    GuiControl,, WeatherVisibility, %WeatherVisibility%
    WeatherHeatIndex := %day%["Heat_Index"]
    GuiControl,, WeatherHeatIndex, %WeatherHeatIndex%
    ImageLocation := %day%["image"]
    GuiControl,, ImageLocation, %ImageLocation%
    WeatherCondition := %day%["Condition"]
    GuiControl,, WeatherCondition, %WeatherCondition%
}