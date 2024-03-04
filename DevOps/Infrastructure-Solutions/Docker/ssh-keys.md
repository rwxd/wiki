# SSH-Keys in a Dockerfile Build

## Python

```Dockerfile
# install pip requirements
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN : \
	&& eval "$(ssh-agent -s)"\
	&& mkdir -p /root/.ssh \
	&& chmod 0700 /root/.ssh \
	&& echo ${GITLAB_SSH_PRIVATE_KEY} | base64 -d >> /root/.ssh/id_rsa \
	&& chmod 0700 /root/.ssh/id_rsa \
	&& ssh-add /root/.ssh/id_rsa \
	&& ssh-keyscan gitlab.com >> /root/.ssh/known_hosts \
	&& chmod 0644 /root/.ssh/known_hosts \
	&& python3 -m venv /venv \
	&& python3 -m pip install --no-cache-dir -r requirements.txt \
	&& rm -f /root/.ssh/id_rsa
