import cv2
from client import *

STREAM_URL = "http://192.168.10.93:8090/?action=stream"
HOST = "192.168.10.88"
PORT = 5000
client = Client(HOST, PORT)
client.init()
#client.sendMsg("[admin]test")
client.run()


cap = cv2.VideoCapture(STREAM_URL)

frameRate = 33
frameWidth = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
frameHeight = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
frameSize = (frameWidth, frameHeight)
print ('frameSize={}'.format(frameSize))

while True:
	retval, frame = cap.read()
	if not(retval):
		break

	cv2.imshow('frame', frame)
	key = cv2.waitKey(frameRate)

	if key == 27:
		break

if cap.isOpened():
	cap.release()

cv2.destroyAllWindows()
