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
from deepface import DeepFace
import cv2
import smtplib

EMAIL = "santal.project10@gmail.com"
PASSWORD  = "santal123456"

class Alexa:
    def __init__(self):
        self.cap = cv2.VideoCapture(0)
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.data = torch.load(getFullPath("chatbot/model.pth"), map_location=torch.device('cpu'))
        self.intents = readjson(getFullPath("chatbot/intents.json"))
        self.driver = None
        self.model = self.initModel()
        self.name = "Ava"
        self.users = requests.get("http://localhost:8000/tokens", headers={"Authorization":"token 2e2c9fc839b733f3817f8b0164b29590220d5622"}).json()
        print(self.users)
        self.user = ""
        self.emotion = ""
        self.speak(f"hey i'm {self.name}, how can i help you ?")

    def initModel(self):

        input_size = self.data["input_size"]
        hidden_size = self.data["hidden_size"]
        output_size = self.data["output_size"]
        model_state = self.data["model_state"]
        model = NeuralNet(input_size, hidden_size, output_size).to(self.device)
        model.load_state_dict(model_state)
        model.eval()

        return model

    def play_music(self, music):
        options = Options()
        options.add_argument("--remote-debugging-port=9222")
        self.driver = webdriver.Chrome(getFullPath("Utils/chromedriver"), options=options)
        self.driver.get("http://www.youtube.com")
        try:
            element = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.ID, "search"))
            )
            element.send_keys(music+" lyrics")
            element.send_keys(Keys.ENTER)
            element = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH,
                                                "/html/body/ytd-app/div/ytd-page-manager/ytd-search/div[1]/ytd-two-column-search-results-renderer/div/ytd-section-list-renderer/div[2]/ytd-item-section-renderer/div[3]/ytd-video-renderer[1]/div[1]/div/div[1]/div/h3"))
            )
            element.click()
            # global done
            # done =False
            # while not done:
            #     sleep(1)
            sleep(30)

            self.driver.close()
        except Exception as e:
            print(e)
            self.driver.quit()

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
        resp = requests.post("http://localhost:8000/tasks/", d, headers=headers)
        print(resp.json())

    def showtasks(self, u):
        token = ""
        for i,user in enumerate(self.users):
            if user["user"]["username"] == u:
                token = self.users[i]["key"]
                break

        headers = {"authorization": f"Token {token}"}
        text = requests.get("http://localhost:8000/tasks", headers=headers)
        text = text.json()
        for task in text:
            print("=" * 50)
            print(f"{task['task']} at {task['date']}")

    def response(self, sentence):
        sentence = tokenize(sentence)
        X = bag_of_words(sentence, self.data["all_words"])
        X = X.reshape(1, X.shape[0])
        X = torch.from_numpy(X).to(self.device)

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

    def reconImage(self,frame):
        try:
            a = DeepFace.find(frame, db_path=getFullPath("classifier/db"))
            emotion = DeepFace.analyze(frame, actions=["emotion"])
        except:
            return None, None
        return a, emotion

    def camera(self):
        i = 1
        while True:
            ret, frame = self.cap.read()
            # rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            facecascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
            faces = facecascade.detectMultiScale(frame, 1.1, 4)
            for x, y, w, h in faces:
                cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2)
            try:
                cv2.putText(frame, self.user, (100, 100), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
                cv2.putText(frame, self.emotion, (100, 150), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
            except:
                pass
            if i % 70 == 0:
                if len(faces) != 0:
                    a, emotion = self.reconImage(frame)
                    try:
                        self.user = a.identity[0].split("/")[-2]
                        self.emotion = emotion["dominant_emotion"]
                        cv2.putText(frame, self.user, (100, 100), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
                        cv2.putText(frame, self.emotion, (100, 250), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 0, 0), 2)
                        i = 1
                    except:
                        pass

            i += 1
            cv2.imshow('frame', frame)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

    def cameraDone(self):
        self.cap.release()
        cv2.destroyAllWindows()

    def sendEmail(self,reciever="firas.bouali11@gmail.com",message="hello world"):
        server = smtplib.SMTP("smtp.gmail.com",587)
        server.starttls()
        server.ehlo()
        server.login(EMAIL,PASSWORD)
        server.sendmail(EMAIL,reciever,message)
        server.close()
        self.speak("email is sent successfuly !")


