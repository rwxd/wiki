# Show window names

Run the following command, after that click on a window to see its name

```bash
xprop | grep "NAME"
```

## Example

```bash
❯ xprop | grep "NAME"
WM_NAME(STRING) = "Spotify"
_NET_WM_NAME(UTF8_STRING) = "Spotify"
```
