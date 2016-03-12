--[[
    
    This script checks the freeze probability the night before at 20:00
    If it's going to freeze, it sends a notification
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
utils_time = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils_time.lua')()

commandArray = {}

local willFreeze = false

local minTemp = ds['MinTomorrow']:split(';')
local maxTemp = ds['MaxTomorrow']:split(';')

-- my calculation of freezing probability
local freezefactor = (tonumber(minTemp[1]) * (tonumber(minTemp[2]) / 10))

if (tonumber(minTemp[1]) < 5.0 and freezefactor < 30.0) then
  willFreeze = true
end

if (dayofweek >= 0 and dayofweek <= 5 and hours == 20 and minutes == 0 and willFreeze) then
  print('freeze expectation')
  print('freezefactor -> '..tostring(freezefactor)..' | temperature -> '..tostring(minTemp[1]))
  commandArray['SendNotification'] = 'Forecast#Vannacht vriest het. Temperatuur: '..tostring(minTemp[1])
end

if (dayofweek >= 1 and dayofweek <= 5 and hours == 7 and minutes == 0) or
	(dayofweek >= 6 and dayofweek <= 0 and hours == 9 and minutes == 0) then

  minTemp = ds['MinToday']:split(';')
  maxTemp = ds['MaxToday']:split(';')
  curTemp = ds['Eindhoven']:split(';')

  commandArray['SendNotification'] = 'Vandaag#Nu '..round(curTemp[1])..' °C | Min '..round(minTemp[1])..' °C | Max '..round(maxTemp[1])..' °C'
  
end

return commandArray
