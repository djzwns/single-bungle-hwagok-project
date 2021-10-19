# -*- coding: utf-8 -*-

import sys
from threading import currentThread
import cv2
import numpy as np
import time
from client import *
from darknet import *

STREAM_URL = "http://127.0.0.1:8090/?action=stream"

cap = cv2.VideoCapture(STREAM_URL)
if not cap.isOpened():
	print("video open failed")
	sys.exit()

status, frame = cap.read()
if not status:
	print("video capture failed")
	sys.exit()

# client connect
HOST = "192.168.10.88"
PORT = 5000
client = Client(HOST, PORT)
client.init("guest1", "guest")
client.run()

SCALE_FACTOR = 1.2
FRAME_RATE = 33
frameWidth = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frameHeight = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
frameSize = (frameWidth, frameHeight)
print ('frameSize={}'.format(frameSize))

cascade = cv2.CascadeClassifier("./haarcascades/haarcascade_eye.xml")

# # dnn 
# model_name = "./SSD/MobileNetSSD_deploy.caffemodel"
# prototxt_name = "./SSD/MobileNetSSD_deploy.prototxt.txt"
# CONF_VALUE = 0.5
# model = cv2.dnn.readNetFromCaffe(prototxt_name, model_name)

FPS = 10 # 초당 10 프레임
secPerFrame = 1.0 / FPS
currentTime = 0
prevTime = 0

detectionCnt = 0

while True:
	status, frame = cap.read()
	if not status:
		break

	currentTime = time.time()
	if (currentTime - prevTime) < secPerFrame:
		continue

	prevTime = currentTime

	if client.secureMode is False:
		continue

	# 영상 처리 시작
	factor = 0.5
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	# gray = cv2.resize(gray, (0, 0), fx=factor, fy=factor, interpolation=cv2.INTER_AREA)
	body = cascade.detectMultiScale(gray, SCALE_FACTOR, 3)

	if len(body) > 0:
		detectionCnt += 1

	if detectionCnt >= FPS: # 1초마다 전송		
		client.send("[admin]DETECTION@ON\n")
		detectionCnt = 0

	# for (x, y, w, h) in body:		
	# 	# fx, fy = (int(x / factor), int(y / factor))
	# 	# fw, fh = (int(fx + (w / factor)), int(fy + (h / factor)))
	# 	# cv2.rectangle(frame, (fx, fy), (fx + fw, fy + fh), (0, 255, 0), 1)
	# 	cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 1)

	
	## DNN
	# (h, w) = frame.shape[:2]
	# resize_img = cv2.resize(frame, (300, 300))
	# blob = cv2.dnn.blobFromImage(resize_img, 0.007843, (300, 300), 127.5)
	# model.setInput(blob)
	# detections = model.forward()
	# for i in range(0, detections.shape[2]):
	# 	confidence = detections[0, 0, i, 2]
	# 	if confidence > CONF_VALUE:
	# 		box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
	# 		(startX, startY, endX, endY) = box.astype("int")
	# 		# print(confidence, startX, startY, endX, endY)
	# 		text = "{:2f}".format(confidence * 100)
	# 		y = startY - 10 if startY - 10 > 10 else startY + 10
	# 		cv2.rectangle(frame, (startX, startY), (endX, endY), (0, 255, 0), 1)
	# 		cv2.putText(frame, text, (startX, y), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)
			
	# 		# client.send("[admin]WARN@{}".format(text))

	# # darknet yolo
	# blob = cv2.dnn.blobFromImage(frame, 1/255, (whT, whT), [0, 0, 0], True, crop=False)
	# net.setInput(blob)

	# layerNames = net.getLayerNames()
	# outputNames = [layerNames[i[0] - 1] for i in net.getUnconnectedOutLayers()]
	# outputs = net.forward(outputNames)

	# findObjects(outputs, frame)

	# cv2.imshow('cctv', frame)

	if cv2.waitKey(1) == 27:
		break

cap.release()
cv2.destroyAllWindows()
