# Reduce CPU consumption on Proxmox

1. Login to the Proxmox host via the web interface by pressing on Shell
2. Install the package `cpufrequtils` via `apt install cpufrequtils`
    ```bash
    apt update && apt install cpufrequtils
    ```
3. See available governors via `cpufreq-info -g`
    ```bash
    cpufreq-info -g
    ```
4. See current governor
    ```bash
    cpufreq-info -p
    ``
5. Set the governor to `powersave` via `cpufreq-set -g powersave`
    ```bash
    cpufreq-set -g powersave
    ```
6. Make it persistent
    ```bash
    echo 'GOVERNOR="powersave"' |  tee /etc/default/cpufrequtils
    ```

