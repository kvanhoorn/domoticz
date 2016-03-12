--[[
    
    This script sends a notification about an open window in the bedroom
    When the outside temperature is higher than the inside temperature, the bedroom will warm up
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

commandArray = {}

-- get temperatures
Sk = ds['Slaapkamer']:split(';')
Ehv = ds['Eindhoven']:split(';')

-- window is open and temperature is hotter than inside, warning not yet sent
if c['Raam slaapkamer'] == "On" and u['Raam_slaapkamer_triggered'] == 0 and tonumber(Ehv[1]) + 20.0 > tonumber(Sk[1]) then
    commandArray[0] = {['SendNotification'] = 'Temp Warning#Raam slaapkamer is open en de buitentemperatuur is warm.'}
    -- set triggered to true
    commandArray['Variable:Raam_slaapkamer_triggered'] = '1'
end

if u['Raam_slaapkamer_triggered'] == 1 then

    -- if window is closed of temperature is lowered
    if c['Raam slaapkamer'] == "Off" or tonumber(Ehv[1]) < tonumber(Sk[1]) then

        -- set warning to false
        commandArray['Variable:Raam_slaapkamer_triggered'] = '0'

        -- if warning reset is by closing windows send thanks
        if c['Raam slaapkamer'] == "Off" then

            commandArray[1] = {['SendNotification'] = 'Temp Warning#Bedankt voor het sluiten van het raam.'}

        end

    end

end


return commandArray