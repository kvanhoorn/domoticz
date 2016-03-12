--[[
    
    This script checks the humidity of plants in the trigger_devices array
    When the humidity is lower than 50% it sends a first notification
    When the humidity is lower than 30% it sends a second and critical notification
    When the humidity is restored it sends a notification about being healthy
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

-- devices that are a plant
local trigger_devices = {'Yucca - palmboom', 'Peace Lily - witte bloem'}

commandArray = {}

-- no plant device default
local triggerDevice = false

-- search all changed devices
for _c in pairs(c) do
    
    -- search in trigger array
    for i, _t in pairs(trigger_devices) do
       
        -- if crosscheck has one result, start trigger checking
        if _t == _c then
            triggerDevice = true
        end
        
    end
    
end


if triggerDevice then
    
    JSON = (loadfile '/home/pi/domoticz/scripts/lua/utils/json.lua')()
    local plants = JSON:decode(u['planttriggers'])

    for plant, vals in pairs(plants) do
    
        if c[vals['name'] ] ~= nil then
        
            data = ds[vals['name'] ]:split(';')

            -- lower than min, request water
            if tonumber(data[2]) < vals['min'] and vals['trigger'] ~= -1 then
        
                plants[plant]['trigger'] = -1
                commandArray['SendNotification'] = 'Plants#'..vals['name']..' heeft water nodig'
        
            -- lower than min2, demand water
            elseif tonumber(data[2]) < vals['min2'] and vals['trigger'] ~= -2 then
                
                plants[plant]['trigger'] = -2
                commandArray['SendNotification'] = 'Plants#'..vals['name']..' heeft water nodig (critic)'
        
            -- higher than max, request dryness
            elseif tonumber(data[2]) > vals['max'] and vals['trigger'] ~= 1 then
        
                plants[plant]['trigger'] = 1
                commandArray['SendNotification'] = 'Plants#'..vals['name']..' heeft teveel water'
              
            -- normal value, notify
            elseif tonumber(data[2]) >= vals['min'] and tonumber(data[2]) <= vals['max'] and vals['trigger'] ~= 0 then
        
                plants[plant]['trigger'] = 0
                commandArray['SendNotification'] = 'Plants#vochtigheid '..vals['name']..' weer juist.'
        
            end
        
        end
    
    end

    if u['planttriggers'] ~= JSON:encode(plants) then
        commandArray["Variable:planttriggers"] = JSON:encode(plants)
    end
        
end

return commandArray

--[[
    
-- default item values
local default_item = {
    max = 99,
    min = 50,
    min2 = 30,
    name = nil,
    trigger = 0
}

--]]    