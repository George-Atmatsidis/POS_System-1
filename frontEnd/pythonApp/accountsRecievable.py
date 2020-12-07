from clear import clear
from server import server
from datetime import date
import bills_Recievables

class AccountsRecievable:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()

    #helper function for start
    def __printMenu__(self):
        clear()
        print(f'{(date.today()).strftime("%m/%d/%Y")}\t\t Accounts Recievable\t\t {self.user}') #Header
        print("\n\n")
        #Print menu options
        menuOptions = "1. Recievables\n2. Bills\n0. Exit\n\n"
        print(menuOptions)

    #determines a good user choice
    def __determineChoice__(self):
        isBad = True
        returned = True
        while(isBad):
            while(isBad):
                try:
                    userChoice = int(input(">>>>:"))
                    isBad = False #break loop
                except:
                    print("Please enter a valid input")
            
            #Router
            if  (userChoice == 1):
                recievables = bills_Recievables.Recievables(self.server)
                recievables.start()
            elif (userChoice  == 2):
                bills = bills_Recievables.Bills(self.server)
                bills.start()
            elif (userChoice == 0):
                returned = False #exit out of current menu 
            else:
                print("Please enter valid menu choice\n")
                isBad = True #needs to ask again
        return returned

    def start(self):
        good = True #used to set if there is an error
        while (good):
            self.__printMenu__()
            good = self.__determineChoice__()

        return good