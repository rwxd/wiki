# Change Spotify Theme with spicetify-cli

## Install

Arch  
`yay -S spicetify-cli`

## usage

generate config  
`spicetify`

apply config
```
spicetify backup apply
spicetify apply
```

change theme  
`spicetify config current_theme THEME_NAME`

change color scheme  
`spicetify config color_scheme SCHEME_NAME`

## help
when Spotify is installed through AUR
```
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
```

## Links

- [spicetify-cli](https://github.com/khanhas/spicetify-cli/)
- [spicetify themes](https://github.com/morpheusthewhite/spicetify-themes/tree/master)