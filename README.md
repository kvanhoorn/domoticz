Scripts for use on the Raspberry Pi in combination with Domoticz


[Domoticz](http://www.domoticz.com/)


# HOW TO:
-----

## Check Device Online
-----

1. #####Create a folder an checkout  check_device_online.py

2. #####Run the next command on the Raspberry Pi: (command line)
 
 ```
 chmod 777 /tmp/;
 mkdir /var/log/cdo;
 chmod 777 /var/log/cdo/;
 ```
 
 This creates a folder for the PID files.

3. #####On Domoticz, create a dummy switch, and copy the IDx, for example 18

4. #####On the command line, edit the cronjobs:
 ```
 crontab -e
 ```
 
5. #####Add the next row to the file:
 ```
 * * * * * [path to script] [IP] [XID] [SECS] [OFFLINE_TRESHOLD] > /dev/null 2>&1
 ```

	For example
    ```
* * * * * /usr/bin/python /home/pi/domoticz/scripts/python/domoticz/check_device_online.py 192.168.1.200 18 10 60 > /dev/null 2>&1
	```
