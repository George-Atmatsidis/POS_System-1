from clear import clear
from datetime import date
from server import server
import accountsRecievable

class mainMenu():

    def __init__(self, server):
        self.server = server
        self.user = server.get_user()

    #helper function for start
    def __printMainMenu__(self):
        clear()
        print(f'{(date.today()).strftime("%m/%d/%Y")}\t\t Main Menu\t\t {self.user}') #Header
        print("\n\n")
        #Print menu options
        menuOptions = "1. Accounts Recievable\n2. Inventory Management\n3. Customer Management\n4. Employee Management\n5. Parts Counter Menu\n0. Exit\n\n"
        print(menuOptions)

    #determines a good user choice
    def __determineChoice__(self):
        isBad = True
        while(isBad):
            try:
                userChoice = int(input(">>>>:"))
                isBad = False #break loop
            except:
                print("Please enter a valid input")
            
        returned = False
        if  (userChoice == 1):
            AR = accountsRecievable.AccountsRecievable(self.server)
            AR.start()
            pass
        elif (userChoice  == 2):
            #go to Inventory Management
            pass
        elif (userChoice == 3):
            #go to Customer Management
            pass
        elif (userChoice == 4):
            #go to Employee Management
            pass
        elif (userChoice == 5):
            #go to Parts Counter Menu
            pass
        elif (userChoice == 0):
            #exit program
            pass
        else:
            print("Please enter valid menu choice\n")
            returned = True #needs to ask again
        return returned

    def start(self):
        good = True #used to set if there is an error
        self.__printMainMenu__()
        while (self.__determineChoice__()):
            continue

        return good

        

