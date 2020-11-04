#server class wraps requests in order to simplify calls
import requests
from json import loads

class server():
    def __init__(self, host):
        self.host = host
        self.header =  { 'content-type': 'application/json' }

    def get(self, route, data):
        response = requests.get(self.host+route, data=data, headers=self.header)
        #test wether the get request succeeded
        if (response):
            response = loads(response.content)
        else:
            raise ConnectionError("GET request failed")
        return response

    def put(self, route, data):
        response = requests.put(self.host+route, data=data, headers=self.header)
        if (response):
            response = loads(response.content)
        else:
            raise ConnectionError("PUT request failed")
        return response