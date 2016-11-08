--[[

    This script sends a notification about an open window or door
    when the outside temperature is higher than the inside temperature
    
    format: idx:val,idx:val

]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

commandArray = {}

-- get current amount of open windows
local windows_opened = tonumber(u['WindowsOpened'])
local windows_opened_back = windows_opened

-- all windows and doors
windows = {
	'Deur woonkamer',
	'Deur keuken',
	'Voordeur',
	'Schuurdeur',
	'Raam slaapkamer',
	'Raam studeerkamer',
	'Raam zolder',
	'Raam logeerkamer',
	'Garage Door'
}
-- Ehv and living room temperature
Ehv = tonumber(ds['Eindhoven']:split(';')[1])
Wk = tonumber(ds['Woonkamer']:split(';')[1])

-- Walk trough windows to add and subtract and send notifications
for i,_window in ipairs(windows) do
    
    -- if one is opened, add
    if c[_window] == 'On' then
        windows_opened = windows_opened + 1
    end
    
    -- if one is closed, subtract
    if c[_window] == 'Off' then
        windows_opened = windows_opened - 1
        -- if window is closed after warning, say thanks
        if u['WindowTempWarning'] == 1 then
            commandArray[i] = {['SendNotification'] = 'Temp Warning#Bedankt voor het sluiten van ' .. _window .. '.'}
        end
    end
    
    if d[_window] == 'On' then
        -- if window is open and temperature hotter than inside, send that this window/door is open
        if Ehv > Wk and u['WindowTempWarning'] == 0 then
            commandArray[i] = {['SendNotification'] = 'Temp Warning#' .. _window .. ' is open en de buitentemperatuur is warmer dan binnen.'}
            -- set warning status to true
            commandArray['Variable:WindowTempWarning'] = tostring(1)
        end
    end
    
    -- if temperature outside is colder than inside, reset warning
    if Ehv <= Wk and u['WindowTempWarning'] == 1 then
        commandArray['Variable:WindowTempWarning'] = tostring(0)
    end
    
end

-- check if the amount value is changed
if (windows_opened ~= windows_opened_back) then
    -- sanity checks
    if windows_opened < 0 then windows_opened = 0 end
    if windows_opened > #windows then windows_opened = #windows end
    -- update var
    commandArray['Variable:WindowsOpened'] = tostring(windows_opened)
    
    -- if all windows are closed, also reset warning
    if windows_opened == 0 and u['WindowTempWarning'] == 1 then
        commandArray['Variable:WindowTempWarning'] = tostring(0)
    end
end

return commandArray