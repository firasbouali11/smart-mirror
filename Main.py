from Alexa.alexa import Alexa
import threading
from Utils.utils import formatDate

def seeme(alexa):
    alexa.camera()
    alexa.cameraDone()

def servant(alexa):
    while 1:
        tag = ""
        recon=""
        try:
            recon = alexa.recon()
        except:
            print("error")
        print(recon)
        if alexa.name.lower() in recon.lower():
            tag, answer = alexa.response(recon)
            alexa.speak(answer)
            if tag == "music":
                music = alexa.recon()
                alexa.play_music(music)
            elif tag=="email":
                alexa.speak("who is the receiver ?")
                reciever = alexa.recon(duration=10)
                reciever = reciever.replace(" ","").replace("at","@")
                print(reciever)
                alexa.speak("what is the message ?")
                message = alexa.recon(duration=20)
                print(message)
                alexa.sendEmail(message=message)
            elif tag == "tasks":
                if alexa.user != "":
                    alexa.speak("do you want me to show you your tasks or you want to add new tasks ?")
                    aa = alexa.recon()
                    if "add" in aa.lower() or "new" in aa.lower():
                        alexa.speak("what do you want to call this task ?")
                        taskname = alexa.recon()
                        alexa.speak("what is the date of this task")
                        date = alexa.recon()
                        alexa.speak("what is the time of this task")
                        time = alexa.recon()
                        alexa.speak("ok, done !")
                        x = formatDate(date, time)
                        alexa.sendTask("firas", alexa.user, taskname, x)
                    else:
                        alexa.showtasks(alexa.user)
            elif tag == "goodbye":
                exit()


if __name__ == "__main__":
    alexa = Alexa()
    t1 = threading.Thread(target=seeme,args=(alexa,))
    t2 = threading.Thread(target=servant,args=(alexa,))
    t1.start()
    t2.start()



