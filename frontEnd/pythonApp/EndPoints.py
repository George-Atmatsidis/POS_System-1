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

def displayDataTable(data):
    header = data[0].keys()
    rows = [x.values() for x in data]
    print(tabulate(rows, header))
    print("\n")

def printHeader(title, user):
    clear()
    print(f'{(date.today()).strftime("%m/%d/%Y")}\t\t {title}\t\t {user}') #Header
    print("\n")

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
        printHeader("Accounts Recievable", self.user)
        print(tabulate(rows, header))
        print("\n")

class PartsManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Parts Management", self.user)
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
            displayDataTable(res)
            print("Done")
            input() #wait for user to be done with results

class ClassManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        self.refresh()
        isbad = True
        while(isbad):
            print("Enter 'E' to edit, 'X' to exit")
            userInput = input(">>>>:")
            if (userInput == 'e' or userInput == 'E'):
                classID = input("ClassID:")
                description = input("Description:")
                marg1 = float(input("Margin 1:"))
                marg2 = float(input("Margin 2:"))
                marg3 = float(input("Margin 3:"))
                payload = {
                    "ClassID":classID,
                    "ClassDescr":description,
                    "Margin1":marg1,
                    "Margin2":marg2,
                    "Margin3":marg3
                }
                payload = dumps(payload)
                res = self.server.post("/inventoryManagement/classmanagement/update", data=payload)
                if (res.status_code == 200):
                    print("UPDATE SUCCESSFUL")
                else:
                    print("UPDATE FAILED")
                sleep(2)
                self.refresh()
            elif(userInput == 'x' or userInput == 'X'):
                isbad = False #exit the loop and then exit the endpoint
            else:
                print("Bad Input")
    
    def refresh(self):
        clear()
        printHeader("Class Management", self.user)
        res = self.server.get("/inventoryManagement/classManagement")
        displayDataTable(res)

        
    

class CustomerManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Customer Management", self.user)
        print("Enter 'S' for selecting\t 'X' for new\n'*' represents an anything character in pattern")
        pattern = input(">>>>:")
        if(pattern == 'S' or pattern == 's'): #get details of current customer
            custID = int(input("Customer ID:"))
            payload = {
                "ID":custID
            }
            payload = dumps(payload)
            res = self.server.get("/customerManagement/detailed", data=payload)
            clear()
            print("Name:  ", res["Name"])
            print("Address: ", res["Addr"])
            print("Phone: ", res["Phone"])
            print("Billing Address: ", res["BillingAddr"])
            print("Shipping Address: ", res["ShippingAddr"])
            print("City Tax: ", res["CityTax"])
            print("State Tax: ", res["StateTax"])
            print("Federal Tax: ", res["FederalTax"])
            print("Charge Limit: ", res["ChargeMax"])
            print("Current Charges: ", res["CurrentCharge"], "\n")
            input("Press enter when done")
        elif (pattern == 'X' or pattern == 'x'): #create new customer
            name = input("Full Name:")
            addr = input("Address:")
            phone = input("Phone Number:")
            billing = input("Billing Address:")
            shipping = input("Shipping Address:")
            city = input("City Tax Rate:")
            state = input("State Tax Rate:")
            federal = input("Federal Tax Rate:")
            chargeLimit = input("Account Credit Limit:")
            charges = input("Current Charges Total:")
            payload = {
                "Name":name,
                "Addr": addr,
                "Phone": phone,
                "BillingAddr":billing,
                "ShippingAddr":shipping,
                "CityTax":city,
                "StateTax":state,
                "FederalTax":federal,
                "ChargeMax":chargeLimit,
                "CurrentCharge":charges
            }
            payload = dumps(payload)
            res = self.server.put(route="/customerManagement/add", data=payload)
            if(res.status_code == 200):
                print("Customer Added")
            else:
                print("FAILED")
            sleep(2)

        else: #query customer DB
            payload = {"Name":pattern}
            payload = dumps(payload)
            res = self.server.get(route="/customerManagement", data=payload)
            displayDataTable(res)
            print("Done")
            input() #wait for user to be done with results

