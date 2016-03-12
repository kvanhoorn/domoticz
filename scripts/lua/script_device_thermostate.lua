--[[
    
    Thermostate script that controls the heater by a temperature sensor
    You can use this when you have a GPIO heater connected
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
utils_time = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils_time.lua')()

commandArray = {}

sensor_age_warning = 1500       -- seconds for first warning about batteries temperature sensor
sensor_age_critical = 2400      -- seconds for second warning about batteries, this script wil ceise to function

thermostate_high = 19.5         -- temperature when home and day
thermostate_low = 17.5          -- temperature when away or asleep
thermostate_idx = '88'          -- idx of thermostate (temperature device)

heater_on_min = 10              -- time heater should be minimum on in minutes
heater_on_max = 45              -- time heater should be maximum on in minutes
heater_reset = 5                -- time of new temperature check in minutes after turning off

ThermTemp = ds['Thermostaat']
WK = ds['Woonkamer']:split(';')
local difference = time_difference(dl['Woonkamer'])


-- thermostate change when day / night changes
if c['Nacht'] ~= nil then

    if c['Nacht'] == "On" then

        commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(thermostate_low)

    elseif c['Nacht'] == "Off" then

        if tonumber(ds['AantalThuis']) > 0 then

            -- if weekly and after 8 or weekend continue with high settings

            if (d['Weekend'] == "Off" and hours >= 8) or (d['Weekend'] == "On") then
                commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(thermostate_high)
            end

        elseif tonumber(ds['AantalThuis']) == 0 then

            commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(thermostate_low)

        end

    end

end


-- thermostate change when people leave or get home
if c['IemandThuis'] ~= nil then

    if tonumber(ds['AantalThuis']) == 0 then

		commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(thermostate_low)

    elseif tonumber(ds['AantalThuis']) > 0 then

        if d['Nacht'] == "Off" then

			commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(thermostate_high)

        elseif d['Nacht'] == "On" then

			commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(thermostate_low)

        end

    end

end


-- fallback when heater stays on for some apparent reason
if d['CV Ketel'] == 'On' and time_difference(dl['CV Ketel']) > (60 * heater_on_max) then

    commandArray['CV Ketel'] = 'Off'
    commandArray['Variable:Is_warming'] = '0 AFTER '..tostring(heater_reset * 60)

    print('heater longer on than allowed, force shut down')

end


-- temperature shortcuts
if c['Zet thermostaat'] ~= nil and c['Zet thermostaat'] ~= 'Off' then

	commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(tonumber(c['Zet thermostaat']))
    commandArray['Zet thermostaat'] = 'Off'

end


if difference <= sensor_age_critical then

    tempDiff = (tonumber(ThermTemp) - .2) - tonumber(WK[1])

    -- turn on heater
    if tempDiff > 0.0 and u['Is_warming'] == 0 then

        minutesOn = tempDiff * 20
        if minutesOn < heater_on_min then minutesOn = heater_on_min end
        if minutesOn > heater_on_max then minutesOn = heater_on_max end

        print('heater on for '..tostring(minutesOn)..' minutes')

        commandArray['CV Ketel'] = 'On FOR '..tostring(minutesOn)                               -- set on for {heater_on} minutes
        commandArray[0] = {['Variable:Is_warming'] = '1'}			                            -- set variable to 1
        commandArray[1] = {['Variable:Is_warming'] = '0 AFTER '..tostring((minutesOn + heater_reset) * 60)}   -- reset after {heater_reset} minutes

--[[         commandArray[2] = {['SendNotification'] = 'Thermostate#'..
          'Binnen: '..WK[1]..', gewenst: '..ThermTemp..'. Zet ketel aan voor '..tostring(minutesOn)..' minutes'
        } --]]		-- send notification about turning on

    end

    -- batteries of sensor are restored to normal
    if difference <= sensor_age_warning and u['Age_WK_sensor_state'] > 0 then

        commandArray[3] = {['SendNotification'] = 'Thermostate#Sensor weer functioneel'}
        commandArray[4] = {['Variable:Age_WK_sensor_state'] = '0'}

    end

    -- first warning about batteries
    if difference > sensor_age_warning and u['Age_WK_sensor_state'] < 1 then

		print('difference: '..difference)

        commandArray[5] = {['SendNotification'] = 'Thermostate#Sensor gegevens ouder dan '..tostring(sensor_age_warning / 60)..
            ' minuten. Vervang batterijen'}
        commandArray[6] = {['Variable:Age_WK_sensor_state'] = '1'}

    end

-- second warning about batteris
elseif difference > sensor_age_critical and u['Age_WK_sensor_state'] < 2 then

	print('difference: '..difference)
    commandArray[7] = {['SendNotification'] = 'Thermostate#Sensor gegevens ouder dan '..tostring(sensor_age_critical / 60)..
        ' minuten. Ketel zal niet meer aangaan'}
    commandArray[8] = {['Variable:Age_WK_sensor_state'] = '2'}

end

if (c['Hotter'] == 'On') then
    newval = tostring(ds['Thermostaat'] + .5)		-- add a half degree
    commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(newval)
end

if (c['Colder'] == 'On') then
    newval = tostring(ds['Thermostaat'] - .5)		-- subtract a half degree
    commandArray['UpdateDevice'] = thermostate_idx..'|0|'..tostring(newval)
end

-- debug information
if next(commandArray) ~= nil then
	print('commandArray script_device_thermostate')
	vardump(commandArray)
end

return commandArray