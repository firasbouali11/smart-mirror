from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from gtts import gTTS
from time import sleep
import os
import speech_recognition as sr
import requests
from Utils.utils import readjson, getFullPath
from chatbot.model import NeuralNet
import torch
from chatbot.nltk_utils import bag_of_words, tokenize
import random
import cv2
import smtplib
import pickle
import socket
import struct
import sys

EMAIL = "santal.project10@gmail.com"
PASSWORD  = "santal123456"

#host = (([ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")] or [[(s.connect(("8.8.8.8", 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]]) + ["no IP found"])[0]

host = sys.argv[1]
ENDPOINT = f"http://{host}:8000/"
print(ENDPOINT)
clientsocket=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
clientsocket.connect((host,9999))

cap = cv2.VideoCapture(0)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
driver = None

class Alexa:
    def __init__(self):
        self.data = torch.load(getFullPath("chatbot/model.pth"), map_location=torch.device('cpu'))
        self.intents = readjson(getFullPath("chatbot/intents.json"))
        self.model = self.initModel()
        self.name = "Ava"
        self.users = requests.get(f"{ENDPOINT}tokens", headers={"Authorization":"token b0adec18090c34468cdf18e2230b308fb5ad2d70"}).json()
        print(self.users)
        self.user = ""
        self.emotion = ""
        self.speak(f"hey i'm {self.name}, how can i help you ?")

    def initModel(self):

        input_size = self.data["input_size"]
        hidden_size = self.data["hidden_size"]
        output_size = self.data["output_size"]
        model_state = self.data["model_state"]
        model = NeuralNet(input_size, hidden_size, output_size).to(device)
        model.load_state_dict(model_state)
        model.eval()

        return model

    def play_music(self, music):
        options = Options()
        options.add_argument("--remote-debugging-port=9222")
        driver = webdriver.Chrome(getFullPath("Utils/chromedriver"), options=options)
        driver.get("http://www.youtube.com")
        try:
            element = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.ID, "search"))
            )
            element.send_keys(music+" lyrics")
            element.send_keys(Keys.ENTER)
            element = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.XPATH,
                                                "/html/body/ytd-app/div/ytd-page-manager/ytd-search/div[1]/ytd-two-column-search-results-renderer/div/ytd-section-list-renderer/div[2]/ytd-item-section-renderer/div[3]/ytd-video-renderer[1]/div[1]/div/div[1]/div/h3"))
            )
            element.click()
            # global done
            # done =False
            # while not done:
            #     sleep(1)
            sleep(30)

            driver.close()
        except Exception as e:
            print(e)
            driver.quit()

    def speak(self, text):
        klem = gTTS(text)
        klem.save("klem.mp3")
        os.system("mpg321 klem.mp3")
        os.remove("klem.mp3")

    def recon(self, duration=3, listen=False):
        r = sr.Recognizer()
        with sr.Microphone() as source:
            # r.adjust_for_ambient_noise(source)
            print("listening ...")
            if listen:
                audio = r.listen(source)
            else:
                audio = r.record(source, duration=duration)

        try:
            return r.recognize_google(audio)
        except LookupError:
            print("Could not understand audio")
            return None

    def sendTask(self, u, taskname, date):
        for i, user in enumerate(self.users):
            if user["user"]["username"] == u:
                token = self.users[i]["key"]
                break
        headers = {
            "authorization": f"Token {token}"
        }
        d = {
            "task": taskname,
            "date": date
        }
        resp = requests.post(f"{ENDPOINT}tasks/", d, headers=headers)
        print(resp.json())

    def showtasks(self, u):
        token = ""
        for i,user in enumerate(self.users):
            if user["user"]["username"] == u:
                token = self.users[i]["key"]
                break

        headers = {"authorization": f"Token {token}"}
        text = requests.get(f"{ENDPOINT}tasks", headers=headers)
        text = text.json()
        for task in text:
            print("=" * 50)
            print(f"{task['task']} at {task['date']}")

    def response(self, sentence):
        sentence = tokenize(sentence)
        X = bag_of_words(sentence, self.data["all_words"])
        X = X.reshape(1, X.shape[0])
        X = torch.from_numpy(X).to(device)

        output = self.model(X)
        _, predicted = torch.max(output, dim=1)

        tag = self.data["tags"][predicted.item()]

        probs = torch.softmax(output, dim=1)
        prob = probs[0][predicted.item()]
        if prob.item() > 0.6:
            for intent in self.intents['intents']:
                if tag == intent["tag"]:
                    return tag,random.choice(intent['responses'])
        else:
            return "none","I do not understand..."

    def camera(self):
        while True :
            ret, frame = cap.read()
            # Serialize frame
            data = pickle.dumps(frame)

            # Send message length first
            message_size = struct.pack("L", len(data))

            # Then data
            clientsocket.send(message_size+data)

    def cameraDone(self):
        cap.release()
        cv2.destroyAllWindows()

    def identify(self):
        while True:
            user = clientsocket.recv(4096)
            if not user:
                print("no user !")
                break
            user, emotion = user.decode("utf-8").split("/")
            if user != self.user:
                self.user = user
                self.emotion = emotion
                self.speak(f"hey {self.user}")
            print("user : "+self.user+" || "+self.emotion)

    def sendEmail(self,reciever="firas.bouali11@gmail.com",message="hello world"):
        server = smtplib.SMTP("smtp.gmail.com",587)
        server.starttls()
        server.ehlo()
        server.login(EMAIL,PASSWORD)
        server.sendmail(EMAIL,reciever,message)
        server.close()
        self.speak("email is sent successfuly !")


