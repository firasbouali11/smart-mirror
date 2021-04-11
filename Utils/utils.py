import json
import datetime
import os

months = ["january","february","march","april","may","june","july","september","october","november","december"]

def getFullPath(filename):
    basedir = os.path.dirname(__file__)
    basedir = basedir.split("/")
    basedir.pop(-1)
    basedir = "/".join(basedir)
    return os.path.join(basedir,filename)



def readjson(filename):
    f = open(filename)
    data = json.load(f)
    f.close()
    return data


def formatDate(date,time):
    date = date.lower()
    time = time.lower()
    day = int(date.split(" ")[1].replace("th","").replace("sd","").replace("st","").replace("rd",""))
    month = months.index(date.split(" ")[0])+1
    year = datetime.datetime.today().year
    hour = int(time.split(":")[0])
    minute = int(time.split(":")[1].split(" ")[0])
    print(day,month,sep="/")
    print(hour,minute,sep=":")
    return datetime.datetime(year,month,day,hour,minute)
    # return f"{year}-{month}-{day} {hour}:{minute}"