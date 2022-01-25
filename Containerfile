FROM docker.io/ubuntu:focal

RUN : \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    python3 \
    python3-venv \
    python3-pip \
    nodejs \
    npm \
    # ruby \
    plantuml \
    graphviz \
    curl \
    wget \
    && rm -rf /var/lib/api/lists*

# RUN gem install mdl

# To handle 'not get uid/gid'
RUN npm config set unsafe-perm true

RUN npm install --global \
    markdownlint@0.17.2 \
    markdownlint-cli@0.19.0

WORKDIR /src

COPY requirements.txt .
ENV PATH = /venv/bin:$PATH

RUN : \
    && python3 -m venv /venv \
    && python3 -m pip --no-cache-dir install -r requirements.txt

# download newest plantuml
# RUN find / -name "plantuml.jar"
RUN wget https://deac-ams.dl.sourceforge.net/project/plantuml/plantuml.jar -O /usr/share/plantuml/plantuml.jar -q
RUN du -sh /usr/share/plantuml/*


COPY . .
