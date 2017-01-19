--[[
    
    This script sets weekend and night switches on and off according to specific times
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
utils_time = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils_time.lua')()

commandArray = {}


-- sets and unsets weekend
if dayofweek == 5 and hours == 17 and minutes == 0 then
    commandArray['Weekend'] = "On"
end

if dayofweek == 0 and hours == 17 and minutes == 0 then
    commandArray['Weekend'] = "Off"
end



-- weekendtimes
if d['Weekend'] == "On" or d['Vakantie'] == "On" then

    -- sets nightmode in weekends
    if hours == 23 and minutes == 30 and d['Nacht'] == "Off" then
        
        if d['Party'] == "Off" then
            commandArray['Nacht'] = "On"
        end

    -- unsets nightmode in weekends
    elseif hours == 8 and minutes == 30 and d['Nacht'] == "On" then

        commandArray['Nacht'] = "Off"

    end

end

-- weektimes
if d['Weekend'] == "Off" and d['Vakantie'] == "Off" then

    -- sets nightmode in weekends
    if hours == 22 and minutes == 30 and d['Nacht'] == "Off" then

        if d['Party'] == "Off" then
            commandArray['Nacht'] = "On"
        end

    -- unsets nightmode in weekends
    elseif hours == 6 and minutes == 30 and d['Nacht'] == "On" then

        commandArray['Nacht'] = "Off"

    end

end


return commandArray