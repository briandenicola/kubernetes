FROM mcr.microsoft.com/powershell:lts-ubuntu-18.04

RUN apt-get update \
  && apt-get install --no-install-recommends --yes \
    locales \
    curl \
    dnsutils \
    jq \
    netcat-openbsd \
    mongodb-clients \
    mysql-client \
    net-tools \
    redis-tools \
    vim \
    wget \
    python-setuptools \
    ca-certificates

ENTRYPOINT [ "pwsh" ]