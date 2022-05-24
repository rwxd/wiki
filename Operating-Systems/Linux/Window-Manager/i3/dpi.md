# Change i3 DPI / scaling

put the following configuration into `~/.Xresources`

```
Xft.dpi: 150
```

load settings
```
xrdb -merge ~/.Xresources
exec i3
```
