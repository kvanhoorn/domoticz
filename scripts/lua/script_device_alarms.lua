--[[
    
    This script sends notifications about the following  subjects:
    - door opened when asleep (nighttime)
    - door opened when nobody is at home
    - movement in the house when nobody is at home
    - fire at anytime
    
]]--

utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()

commandArray = {}

doors = {
	'Deur woonkamer',
	'Deur keuken',
	'Voordeur',
	'Schuurdeur',
	'Raam slaapkamer',
	'Garage Door'
}

pirs = {
--	'PIR Hal',
	'PIR Zolder'
}

firealarm = {
	'Brandalarm keuken',
	'Brandalarm woonkamer',
	'Brandalarm zolder'
}

-- walk trough doors
for i,door in ipairs(doors) do

    -- door is opened
	if c[door] ~= nil and c[door] == 'On' then

        -- if nobody is home, notify on away
		if d['IemandThuis'] == 'Off' then

			commandArray = {['SendNotification'] = 'Alarm#'..door..' geopend - niemand thuis#2#Siren'}

        -- if it's night, notify on nightmode
		elseif d['Nacht'] == 'On' then

			commandArray = {['SendNotification'] = 'Alarm#'..door..' geopend - nachtmodus#2#Siren'}

		end

	end

end

-- walk trough pirs
for i,pir in ipairs(pirs) do

    -- pir saw movement
	if c[pir] ~= nil and c[pir] == 'On' then

        -- if nobody is home, notify on away
		if d['IemandThuis'] == 'Off' then

			commandArray = {['SendNotification'] = 'Alarm#'..pir..' beweging - niemand thuis#2#Siren'}

		end

	end

end

-- walk trough fire alarms
for i,fire in ipairs(firealarm) do

    -- if firealarm is on, notify
	if c[fire] ~= nil and (c[fire] == 'On' or c[fire] == "Panic") then

	    commandArray = {['SendNotification'] = 'Alarm#'..fire..'#2#Siren'}

	end

end

return commandArray