utils = (loadfile '/home/pi/domoticz/scripts/lua/utils/utils.lua')()
plexht_ip = 'x.x.x.x'

commandArray = {}

if (c['Doorbell'] == "On" or c['Doorbell'] == "Group On") then

    -- if nobody home, send notification
	if tonumber(otherdevices_svalues['AantalThuis']) == 0 then
	    commandArray = {['SendNotification'] = 'Deurbel#Deurbel gaat, niemand thuis'}
	end

	-- load JSON
	JSON = (loadfile '/home/pi/domoticz/scripts/lua/utils/json.lua')()

	-- Plex url
    full_url = "http://"..plexht_ip..":3005/jsonrpc"

    -- default playing is nil
    local isPlaying = nil

    -- request current play state
    local postdata = '{"jsonrpc": "2.0", "method": "Player.GetProperties", "params": { "properties": ["speed"], "playerid": 1 }, "id": 1}'
    local handle = io.popen('/usr/bin/curl -X POST --data \''..postdata..'\' --header "Content-Type: application/json" "'..full_url..'"')
    local result = handle:read()
    handle:close()
    plexData = JSON:decode(result)

	-- if error, it is stopped or not running
    if plexData['error'] ~= nil then
	    isPlaying = false
	-- speed 0 is paused
	elseif plexData['result']['speed'] == 0 then
		isPlaying = false
	-- speed 1 is playing
	elseif plexData['result']['speed'] == 1 then
		isPlaying = true
	end

    -- if playing is true, pause player
    if isPlaying then
	    postdata = '{"jsonrpc": "2.0", "method": "Player.PlayPause", "params": { "playerid": 1 }, "id": 1}'
		handle = io.popen('/usr/bin/curl -X POST --data \''..postdata..'\' --header "Content-Type: application/json" "'..full_url..'"')
	end

end

return commandArray