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
        again = True
        while(again):
            print("Welcome to Powers POS\n\n")
            print("1. Login\n2. Register\n0. Exit\n")
            userinput = int(input(">>>>:"))

            #validate user input
            while(userinput < 0 and userinput > 2):
                print("Please input a valid menu choice.")
                userinput = int(input(">>>>:"))

            #login
            if (userinput == 1):
                username = self.login()
                if (username): #login succeeded
                    main = mainMenu(self.server, username)
                    main.start()
                    again = False
                else: 
                    print("Login unsuccessful\n")
                    sleep(5)
            
            #register
            elif (userinput == 2):
                username = self.register()
                if (username):
                    main = mainMenu(self.server, username)
                    main.start()
                    again = False
                else:
                    print("Register unsuccessful\n")
                    sleep(5)

            # input is 0 which is exit
            else:
                again = False
            #clear and return to shell
            clear()
            

    #login function presented to the user first
    #returns false when fail and username when true
    def login(self):
        username = input("Please input your username: ")
        password = input("Please input your password: ")

        #create json to send
        payload = {
            "username": username,
            "password": password
            }
        payload = dumps(payload)

        #send and recieve status
        try:
            res = self.server.get(route='/login', data=payload)
        except ConnectionError: # connection failed
            print("Connection error\n")
            return False
        
        #check response
        if (res.status_code == 200): #successful login
            return username
        else: #failed login
            return False

    #allows the user to register new account
    #returns false when fail and username when true
    def register(self):
        name = input("Full Name:")
        username = input("Username:")
        password = input("Password:")
        empID = input("Employee ID:")
        addr = input("Physical Address:")
        PN = input("Phone Number:")

        payload = {
            "name": name,
            "username": username,
            "password": password,
            "employeeID": empID,
            "address": addr,
            "phoneNumber": PN
        }
        payload = dumps(payload)

        #send and recieve status
        try:
            res = self.server.post(route='/register', data=payload)
        except ConnectionError: # connection failed
            print("Connection Error!!\n")
            return False
        
        #check response
        if (res.status_code == 200): #successful register
            return username
        else: #failed register
            return False


#introduction
print("This POS system is in the testing phase and does not gurentee complete support.\n"
        + "This system was developed by a team from Arkansas State University to fulfill a requirement for a class.\n"
        + "Basic functioning could fail and crash!\n\n")

sleep(3)

#start program
pointOfSale = pointOfSaleSystem('http://localhost:3000')
pointOfSale.start()

#end of program