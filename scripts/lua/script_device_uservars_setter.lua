--[[
    
    This script sets and updates usersvars and utils
    It is mainly designed to decide the amount of people at home and status of the away alarm and night alarm
    
]]--
utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

commandArray = {}

-- START SOMEBODY HOME CHECKER
local cur_iemand_thuis = tonumber(ds["AantalThuis"])
local iemand_thuis = cur_iemand_thuis


if c['Kevin iPhone GPS'] == "On" then
    iemand_thuis = iemand_thuis + 1
end

if c['Willemijn iPhone GPS'] == "On" then
    iemand_thuis = iemand_thuis + 1
end

if c['Kevin iPhone GPS'] == "Off" then
    iemand_thuis = iemand_thuis - 1
end

if c['Willemijn iPhone GPS'] == "Off" then
    iemand_thuis = iemand_thuis - 1
end

-- if amount of people home changed
if iemand_thuis ~= cur_iemand_thuis then

    if iemand_thuis < 0 then iemand_thuis = 0 end
    if iemand_thuis > 2 then iemand_thuis = 2 end
    
    -- update home counter
    commandArray['UpdateDevice'] = '111|0|'..tostring(iemand_thuis)

    -- somebody is home, send notification about alarm
    if cur_iemand_thuis == 0 and iemand_thuis > 0 then
        commandArray['IemandThuis'] = 'On'
        commandArray['SendNotification'] = 'Alarm#Alarm uitgeschakeld'
    end

    -- last person left, send notification about alarm
    if cur_iemand_thuis > 0 and iemand_thuis == 0 then
        commandArray['IemandThuis'] = 'Off'
        commandArray['SendNotification'] = 'Alarm#Alarm ingeschakeld'
    end

end

-- when nightmode is changed, send notifications
if c['Nacht'] == "On" then

    commandArray['SendNotification'] = 'Alarm#Nachtalarm ingeschakeld'

elseif c['Nacht'] == "Off" then

    commandArray['SendNotification'] = 'Alarm#Nachtalarm uitgeschakeld'

end

-- when partymode is changed, send notifications
if c['Party'] == "On" then
    
    commandArray['SendNotification'] = 'Party#Partymodus is aan. Lichten, CV-Ketel en nachtalarm wijzigen niet langer automatisch.#0#bugle';
    
elseif c['Party'] == "Off" then
    
    commandArray['SendNotification'] = 'Party#Partymodus is uit. Alles werkt weer volgens normale schema.#0#bugle'
    
end


-- off button living room sets off all other devices such as lights and TV
if c['Woonkamer - volledig'] == "Off" then
    commandArray['WK - Schemerlamp'] = "Off"
    commandArray['WK - Plafond'] = "Off"
    commandArray['Logitech'] = "Set Level: 0"
end


return commandArray
