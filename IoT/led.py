import RPi.GPIO as GPIO
import time
from gpiozero import LED #imports the LED functions from gpiozero library

from time import sleep #imports the sleep function from time library

led = LED(17)
GPIO.setmode(GPIO.BCM)
PIR_PIN = 5
GPIO.setup(PIR_PIN, GPIO.IN)

try:
               
                       
               
                    if GPIO.input(PIR_PIN):
                       
                        time.sleep(1)
                        led.on() #turn on le
                        sleep(6) #generate a delay of 2 seconds
                        led.off() #turn off led

    
except KeyboardInterrupt:
               print (" Quit")
               GPIO.cleanup()
