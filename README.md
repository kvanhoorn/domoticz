chmod 777 /tmp/;
mkdir /var/log/cdo;
chmod 777 /var/log/cdo/;

edit check_device_online.py change domoticzserver into own ip


example cronjob:

* * * * * /usr/bin/python /home/pi/domoticz/scripts/python/domoticz/check_device_online.py [IP] [XID] [SECS] [OFFLINE_TRESHOLD] > /dev/null 2>&1
* * * * * /usr/bin/python /home/pi/domoticz/scripts/python/domoticz/check_device_online.py 192.168.x.x 12 10 60 > /dev/null 2>&1
