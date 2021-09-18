# Wallpaper in i3

nitrogen can be used to define a wallpaper.

define the following in the i3 config file  
`exec --no-startup-id nitrogen --set-auto /path/wallpaper.jpg`

multiple monitors can be used with the following  
`exec --no-startup-id nitrogen --set-auto /path/wallpaper.jpg --head=0 && nitrogen --set-auto /path/wallpaper.jpg --head=1`

with the `--random` parameter, a random wallpaper will be chosen from a directory