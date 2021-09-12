# Script to clear GitLab CI/CD Artifacts

```python
import requests
import json

class BearerAuth(requests.auth.AuthBase):
    def __init__(self, token):
        self.token = token
    def __call__(self, r):
        r.headers["authorization"] = "Bearer " + self.token
        return r

project = '804'
token='ijuiosjdiof'

for page in range(1, 200):
    url = f'https://gitlab.com/api/v4/projects/{project}/jobs?per_page=100&page={page}'
    print(f'Getting jobs from {url}')
    response = requests.get(url, auth=BearerAuth(token))

    data= json.loads(response.text)

    for item in data:
        url=f'https://gitlab.com/api/v4/projects/{project}/jobs/{item["id"]}/artifacts'
        print(f'Running on {url}')
        response = requests.delete(url, auth=BearerAuth(token))
```
