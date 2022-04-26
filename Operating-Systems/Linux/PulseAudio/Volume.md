# PulseAudio Volume Stuff
## Find devices
`$(pacmd list-sinks && pacmd list-sinks && pacmd list-sources) | grep "name:"`

## Raise microphone volume with pacmd
`pacmd set-source-volume alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo 0x25000`