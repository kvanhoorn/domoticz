--[[
    
    This script updates the MinToday, MaxToday, MinTomorrow and MaxTomorrow temperatures
    Used for the temperature dashboard and freezing probability of the coming night
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
utils_time = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils_time.lua')()
forecast_apikey = 'xxxxxxxxxxxxx'
home_lat = '51'
home_lng = '5'


commandArray = {}

local difference = time_difference(dl['MaxTomorrow'])

local function getTemperature(timestamp)
    
	JSON = (loadfile '/home/pi/domoticz/scripts/lua/utils/json.lua')()
    full_url = "https://api.forecast.io/forecast/"..forecast_apikey.."/"..home_lat..","..home_lng..","..timestamp.."?exclude=hourly,currently,flags&units=ca"
    
    local handle = io.popen('/usr/bin/curl "'..full_url..'"')
    local result = handle:read()
    handle:close()

    tempData = JSON:decode(result)
    data = tempData['daily']['data'][1]

    return data

end

if (difference > 2700) then

    print('Temperature out of date, updating...')

    -- start with today
    local today = os.time()
    data = getTemperature(today)
    print('Today updatet')

    minData = data['temperatureMin']..';'..(data['humidity']*100)..';0;'..data['pressure']..';0'
    maxData = data['temperatureMax']..';'..(data['humidity']*100)..';0;'..data['pressure']..';0'

    commandArray[1] = {['UpdateDevice'] = '97|0|'..tostring(minData)}
    commandArray[2] = {['UpdateDevice'] = '98|0|'..tostring(maxData)}

    -- tomorrow
	local tomorrow = os.time() + (60 * 60 * 24)
    data = getTemperature(tomorrow)
    print('Tomorrow updatet')
    
    minData = data['temperatureMin']..';'..(data['humidity']*100)..';0;'..data['pressure']..';0'
    maxData = data['temperatureMax']..';'..(data['humidity']*100)..';0;'..data['pressure']..';0'

    commandArray[3] = {['UpdateDevice'] = '95|0|'..tostring(minData)}
    commandArray[4] = {['UpdateDevice'] = '96|0|'..tostring(maxData)}

end 

return commandArray