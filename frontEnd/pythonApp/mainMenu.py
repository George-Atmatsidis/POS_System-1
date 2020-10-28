from clear import clear
from datetime import datetime


#helper function for main menu
def printMainMenu(user):
    print(f'{(datetime.now()).strftime("%m/%d/%Y %H:%M:%S")}\t\t Main Menu\t\t {user}') #Header
    print("\n\n")
    #Print menu options
    menuOptions = "1. Accounts Recievable\n2. Inventory Management\n3. Customer Management\n4. Employee Management\n5. Parts Counter Menu\n\n"
    print(menuOptions)

#main menu screen functionality
#returns if the program was exectued succesfully
def mainMenu(user):
    clear()
    printMainMenu(user)
    input(">>>>:")
    good = True #used to set if there is an error
    return good