class EmployeeManagement:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Employee Management", self.user)
        print("Enter 'S' for selecting\t 'X' for new\n'*' represents an anything character in pattern")
        pattern = input(">>>>:")
        if(pattern == 'S' or pattern == 's'): #get details of current employee
            empID = int(input("Employee ID:"))
            payload = {
                "ID":empID
            }
            payload = dumps(payload)
            res = self.server.get("/employeeManagement/detailed", data=payload)
            clear()
            print("Name:  ", res["Name"])
            print("Address: ", res["Addr"])
            print("Phone: ", res["Phone"])
            print("Pay: ", res["Pay"])
            input("Press enter when done")
        elif (pattern == 'X' or pattern == 'x'): #create new customer
            name = input("Full Name:")
            addr = input("Address:")
            phone = input("Phone Number:")
            pay = input("Pay:")
            payload = {
                "Name":name,
                "Addr": addr,
                "Phone": phone,
                "Pay":pay
            }
            payload = dumps(payload)
            res = self.server.put(route="/employeeManagement/add", data=payload)
            if(res.status_code == 200):
                print("Employee Added")
            else:
                print("FAILED")
            sleep(2)

        else: #query customer DB
            payload = {"Name":pattern}
            payload = dumps(payload)
            res = self.server.get(route="/employeeManagement", data=payload)
            displayDataTable(res)
            print("Done")
            input() #wait for user to be done with results

#Work orders and quotes are copied and pasted from invoice. The interface is exactly the same
class Invoices:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Invoices", self.user)
        print("'X' for new, 'S' for selecting invoice, Pattern for search")
        userInput = input(">>>>:")
        if(userInput == 'S' or userInput == 's'): #returns detailed info about invoice
            userInput = int(input("Invoice ID: "))
            clear()
            payload = { "ID":userInput }
            payload = dumps(payload)
            invoiceRes = self.server.get("/partsCounter/invoice", data=payload)
            payload = {
                "ID":invoiceRes["CustomerID"]
            }
            payload = dumps(payload)
            customerRes = self.server.get("/customerManagement/detailed", data=payload)
            payload = {
                "ID":invoiceRes["EmployeeID"]
            }
            payload = dumps(payload)
            employeeRes = self.server.get("/employeeManagement/detailed", data=payload)
            #now that I have all the data I need to display it
            print("ID: ", invoiceRes["ID"])
            print("Date Created: ", invoiceRes["Date"])
            print("Name:  ", customerRes["Name"])
            print("Address: ", customerRes["Addr"])
            print("Phone: ", customerRes["Phone"])
            print("Billing Address: ", customerRes["BillingAddr"])
            print("Shipping Address: ", customerRes["ShippingAddr"])
            print("Employee: ", employeeRes["Name"], "\n")
            displayDataTable(invoiceRes["PartsList"])
            print("Sub-Total: ".rjust(50), invoiceRes["SubTotal"])
            print("Tax-Total: ".rjust(50), invoiceRes["TaxTotal"])
            print("Total: ".rjust(50), invoiceRes["Total"])
            input("Press enter when done")

        elif(userInput == 'x' or userInput == 'X'): #user wants to create a new invoice
            good = True
            while(good):
                clear()
                userInput = int(input("Customer ID:"))
                customerID = userInput
                payload = { "CustomerID":userInput }
                payload = dumps(payload)
                customerInfo = self.server.get("/partsCounter/invoice/add", data=payload)
                print("Name:  ", customerInfo["Name"])
                userInput = input("Is this correct? (Y or N):")
                if(userInput == 'y' or userInput == 'Y'):
                    good = False # don't ask again
                
            partsList = []
            print("Parts List")
            while(True):
                part = input("Part Number(input X to exit):")
                if(part == 'x' or part == 'X'):
                    break #exit loop
                payload = { "PartNumber":part }
                payload = dumps(payload)
                partRes = self.server.get("/partsCounter/invoice/add", data=payload)
                print("\tDescription:", partRes["Description"], "\tPrice:", partRes["Cost"]*(partRes["PriceM3"]/100), end="\t")
                quantity = int(input("Quantity:"))
                while (quantity > partRes["Quantity"] or quantity <= 0):
                    if(quantity > partRes["Quantity"]):
                        print("Not enough stock")
                    else:
                        print("Invalid Input(Cannot input 0 for quantity)")
                    quantity = int(input("Quantity:"))
                partsList.append({ "PartNumber":part, "Description":partRes["Description"], "Quantity":quantity, "Price":partRes["Cost"]*(partRes["PriceM3"]/100)})
            payload = { "CustomerID":customerID, "Parts":partsList }
            payload = dumps(payload)
            totals = self.server.get("/partsCounter/invoice/add", data=payload)
            print("Sub-Total: ".rjust(50), float(totals["SubTotal"]))
            print("Tax-Total: ".rjust(50), float(totals["TaxTotal"]))
            print("Total: ".rjust(50), float(totals["Total"]))
            employeeID = input("Enter Employee ID to save and post(X to exit):") #used for confirmation
            if (userInput == "x" or userInput == "X"): 
                print("EXITING WITHOUT SAVING")
                sleep(1)
            else: #upload to server
                payload = {
                    "CustomerID":customerID,
                    "EmployeeID":employeeID,
                    "Parts":partsList,
                    "SubTotal":totals["SubTotal"],
                    "TaxTotal":totals["TaxTotal"],
                    "Total":totals["Total"]
                }
                payload = dumps(payload)
                response = self.server.put("/partsCounter/invoice/add", data=payload)
                if (response.status_code == 200 or response.status_code == 201):
                    clear()
                    print("INVOICE POSTED SUCCESSFULLY")
                    sleep(2)
        else: #user input name
            payload = { "CustomerName":userInput }
            payload = dumps(payload)
            res = self.server.get("partsCounter/invoice", data=payload)
            displayDataTable(res) #display list of invoices with that pattern in name
            input("Press enter when done")


