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
        print("1. Login\n2. Register\n0. Exit\n")
        userinput = int(input(">>>>:"))
        while(userinput < 0 and userinput > 2):
            print("Please input a valid menu choice.")
            userinput = int(input(">>>>:"))
        if (userinput == 1):
            self.login()
        elif (userinput == 2):
            self.register()
        #clear and return to shell
        clear()
            

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
        res = self.server.get(route='/', data=payload)
        if (res["status"] == "authorized"):
            main = mainMenu(self.server, res["username"])
            main.start()

    #allows the user to register new account
    def register(self):
        name = input("Full Name:")
        password = input("Password:")
        empID = input("Employee ID:")
        addr = input("Physical Address:")
        PN = input("Phone Number:")
        role = input("Role:")

        payload = {
            "name": name,
            "password": password,
            "employeeID": empID,
            "address": addr,
            "phoneNumber": PN,
            "role": role
        }
        payload = dumps(payload)
        res = self.server.put(route="/", data=payload)
        if (res["status"] == "authorized"):
            print("Your username is:'"+res["username"]+"'\nSave it for your records")
            print("Press enter to continue")
            input()
            main = mainMenu(self.server, res["username"])
            main.start()


#introduction
print("This POS system is in the testing phase and does not gurentee complete support.\n"
        + "This system was developed by a team from Arkansas State University to fulfill a requirement for a class.\n"
        + "Basic functioning could fail and crash!\n\n")

sleep(3)

#start program
pointOfSale = pointOfSaleSystem('http://localhost:3000')
pointOfSale.start()

#end of program