--[[
    
    This script checks for an external ip change
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
utils_time = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils_time.lua')()

commandArray = {}

local handle = io.popen('/usr/bin/curl kvanhoorn.nl/myip/index.php')
local result = handle:read()
handle:close()

if (ds['External IP'] ~= result) then
    
    print('ip change, now ' .. result .. ' was ' .. ds['External IP'])
    commandArray['UpdateDevice'] = '234|0|' .. result
    commandArray['SendNotification'] = 'IPChange#now ' .. result .. ' was ' .. ds['External IP']
    
end


return commandArray
