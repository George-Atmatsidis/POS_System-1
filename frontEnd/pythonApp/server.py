#server class wraps requests in order to simplify calls
import requests
from json import loads

class server():
    def __init__(self, host):
        self.host = host
        self.header =  { 'content-type': 'application/json' }
        self.session = requests.Session()

    def set_user(self, user):
        self.user = user
        return user

    def get_user(self):
        return self.user

    def get(self, route, data):
        response = self.session.get(self.host+route, data=data, headers=self.header)
        #test wether the get request succeeded
        if (response):
            try:
                response = loads(response.content)
            except ValueError:
                print("no content")
        else:
            raise ConnectionError("PUT request failed")
        return response

    def put(self, route, data):
        response = self.session.put(self.host+route, data=data, headers=self.header)
        if (response):
            try:
                response = loads(response.content)
            except ValueError:
                print("no content")
        else:
            raise ConnectionError("PUT request failed")
        return response

    def post(self, route, data):
        response = self.session.post(self.host+route, data=data, headers=self.header)
        if (response):
            try:
                response = loads(response.content)
            except ValueError:
                print("no content")
        else:
            raise ConnectionError("POST request failed")
        return response