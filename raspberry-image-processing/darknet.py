# -*- coding: utf-8 -*-
# yolo
import cv2 
import numpy as np

device = 0
whT = 320

confThreshold_1 = 0.5
confThreshold_2 = 0.7
nmsThreshold = 0.3

classesFile = 'coco.names'

with open(classesFile, "rt") as f:
    classNames = f.read().split("\n")
    
model_config = "/home/pi/darknet/cfg/yolov3-tiny.cfg"
model_weights = "/home/pi/darknet/yolov3-tiny.weights"

net = cv2.dnn.readNetFromDarknet(model_config, model_weights)
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_OPENCV)
net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)

def findObjects(outputs, img):
    reimg = cv2.resize(img, (300, 300))
    hT, wT, cT = reimg.shape
    boxes = []
    classIds = []
    confs = []

    for output in outputs:
        for detect in output:
            scores = detect[5:]
            classId = np.argmax(scores)
            confidence = scores[classId]
            if confidence > confThreshold_1:
                w, h = int(detect[2] * wT), int(detect[3] * hT)
                x, y = int((detect[0] * wT) - w * 0.5), int((detect[1] * hT) - h * 0.5)
                boxes.append([x, y, w, h])
                classIds.append(classId)
                confs.append(float(confidence))

        indices = cv2.dnn.NMSBoxes(boxes, confs, confThreshold_2, nmsThreshold)
    print(f"detection count: {len(indices)} ea")

    for i in indices:
        i = i[0]
        box = boxes[i]
        x, y, w, h = box[0], box[1], box[2], box[3]
        cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 1)
        cv2.putText(img, f"{classNames[classIds[i]].upper()} {int(confs[i] * 100)}%", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 1)