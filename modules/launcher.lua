local hotkey = require "hs.hotkey"
local grid = require "hs.grid"
local window = require "hs.window"
local application = require "hs.application"
local appfinder = require "hs.appfinder"
local fnutils = require "hs.fnutils"

grid.setMargins({0, 0})

applist = {

    {shortcut = 'A',appname = 'Activity Monitor'},
    {shortcut = 'C',appname = 'calendar'},
    {shortcut = 'D',appname = 'DataGrip'},
    {shortcut = 'E',appname = 'Telegram'},
    {shortcut = 'F',appname = 'Finder'},
    {shortcut = 'L',appname = 'Lark'},
    {shortcut = 'G',appname = 'Google Chrome'},
    {shortcut = 'I',appname = 'IntelliJ IDEA'},
    {shortcut = 'P',appname = 'Paw'},
    {shortcut = 'W',appname = 'WeChat'},
    {shortcut = 'V',appname = 'Visual Studio Code'},
    {shortcut = 'M',appname = 'MWeb Pro'},
    -- {shortcut = 'M',appname = 'WebStorm'},
    {shortcut = 'T',appname = 'iTerm'},
    {shortcut = 'S',appname = 'System Preferences'},
    {shortcut = 'Y',appname = 'Typora'},
    {shortcut = 'Z',appname = 'Calculator'},
}

fnutils.each(applist, function(entry)
    hotkey.bind({'ctrl', 'shift'}, entry.shortcut, entry.appname, function()
        application.launchOrFocus(entry.appname)
        -- toggle_application(applist[i].appname)
    end)
end)

-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app)
    local app = appfinder.appFromName(_app)
    if not app then
        application.launchOrFocus(_app)
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end
