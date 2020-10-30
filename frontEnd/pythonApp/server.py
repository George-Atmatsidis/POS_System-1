#server class wraps requests in order to simplify calls
import requests
from json import loads

class server():
    def __init__(self, host):
        self.host = host
        self.header =  { 'content-type': 'application/json' }

    def get(self, root, data):
        response = requests.get(self.host+root, data=data, headers=self.header)
        #test wether the get request succeeded
        if (response):
            response = loads(response.content)
        else:
            raise ConnectionError("GET request failed")
        return response