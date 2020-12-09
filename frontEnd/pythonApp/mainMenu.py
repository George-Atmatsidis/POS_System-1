from clear import clear
from datetime import date
from server import server
from EndPoints import Recievables, CustomerManagement, EmployeeManagement
import Inventory
import PartsCounter

class MainMenu:

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
                Rec = Recievables(self.server)
                Rec.start()
            elif (userChoice  == 2):
                IM = Inventory.InventoryMenu(self.server)
                IM.start()
            elif (userChoice == 3):
                CustM = CustomerManagement(self.server)
                CustM.start()
            elif (userChoice == 4):
                EmpM = EmployeeManagement(self.server)
                EmpM.start()
            elif (userChoice == 5):
                PC = PartsCounter.PartsCounterMenu(self.server)
                PC.start()
            elif (userChoice == 0):
                returned = False #exit out of current menu 
            else:
                print("Please enter valid menu choice\n")
                isBad = True #needs to ask again
        return returned

    def start(self):
        good = True #used to set if there is an error
        while (good):
            self.__printMainMenu__()
            good = self.__determineChoice__()

        return good

        

