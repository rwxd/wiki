#  Wait for a connection after e. g. a reboot

```yaml
- name: Wait for port 22
  wait_for:
    host: "{{ ansible_host }}"
    port: 22
    state: started
	delay: 10
	sleep: 1
	connect_timeout: 5
	timeout: 900
  delegate_to: 127.0.0.1
```
