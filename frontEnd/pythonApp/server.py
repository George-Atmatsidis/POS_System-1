#server class wraps requests in order to simplify calls
import requests
import json

class server:
    def __init__(self, host):
        self.host = host
        self.header =  { 'content-type': 'application/json' }
        self.session = requests.Session()

    def set_user(self, user):
        self.user = user
        return user

    def get_user(self):
        return self.user

    def get(self, route, data=None):
        if(data):
            response = self.session.get(self.host+route, data=data, headers=self.header)
        else: #no data to pass
            response = self.session.get(self.host+route, headers=self.header)
        #test wether the get request succeeded
        if (response):
            try:
                response = json.loads(response.content)
            except json.decoder.JSONDecodeError as e:
                if (e.msg == "Extra data error"): #process multiple data entries
                    response = []
                    for jsonObj in response.content:
                        jsondict = json.loads(jsonObj)
                        response.append(jsondict)
        else:
            raise ConnectionError("PUT request failed")
        return response

    def put(self, route, data):
        response = self.session.put(self.host+route, data=data, headers=self.header)
        if (response):
            try:
                response = json.loads(response.content)
            except json.decoder.JSONDecodeError as e:
                if (e.msg == "Extra data error"): #process multiple data entries
                    response = []
                    for jsonObj in response.content:
                        jsondict = json.loads(jsonObj)
                        response.append(jsondict)
        else:
            raise ConnectionError("PUT request failed")
        return response

    def post(self, route, data):
        response = self.session.post(self.host+route, data=data, headers=self.header)
        if (response):
            try:
                response = json.loads(response.content)
            except json.decoder.JSONDecodeError as e:
                if (e.msg == "Extra data error"): #process multiple data entries
                    response = []
                    for jsonObj in response.content:
                        jsondict = json.loads(jsonObj)
                        response.append(jsondict)
        else:
            raise ConnectionError("POST request failed")
        return response