import RPi.GPIO as GPIO

#importing the library of RPi.GPIO

import time

#importing the library of time
import cv2

# set up camera object called Cap which we will use to find OpenCV
cap = cv2.VideoCapture(0)





#declaring the BCM mode of pins

# QR code detection Method
detector = cv2.QRCodeDetector()# QR code detection Method



try:

    while True:
        _, img = cap.read()
        data, bbox, _ = detector.detectAndDecode(img)
        if(bbox is not None):
            for i in range(len(bbox)):
                cv2.line(img, (int(bbox[i][0][0]),int(bbox[i][0][1])), (int(bbox[(i-1) % len(bbox)][0][0]),int(bbox[(i-1) % len(bbox)][0][1])), color=(255,
                     0, 0), thickness=2)
            cv2.putText(img, data, (int(bbox[0][0][0]), int(bbox[0][0][1]) - 10), cv2.FONT_HERSHEY_SIMPLEX,
                    1, (255, 250, 120), 2)
        if data :
            print(data)
            break
          
 


            
    
except KeyboardInterrupt:

#if any key is pressed on keyboard terminate the program
    GPIO.cleanup()  
        