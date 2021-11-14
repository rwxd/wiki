# X-Forwarding with Windows

## Setup

Install [VcXsrv](https://sourceforge.net/projects/vcxsrv/)

Start `XLaunch` with enabled clipboard and monitor 0

Set the Windows environment variable `DISPLAY="127.0.0.1:1.0"`

Connect through SSH with the `-Y` argument. 

Linux script to check working connection.

```bash
#!/usr/bin/env bash

if ! timeout 3s xset q &>/dev/null; then
    echo "No X server at \$DISPLAY [$DISPLAY]" >&2
    exit 1
fi

echo "Seems to work :)"
```
