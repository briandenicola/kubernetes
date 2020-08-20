FROM mcr.microsoft.com/powershell:lts-ubuntu-18.04

RUN apt-get update \
  && apt-get install --no-install-recommends --yes \
    locales \
    curl \
    git \
    dnsutils \
    jq \
    net-tools \
    redis-tools \
    vim \
    wget \
    python3 \
    python3-pip \
    traceroute \
    netcat \
    ca-certificates  \
  && rm -rf /var/lib/apt/lists/*

COPY sleep.sh /bin/sleep.sh
ENTRYPOINT ["/bin/sleep.sh"]
