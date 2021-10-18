import sys
from threading import currentThread
import cv2
import numpy as np
import time
from client import *

STREAM_URL = "http://127.0.0.1:8090/?action=stream"
# HOST = "192.168.10.88"
# PORT = 5000

cap = cv2.VideoCapture(STREAM_URL)
if not cap.isOpened():
	print("video open failed")
	sys.exit()

status, frame = cap.read()
if not status:
	print("video capture failed")
	sys.exit()

# client = Client(HOST, PORT)
# client.init()
# client.run()

SCALE_FACTOR = 1.2
FRAME_RATE = 33
frameWidth = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frameHeight = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
frameSize = (frameWidth, frameHeight)
print ('frameSize={}'.format(frameSize))

cascade = cv2.CascadeClassifier("./haarcascades/haarcascade_upperbody.xml")

fps = 1.0 / 33.0 # 초당 33 프레임
currentTime = 0
prevTime = 0

while True:
	status, frame = cap.read()
	if not status:
		break

	currentTime = time.time() - prevTime
	if currentTime < fps:
		continue

	prevTime = currentTime
	currentTime -= fps	# 초과된 시간 유지

	# 영상 처리 시작
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	#gray = cv2.resize(gray, None, fx=)
	body = cascade.detectMultiScale(gray, SCALE_FACTOR, 2)
	for (x, y, w, h) in body:
		cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 1)

	cv2.imshow('cctv', frame)

	if cv2.waitKey(FRAME_RATE) == 27:
		break

cap.release()
cv2.destroyAllWindows()
