# Show content of a JWT token

```bash
jwt="ey...."
jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$jwt"
```