class PartsLookUp:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Parts Look-Up", self.user)
        print("'*' represents an anything character in pattern")
        pattern = input(">>>>:")
        payload = {"PartNumberPattern":pattern}
        payload = dumps(payload)
        res = self.server.get(route="/inventoryManagement/partsManagement", data=payload)
        displayDataTable(res)
        print("Done")
        input() #wait for user to be done with results

class Quotes:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Quote", self.user)
        print("'X' for new, 'S' for selecting invoice, Pattern for search")
        userInput = input(">>>>:")
        if(userInput == 'S' or userInput == 's'): #user input ID to select input
            userInput = int(input("Invoice ID: "))
            clear()
            payload = { "ID":userInput }
            payload = dumps(payload)
            invoiceRes = self.server.get("/partsCounter/quote", data=payload)
            payload = {
                "ID":invoiceRes["CustomerID"]
            }
            payload = dumps(payload)
            customerRes = self.server.get("/customerManagement/detailed", data=payload)
            payload = {
                "ID":invoiceRes["EmployeeID"]
            }
            payload = dumps(payload)
            employeeRes = self.server.get("/employeeManagement/detailed", data=payload)
            #now that I have all the data I need to display it
            print("ID: ", invoiceRes["ID"])
            print("Date Created: ", invoiceRes["Date"])
            print("Name:  ", customerRes["Name"])
            print("Address: ", customerRes["Addr"])
            print("Phone: ", customerRes["Phone"])
            print("Billing Address: ", customerRes["BillingAddr"])
            print("Shipping Address: ", customerRes["ShippingAddr"])
            print("Employee: ", employeeRes["Name"], "\n")
            displayDataTable(invoiceRes["PartsList"])
            print("Sub-Total: ".rjust(50), invoiceRes["SubTotal"])
            print("Tax-Total: ".rjust(50), invoiceRes["TaxTotal"])
            print("Total: ".rjust(50), invoiceRes["Total"])
            input("Press enter when done")

        elif(userInput == 'x' or userInput == 'X'): #user wants to create a new invoice
            good = True
            while(good): #get and check customer ID
                clear()
                userInput = int(input("Customer ID:"))
                customerID = userInput
                payload = { "CustomerID":userInput }
                payload = dumps(payload)
                customerInfo = self.server.get("/partsCounter/quote/add", data=payload)
                print("Name:  ", customerInfo["Name"])
                userInput = input("Is this correct? (Y or N):")
                if(userInput == 'y' or userInput == 'Y'):
                    good = False # don't ask again
                
            partsList = []
            print("Parts List")
            while(True): #create parts list
                part = input("Part Number(input X to exit):")
                if(part == 'x' or part == 'X'):
                    break #exit loop
                payload = { "PartNumber":part }
                payload = dumps(payload)
                partRes = self.server.get("/partsCounter/quote/add", data=payload)
                print("\tDescription:", partRes["Description"], "\tPrice:", partRes["Cost"]*(partRes["PriceM3"]/100), end="\t")
                quantity = int(input("Quantity:"))
                while (quantity > partRes["Quantity"] or quantity <= 0):
                    if(quantity > partRes["Quantity"]):
                        print("Not enough stock")
                    else:
                        print("Invalid Input(Cannot input 0 for quantity)")
                    quantity = int(input("Quantity:"))
                partsList.append({ "PartNumber":part, "Description":partRes["Description"], "Quantity":quantity, "Price":partRes["Cost"]*(partRes["PriceM3"]/100)})
            payload = { "CustomerID":customerID, "Parts":partsList }
            payload = dumps(payload)
            totals = self.server.get("/partsCounter/quote/add", data=payload)
            print("Sub-Total: ".rjust(50), float(totals["SubTotal"]))
            print("Tax-Total: ".rjust(50), float(totals["TaxTotal"]))
            print("Total: ".rjust(50), float(totals["Total"]))
            employeeID = input("Enter Employee ID to save and post(X to quit):") #used for confirmation
            if (userInput == "x" or userInput == "X"): #allows user to not save changes
                print("EXITING WITHOUT SAVING")
                sleep(1)
            else: #upload to server
                payload = {
                    "CustomerID":customerID,
                    "EmployeeID":employeeID,
                    "Parts":partsList,
                    "SubTotal":totals["SubTotal"],
                    "TaxTotal":totals["TaxTotal"],
                    "Total":totals["Total"]
                }
                payload = dumps(payload)
                response = self.server.put("/partsCounter/quote/add", data=payload)
                if (response.status_code == 200 or response.status_code == 201):
                    clear()
                    print("QUOTE POSTED SUCCESSFULLY")
                    sleep(2)
        else: #user input name returns 
            payload = { "CustomerName":userInput }
            payload = dumps(payload)
            res = self.server.get("partsCounter/quote", data=payload)
            displayDataTable(res) #display list of invoices with that pattern in name
            input("Press enter when done")

