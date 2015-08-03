Scripts for use on the Raspberry Pi in combination with Domoticz


[Domoticz](http://www.domoticz.com/)


# HOW TO:
-----

## Check Device Online.py
-----

##### 1. Create a folder an checkout check_device_online.py

##### 2. Run the next command on the Raspberry Pi: (command line)
 
 ```
 chmod 777 /tmp/;
 mkdir /var/log/cdo;
 chmod 777 /var/log/cdo/;
 ```
 
 This creates a folder for the PID files.

##### 3. On Domoticz, create a dummy switch, and copy the IDx, for example 18

##### 4. On the command line, edit the cronjobs:
 ```
 crontab -e
 ```
 
##### 5. Add the next row to the file:
 ```
 * * * * * [path to script] [IP] [XID] [SECS] [OFFLINE_TRESHOLD] > /dev/null 2>&1
 ```

	For example
```
* * * * * /usr/bin/python /home/pi/domoticz/scripts/python/domoticz/check_device_online.py 192.168.1.200 18 10 60 > /dev/null 2>&1
```




## WaterPost.py
-----

This scripts will add '1' to a user var and update a given device with this value.
The script needs to be started at start-up and is triggered by a puls (3.3v) on PIN 16 (GPIO4).

Multiple pulses within a short timespan (button bouncing) is dealt within the script.





##### 1. Create a user var named, and write down its IDx and name.

##### 2. Create a dummy meter (water), and write down its IDx.

##### 3. Checkout File into folder.

##### 4. Edit script by using nano

```
sudo nano WaterPost.py
```

  * Change the IP's to the IP address of your PID.

  * Change 'username' & 'password'.

  * Change IDx of the GET_URL SET_URL and SET_VAR_URL to the correct id's.


##### 5. Test the script by running:

```
sudo python WaterPost.py
```

You probably need to install the next items:
  * RPi.GPIO

##### 6. If it runs, set it to run at start-up 
