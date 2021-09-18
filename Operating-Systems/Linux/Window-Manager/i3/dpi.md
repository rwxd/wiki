# Change i3 DPI

put the following configuration into `~/.Xresources`  
```
Xft.dpi: 150
```

load settings  
```
xrdb -merge ~/.Xresources
exec i3
```