class WorkOrders:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("Work Order", self.user)
        print("'X' for new, 'S' for selecting invoice, Pattern for search")
        userInput = input(">>>>:")
        if(userInput == 'S' or userInput == 's'): #user input ID
            userInput = int(input("Invoice ID: "))
            clear()
            payload = { "ID":userInput }
            payload = dumps(payload)
            invoiceRes = self.server.get("/partsCounter/workOrder", data=payload)
            payload = {
                "ID":invoiceRes["CustomerID"]
            }
            payload = dumps(payload)
            customerRes = self.server.get("/customerManagement/detailed", data=payload)
            payload = {
                "ID":invoiceRes["EmployeeID"]
            }
            payload = dumps(payload)
            employeeRes = self.server.get("/employeeManagement/detailed", data=payload)
            #now that I have all the data I need to display it
            print("ID: ", invoiceRes["ID"])
            print("Date Created: ", invoiceRes["Date"])
            print("Name:  ", customerRes["Name"])
            print("Address: ", customerRes["Addr"])
            print("Phone: ", customerRes["Phone"])
            print("Billing Address: ", customerRes["BillingAddr"])
            print("Shipping Address: ", customerRes["ShippingAddr"])
            print("Employee: ", employeeRes["Name"], "\n")
            displayDataTable(invoiceRes["PartsList"])
            print("Sub-Total: ".rjust(50), invoiceRes["SubTotal"])
            print("Tax-Total: ".rjust(50), invoiceRes["TaxTotal"])
            print("Total: ".rjust(50), invoiceRes["Total"])
            input("Press enter when done")

        elif(userInput == 'x' or userInput == 'X'): #user wants to create a new invoice
            good = True
            while(good):
                clear()
                userInput = int(input("Customer ID:"))
                customerID = userInput
                payload = { "CustomerID":userInput }
                payload = dumps(payload)
                customerInfo = self.server.get("/partsCounter/workOrder/add", data=payload)
                print("Name:  ", customerInfo["Name"])
                userInput = input("Is this correct? (Y or N):")
                if(userInput == 'y' or userInput == 'Y'):
                    good = False # don't ask again
                
            partsList = []
            print("Parts List")
            while(True):
                part = input("Part Number(input X to exit):")
                if(part == 'x' or part == 'X'):
                    break #exit loop
                payload = { "PartNumber":part }
                payload = dumps(payload)
                partRes = self.server.get("/partsCounter/workOrder/add", data=payload)
                print("\tDescription:", partRes["Description"], "\tPrice:", partRes["Cost"]*(partRes["PriceM3"]/100), end="\t")
                quantity = int(input("Quantity:"))
                while (quantity > partRes["Quantity"] or quantity <= 0):
                    if(quantity > partRes["Quantity"]):
                        print("Not enough stock")
                    else:
                        print("Invalid Input(Cannot input 0 for quantity)")
                    quantity = int(input("Quantity:"))
                partsList.append({ "PartNumber":part, "Description":partRes["Description"], "Quantity":quantity, "Price":partRes["Cost"]*(partRes["PriceM3"]/100)})
            payload = { "CustomerID":customerID, "Parts":partsList }
            payload = dumps(payload)
            totals = self.server.get("/partsCounter/workOrder/add", data=payload)
            print("Sub-Total: ".rjust(50), float(totals["SubTotal"]))
            print("Tax-Total: ".rjust(50), float(totals["TaxTotal"]))
            print("Total: ".rjust(50), float(totals["Total"]))
            employeeID = input("Enter Employee ID to save and post(X to quit):") #used for confirmation
            if (userInput == "x" or userInput == "X"): 
                print("EXITING WITHOUT SAVING")
                sleep(1)
            else: #upload to server
                payload = {
                    "CustomerID":customerID,
                    "EmployeeID":employeeID,
                    "Parts":partsList,
                    "SubTotal":totals["SubTotal"],
                    "TaxTotal":totals["TaxTotal"],
                    "Total":totals["Total"]
                }
                payload = dumps(payload)
                response = self.server.put("/partsCounter/workOrder/add", data=payload)
                if (response.status_code == 200 or response.status_code == 201):
                    clear()
                    print("WORK ORDER POSTED SUCCESSFULLY")
                    sleep(2)
        else: #user input name
            payload = { "CustomerName":userInput }
            payload = dumps(payload)
            res = self.server.get("partsCounter/workOrder", data=payload)
            displayDataTable(res) #display list of invoices with that pattern in name
            input("Press enter when done")

class History:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    
    def start(self):
        printHeader("History", self.user)
        searchType = input("Search Type:")
        cust = input("Customer Name('*' represents an anything character in pattern):")
        partNum = input("Part Number('*' represents an anything character in pattern):")
        date = input("Date:")
        payload = {
            "Type":searchType,
            "Customer":cust,
            "PartNumber":partNum,
            "Date":date
        }
        payload = dumps(payload)
        res = self.server.get("/partsCounter/history", data=payload)
        displayDataTable(res)
        input("Press enter when done")
