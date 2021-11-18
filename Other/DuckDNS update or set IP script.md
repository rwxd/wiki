```python
import json
import urllib.request as requests

config = {
    "token": "blabla",
    "duck_domain": "cloud-test",
    "ipv4": True,
    "ipv6": True
    }

ipv4URL = 'https://ipv4.ipleak.net/json/'
ipv6URL = 'https://ipv6.ipleak.net/json/'

if config["ipv4"]:
    request = requests.urlopen(ipv4URL)
    data = json.load(request)
    print(f'IPv4: {json.dumps(data["ip"], indent=2)}')

    request = requests.urlopen(f'https://www.duckdns.org/update?domains={config["duck_domain"]}&token={config["token"]}&ip={data["ip"]}')
    if request.status != 200:
        print(request.msg)


if config["ipv6"]:
    request = requests.urlopen(ipv6URL)
    data = json.load(request)
    print(f'IPv6: {json.dumps(data["ip"], indent=2)}')
    
    request = requests.urlopen(f'https://www.duckdns.org/update?domains={config["duck_domain"]}&token={config["token"]}&ipv6={data["ip"]}')
    if request.status != 200:
        print(request.msg)
```
