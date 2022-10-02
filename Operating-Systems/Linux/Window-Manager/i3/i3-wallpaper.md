# Wallpaper in i3

[feh](https://wiki.archlinux.org/title/feh) can be used to display a wallpaper.

Define the following in the i3 config file to use a random wallpaper from the path `~/wallpaper/`.

```bash
exec --no-startup-id feh --bg-scale --random ~/wallpaper/
```
