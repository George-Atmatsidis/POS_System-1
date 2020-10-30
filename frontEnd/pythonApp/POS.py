from json import dumps
from datetime import datetime
from time import sleep
from mainMenu import mainMenu
from clear import clear
from server import server

class pointOfSaleSystem:

    def __init__(self, host):
        self.server = server(host)
        clear() # clear screen in prep for entry

    def start(self):
        print("Welcome to Powers POS\n\n")
        self.login()

    #login function presented to the user first
    def login(self):
        username = input("Please input your username: ")
        password = input("Please input your password: ")

        #create json to send
        payload = {
            "username": username,
            "password": password,
            "status": "authorizing"
            }
        payload = dumps(payload)

        #send and recieve status
        res = self.server.get(root='/', data=payload)
        if (res["status"] == "authorized"):
            main = mainMenu(self.server, username)
            main.start()

        #at this point the program is done
        #return user to their prompt
        clear()



#introduction
print("This POS system is in the testing phase and does not gurentee complete support.\n"
        + "This system was developed by a team from Arkansas State University to fulfill a requirement for a class.\n"
        + "Basic functioning could fail and crash!\n\n")

sleep(3)

#start program
pointOfSale = pointOfSaleSystem('http://localhost:3000')
pointOfSale.start()

#end of program