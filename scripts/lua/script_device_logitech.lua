--[[

    This script changes the Harmony Hub devices from one multi state button
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

commandArray = {}

-- logitech multibutton changed
if c['Logitech'] ~= nil then
    
    local v = c['Logitech']

    -- update logitech harmony devices
    if v == 'Off' then
        commandArray['AV Control'] = 'On'
    elseif v == 'TV' then
        commandArray['TV Vodafone'] = 'On'
    elseif v == 'Plex' then
        commandArray['Plex'] = 'On'
    elseif v == 'Chr.' then
        commandArray['Chromecast'] = 'On'
    elseif v == 'LP' then
    	commandArray['Turntable'] = 'On'
    elseif v == 'Music' then
        commandArray['ATV Music'] = 'On'
    end

end

return commandArray