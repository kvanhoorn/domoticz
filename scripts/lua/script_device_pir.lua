--[[
    
    This scripts turns on light in a specific room with a PIR and turns them back off after
    not seeing movement for 3 minutes
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

commandArray = {}
local offMinutes = 3

-- if PIR attic is on and it's night, turn on attic lights
if c['PIR Zolder'] == 'On' and t['Nighttime'] == true then

    if d['Zolder - bank'] == 'Off' or d['Zolder - scherm'] == 'Off' then
        commandArray['Zolder - bank'] = 'On'
        commandArray['Zolder - scherm'] = 'On'
        commandArray['Variable:PIR_Zolder_state'] = '1'
    end
    
end

-- if PIR hall is on ant it's night, turn on hall lights
if c['PIR Hal'] == 'On' and t['Nighttime'] == true then

    if d['Hal - LED bak'] == 'Off' then
        commandArray['Hal - LED bak'] = 'On'
        commandArray['Variable:PIR_Hal_state'] = '1'
    end

end

-- if PIR attic isn't seen for x minutes turn lights back off
local difference = time_difference(dl['PIR Zolder'])
if difference > (offMinutes * 60) and u['PIR_Zolder_state'] == 1 then
    
    commandArray['Zolder - bank'] = 'Off'
    commandArray['Zolder - scherm'] = 'Off'
    commandArray['Variable:PIR_Zolder_state'] = '0'
    
end

-- if PIR hall isn't seen for x minutes, turn lights back off
local difference2 = time_difference(dl['PIR Hal'])
if difference2 > (offMinutes * 60) and u['PIR_Hal_state'] == 1 then
	
	commandArray['Hal - LED bak'] = 'Off'
    commandArray['Variable:PIR_Hal_state'] = '0'
	
end

-- debug
if next(commandArray) ~= nil then
    vardump(commandArray)
end

return commandArray