from server import server
from clear import clear

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
        pass

