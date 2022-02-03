# weather-loader
A script made in AutoHotkey designed to load the data retrieved by my [weather-archiver](https://github.com/Clean-Hands/weather-archiver).

![Screenshot of software](https://imgur.com/glTL32U.png)

## Usage
Place the `Weather Dumps` folder (from [this](https://github.com/Clean-Hands/weather-archiver)) in the same directory as the `weather loader.ahk` file, and run said file. The application will recurse through all folders below `Weather Dumps` and retreive the `.json` and `.png` files within. It will then load the files in the order they were created. Both `utils.ahk` and `JSON.ahk` are required to be in the same directory as `weather loader.ahk` for the script to function properly.

## Credits
Thanks to [cocobelgica](https://github.com/cocobelgica) for the JSON.ahk module.
