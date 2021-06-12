import pickle
import socket
import struct
from deepface import DeepFace
import cv2
deepface_model = DeepFace.build_model("VGG-Face")


def reconImage(frame):
    a,emotion = "",""
    try:
        a = DeepFace.find(frame, db_path="../classifier/db",model=deepface_model)
        emotion = DeepFace.analyze(frame, actions=["emotion"])
    except Exception as e:
        print(e)
    return a, emotion

def camera(frame,i=1):
    global user
    global emotion
    # rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    facecascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
    faces = facecascade.detectMultiScale(frame, 1.1, 4)
    for x, y, w, h in faces:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2)
    try:
        cv2.putText(frame, user, (x, y-70), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
        cv2.putText(frame, emotion, (x, y-20), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
    except:
        pass
    if i % 70 == 0:
        if len(faces) != 0:
            a,emotion = reconImage(frame)
            try:
                user = a.identity[0].split("/")[-2]
                emotion = emotion["dominant_emotion"]
                conn.send((user+"/"+emotion).encode("utf-8"))
                cv2.putText(frame, user, (x, y-70), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
                cv2.putText(frame, emotion, (x, y-20), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
                print(user,emotion)
                i = 1
            except:
                print("error identifying faces")

import pickle
import socket
import struct
from deepface import DeepFace
import cv2

HOST = '192.168.1.7'
HOST = (([ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")] or [[(s.connect(("8.8.8.8", 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]]) + ["no IP found"])[0]
PORT = 8089

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print('Socket created')

s.bind((HOST, PORT))
print('Socket bind complete')
s.listen(10)
print('Socket now listening')

conn, addr = s.accept()

data = b''
payload_size = struct.calcsize("L")

i = 1
while True:
    # Retrieve message size
    while len(data) < payload_size:
        data += conn.recv(4098)

    packed_msg_size = data[:payload_size]
    data = data[payload_size:]
    msg_size = struct.unpack("L", packed_msg_size)[0]

    # Retrieve all data based on message size
    while len(data) < msg_size:
        data += conn.recv(4098)

    frame_data = data[:msg_size]
    data = data[msg_size:]

    # Extract frame
    frame = pickle.loads(frame_data)

    camera(frame,i)
    i+=1

    # Display
    cv2.imshow('frame', frame)
    cv2.waitKey(1)
