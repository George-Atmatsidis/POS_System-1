##################
# This file will contain all the program end points
# For example Recievables, Parts management, class management
# This will implement all those implements that was to reduce the memory footprint
# This contains most of the internal working of the application
##################

from server import server
from clear import clear
from datetime import date
from tabulate import tabulate
from time import sleep
from json import dumps



#recievables object that runs the page for managing recievables
#posts payments and displays the recievables out
class Recievables:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        self.Refresh()
        #Get user's choice either post or refresh
        good = True
        while (good):
            self.__printMenu__()
            good = self.__determineChoice__()

    def __printHeader__(self):
        clear()
        print(f'{(date.today()).strftime("%m/%d/%Y")}\t\t Accounts Recievable\t\t {self.user}') #Header
        print("\n\n")

    def __printMenu__(self):
        #Print menu options
        menuOptions = "1. Post Payment    2. Refresh    0. Exit\n"
        print(menuOptions)

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
            if  (userChoice == 1): #post payment
                self.postPayment()
            elif (userChoice  == 2): #refresh selection
                self.Refresh()
            elif (userChoice == 0):
                returned = False #exit out of current menu 
            else:
                print("Please enter valid menu choice\n")
                isBad = True #needs to ask again
        return returned

    def postPayment(self):
        AccountNumber = input("Account Number: ")
        isBad = True
        while(isBad):
            try:
                AmountPaid = float(input("Amount Paid: "))
                isBad = False #break loop
            except:
                print("Please enter a valid input")
        payload = {
            "AccountNumber":AccountNumber,
            "AmountPaid":AmountPaid
        }
        payload = dumps(payload)
        res = self.server.put(route="/accountsRecievable/paid", data=payload)
        if (res.status_code == 200):
            print("Amount posted SUCCESFULLY\n")
        else:
            print("Posting UNSUCCESSFUL({})".format(res.status_code))
        sleep(2)
        self.Refresh()
        
    def Refresh(self):
        clear()
        #should return a list of dictionaries: one for each recievable
        #res is a list of dictionaries
        res = self.server.get(route="/accountsRecievable")
        #need to seperate the responses
        header = res[0].keys()
        rows = [x.values() for x in res]
        self.__printHeader__()
        print(tabulate(rows, header))
        print("\n")

class PartsManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        self.__printHeader__()
        print("Input 'X' for adding a new part\n'*' represents an anything character in pattern")
        pattern = input(">>>>:")
        if (pattern == 'X' or pattern == 'x'):
            partNumber = input("PartNumber:")
            description = input("Description:")
            quantity = int(input("Quantity:"))
            quanOO = int(input("Quantity On Order:"))
            price = float(input("Price:"))
            brand = input("Brand:")
            cost = float(input("Cost:"))
            source = input("Source:")
            classID = int(input("Class ID:"))
            payload = {
                "PartNumber":partNumber,
                "Description":description,
                "Quantity":quantity,
                "QuantityOO":quanOO,
                "Price":price,
                "Brand":brand,
                "Cost":cost,
                "Source":source,
                "ClassID":classID
            }
            payload = dumps(payload)
            res = self.server.put(route="/inventoryManagement/partsManagement/add", data=payload)
            if(res.status_code == 201):
                print("Part Posted")
            else:
                print("FAILED")
            sleep(2)

        else:
            payload = {"PartNumberPattern":pattern}
            payload = dumps(payload)
            res = self.server.get(route="/inventoryManagement/partsManagement", data=payload)
            header = res[0].keys()
            rows = [x.values() for x in res]
            print(tabulate(rows, header))
            print("Done")
            input() #wait for user to be done with results

    def __printHeader__(self):
        clear()
        print(f'{(date.today()).strftime("%m/%d/%Y")}\t\t Parts Management\t\t {self.user}') #Header
        print("\n")
        

class ClassManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Class Management\n")
        sleep(2)

class CustomerManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Customer Management\n")
        sleep(2)

class EmployeeManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Employee Management\n")
        sleep(2)

class Invoices:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Invoices\n")
        sleep(2)

class PartsLookUp:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Parts Look Up\n")
        sleep(2)

class Quotes:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Quotes\n")
        sleep(2)

class WorkOrders:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in Work Orders\n")
        sleep(2)

class History:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        print("You are in History\n")
        sleep(2)

