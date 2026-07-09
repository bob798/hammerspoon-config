local hotkey = require "hs.hotkey"
local grid = require "hs.grid"
local window = require "hs.window"
local application = require "hs.application"
local appfinder = require "hs.appfinder"
local fnutils = require "hs.fnutils"
local osascript = require "hs.osascript"

grid.setMargins({0, 0})

-- 取 Finder 最前窗口的路径；没有窗口或失败返回 nil
local function getFinderPath()
    local script = [[
        tell application "Finder"
            try
                set theFolder to (folder of front Finder window) as alias
                return POSIX path of theFolder
            on error
                try
                    set theFolder to (insertion location) as alias
                    return POSIX path of theFolder
                on error
                    return ""
                end try
            end try
        end tell
    ]]
    local ok, path = osascript.applescript(script)
    if ok and type(path) == "string" and path ~= "" then
        return path
    end
    return nil
end

-- 用指定 App 打开 Finder 当前目录；拿不到路径就只启动 App
local function openAtFinder(appName)
    local path = getFinderPath()
    if path then
        hs.task.new("/usr/bin/open", nil, {"-a", appName, path}):start()
    else
        application.launchOrFocus(appName)
    end
end

applist = {

    {shortcut = 'A', appname = 'Activity Monitor'},
    {shortcut = 'C', appname = 'calendar'},
    {shortcut = 'D', appname = 'DataGrip'},
    {shortcut = 'E', appname = 'Telegram'},
    {shortcut = 'F', appname = 'Finder'},
    {shortcut = 'L', appname = 'Lark'},
    {shortcut = 'G', appname = 'Google Chrome'},
    {shortcut = 'I', appname = 'IntelliJ IDEA'},
    {shortcut = 'P', appname = 'Clash Verge'},
    {shortcut = 'W', appname = 'WeChat'},
    {shortcut = 'V', appname = 'Visual Studio Code', action = function() openAtFinder('Visual Studio Code') end},
    {shortcut = 'M', appname = 'MWeb Pro'},
    {shortcut = 'O', appname = 'Obsidian'},
    -- {shortcut = 'M',appname = 'WebStorm'},
    {shortcut = 'T', appname = 'Ghostty', action = function() openAtFinder('Ghostty') end},
    {shortcut = 'S', appname = 'System Preferences'},
    {shortcut = 'Y', appname = 'Typora'},
    {shortcut = 'Z', appname = 'Calculator'},
}

fnutils.each(applist, function(entry)
    hotkey.bind({'ctrl', 'shift'}, entry.shortcut, entry.appname, function()
        if entry.action then
            entry.action()
        else
            application.launchOrFocus(entry.appname)
        end
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
