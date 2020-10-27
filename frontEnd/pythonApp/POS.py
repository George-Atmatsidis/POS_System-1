import json
import requests
host = 'http://localhost:3000'
header = { 'content-type': 'application/json' }

userinput = input("Enter your name: ")


#test GET request
r = requests.get(host)
r = json.loads(r.json())
#print(r["name"])

#test PUT request
payload = {
    "name": userinput,
}

payload = json.dumps(payload)
r = requests.put(host, data=payload, headers=header)
print(r.text)