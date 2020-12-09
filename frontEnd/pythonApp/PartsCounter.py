from clear import clear
from datetime import date
from server import server
from EndPoints import Invoices, PartsLookUp, Quotes, WorkOrders, History

class PartsCounterMenu:

    def __init__(self, server):
        self.server = server
        self.user = server.get_user()

    #helper function for start
    def __printMainMenu__(self):
        clear()
        print(f'{(date.today()).strftime("%m/%d/%Y")}\t\t Parts Counter Menu\t\t {self.user}') #Header
        print("\n\n")
        #Print menu options
        menuOptions = "1. Invoices\n2. Parts Look-Up\n3. Quotes\n4. Work Orders\n5. History\n0. Exit\n\n"
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
                Inv = Invoices(self.server)
                Inv.start()
            elif (userChoice  == 2):
                PLU = PartsLookUp(self.server)
                PLU.start()
            elif (userChoice == 3):
                quotes = Quotes(self.server)
                quotes.start()
            elif (userChoice == 4):
                workOrders = WorkOrders(self.server)
                workOrders.start()
            elif (userChoice == 5):
                history = History(self.server)
                history.start()
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

        

