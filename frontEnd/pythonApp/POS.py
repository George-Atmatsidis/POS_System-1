import json
import requests
from datetime import datetime
from time import sleep
from mainMenu import mainMenu
from clear import clear


#setting global variables
host = 'http://localhost:3000'
user = ""
header = { 'content-type': 'application/json' }

#introduction
print("This POS system is in the testing phase and does not gurentee complete support.\n"
        + "This system was developed by a team from Arkansas State University to fulfill a requirement for a class.\n"
        + "Basic functioning could fail and crash!\n\n")

sleep(3)


#login function presented to the user first
def login():
    print("Welcome to Powers POS\n\n")
    username = input("Please input your username: ")
    password = input("Please input your password: ")
    user = username

    #create json to send
    payload = {
        "username": username,
        "password": password,
        "status": "authorizing"
        }
    payload = json.dumps(payload)

    #send and recieve status
    res = requests.get(host, data=payload, headers=header)
    response = json.loads(res.content)
    if (response["status"] == "authorized"):
        mainMenu(user)

    #at this point the program is done
    #return user to their prompt
    clear()

#start program
clear()
login()

"""
#test GET request
r = requests.get(host)
r = json.loads(r.json())
#print(r["name"])

#test PUT request
payload = {
    "name": userinput,
}

payload = json.dumps(payload)
r = requests.put(host, data=payload, headers=header)
print(r.text)
"""