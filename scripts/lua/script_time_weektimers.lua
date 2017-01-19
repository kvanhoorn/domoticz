--[[
    
    This scripts runs every weekmorning when I have to work.
    It turn devices on and off at specific times
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
utils_time = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils_time.lua')()

commandArray = {}

if d['Weekend'] == "Off" and d['Vakantie'] == "Off" then

    if hours == 6 and minutes == 35 then

        commandArray['Badkamer - Lamp'] = "On"
        commandArray['Badkamer - Radio'] = "On"

    elseif hours == 7 and minutes == 0 then

--        commandArray['Tafel (2x)'] = "On"
        commandArray['Hal - LED bak'] = "On"
        commandArray['Keuken - Radio'] = "On"

    elseif hours == 7 and minutes == 14 then

        commandArray['WK - TV lamp'] = "On"
--        commandArray['Kerstboom'] = "On"
        commandArray['TV Vodafone'] = "On"
        commandArray['Keuken - Radio'] = "Off"

    elseif hours == 7 and minutes == 30 then

        commandArray['Badkamer - Radio'] = "Off"
        commandArray['Badkamer - Lamp'] = "Off"
        commandArray['WK - TV lamp'] = "Off"
        commandArray['AV Control'] = "On"
--        commandArray['Tafel (2x)'] = "Off"
        commandArray['Hal - LED bak'] = "Off"

    end

end

if t['SunsetInMinutes'] < (1 + 30) and t['SunsetInMinutes'] > (30) then
    
    commandArray['Woonkamer - volledig'] = "On"

    if tonumber(d['AantalThuis']) > 0 then
        commandArray['WK - Schemerlamp'] = "On"
    end
    
end

if hours == 23 and minutes == 30 and d['Party'] == "Off" then
    
    commandArray['Woonkamer - volledig'] = "Off"
    
end

return commandArray
