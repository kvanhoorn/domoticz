--[[
	FILES:
	
	script_time_xxx.lua			=> runs every minute
	script_device_xxx.lua		=> runs everytime a device changes
	script_variable_xxx.lua		=> runs everytime a variable changes
	script_security_xxx.lua		=> runs everytime security changes
	


    VARS:

    globalvariables                 = g			(all scripts)
    devicechanged                   = c			(only device script)
    otherdevices                    = d			(all scripts)
    otherdevices_idx				= di		(NOT YET AVAILABLE .. all scripts)
    otherdevices_svalues            = ds		(all scripts)
    otherdevices_lastupdate         = dl		(all scripts)
    otherdevices_utility			= du		(only time script)

	uservariables					= u			(all scripts)
	uservariablechanged				= cu		(only variable script)
	uservariables_lastupdate		= ul		(all scripts)

    timeofday                       = t			(all scripts)
    {
      Daytime = true,
      Nighttime = false,
      SunriseInMinutes = 516,
      SunsetInMinutes = 1019
    }


    devicechanged['Woonkamer']
    devicechanged['Woonkamer_Dewpoint']
    devicechanged['Woonkamer_Humidity']
    devicechanged['Woonkamer_Temperature']

    devicechanged['Eindhoven']
    devicechanged['Eindhoven_Dewpoint']
    devicechanged['Eindhoven_Humidity']
    devicechanged['Eindhoven_Barometer']

    devicechanged['Energy']
    devicechanged['Energy_Utility']

    devicechanged['Gas']
    devicechanged['Gas_Utility']




    commandArray:

        'Lamp0'                 = 'On' || 'Off'
                                  'Group On'
                                  'On FOR 2'        -- minutes
                                  'On RANDOM 30'    -- seconds
                                  'On AFTER 3'      -- seconds
                                  'Set Level 50'

        'Scene:Scene0'          = 'On' || 'Off'
??      'Group:Group0'          = 'Inactive'
        'SendNotification'      = 'subject#body#priority#sound'
            priority:
                -1  Moderate        - Quiet
                0   Normal
                1   High            - Bypass quiet hours
                2   Emergency       - Confirmation

        'SendEmail'             = 'subject#body#your@email.com'
        'SendSMS'               = 'subject'
        'Variable:Var0'         = 'Some value'
                                  'On FOR 2'        -- minutes
                                  'On AFTER 3'      -- seconds

        'OpenURL'               = 'http://www.yourdomain/some/url'
        'UpdateDevice'          = 'idx|nValue|sValue'

]]--