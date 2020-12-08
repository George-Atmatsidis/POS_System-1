from server import server
from clear import clear
from tabulate import tabulate

#Bills object has all methods needed to run the bills tab
class Bills:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    def start(self):
        pass



#recievables object that runs the page for managing recievables
class Recievables:
    def __init__(self, server):
        self.server = server
        self.user = server.get_user()
        clear()
    def start(self):
        #should return a list of dictionaries: one for each recievable
        #res is a list of dictionaries
        res = self.server.get(route="/accountsRecievable")
        #need to seperate the responses
        header = res[0].keys()
        rows = [x.values() for x in res]
        print(tabulate(rows, header))
        input()
        runningSum = 0
        for entry in res:
            runningSum += entry["AmountOwed"]
        print(runningSum)
        input()
        

