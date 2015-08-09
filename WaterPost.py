#!/usr/bin/env python
# BCM GPIO 23 == PIN 16 == GPIO 4


import time
import RPi.GPIO as GPIO
import json
import urllib2
import base64

GET_URL = 'http://192.168.1.205:8080/json.htm?type=command&param=getuservariable&idx=1'
SET_URL = 'http://192.168.1.205:8080/json.htm?type=command&param=udevice&idx=15&nvalue=0&svalue='
SET_VAR_URL = 'http://192.168.1.205:8080/json.htm?type=command&param=updateuservariable&idx=1&vname=Water&vtype=0&vvalue='
WATER_VALUE = 0
base64string = base64.encodestring('%s:%s' % ('username','password')).replace('\n', '')


# handle the button event
def Trigger (pin):
   if GPIO.input(23):
    
     global WATER_VALUE
     WATER_VALUE += 1
     # print WATER_VALUE

     POST_URL = SET_URL + str(WATER_VALUE)

     global base64string
	       
     requestPost = urllib2.Request(POST_URL)
     requestPost.add_header("Authorization", "Basic %s " % base64string)
     resultPost = json.load(urllib2.urlopen(requestPost))
     # print resultPost
	  
     POST_VAR = SET_VAR_URL + str(WATER_VALUE)
	  
     requestVar = urllib2.Request(POST_VAR)
     requestVar.add_header("Authorization", "Basic %s " % base64string)
     resultVar = json.load(urllib2.urlopen(requestVar))
     # print resultVar

     
# main function
def main():

    GPIO.setmode(GPIO.BCM)
    GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

    GPIO.add_event_detect(23, GPIO.RISING, callback=Trigger, bouncetime=500)

    request = urllib2.Request(GET_URL)
    
    global base64string
    request.add_header("Authorization", "Basic %s " % base64string)
    result = json.load(urllib2.urlopen(request))

    global WATER_VALUE
    WATER_VALUE = int( result['result'][0]['Value'])
    print WATER_VALUE

    while True:
        time.sleep(1)


   # GPIO.cleanup()



if __name__=="__main__":
    main()


