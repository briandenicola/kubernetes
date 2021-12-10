FROM mcr.microsoft.com/azure-powershell:latest

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
    iproute2 \
    nmap \
    python3 \
    python3-pip \
    traceroute \
    netcat \
    ca-certificates  \
    nmon \ 
    slurm 

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin

RUN curl -sSL https://aka.ms/downloadazcopy-v10-linux -o /tmp/azcopy.tar.gz \
    && tar -xzf /tmp/azcopy.tar.gz -C /tmp \
    && mv /tmp/azcopy_linux_amd64_*/azcopy /usr/local/bin \
    && rm -rf /tmp/azcopy*

RUN curl -Ls "https://github.com/fluxcd/flux2/releases/download/v0.24.1/flux_0.24.1_linux_amd64.tar.gz" -o /tmp/flux2.tar.gz \
    && tar -xf /tmp/flux2.tar.gz -C /tmp \
    && mv /tmp/flux /usr/local/bin \
    && rm -f /tmp/flux.tar.gz 

RUN curl -LS "https://github.com/briandenicola/directory-size/releases/download/3.1.4/directorysize-linux-3.1.4.go.tar.gz" -o /tmp/ds.tar.gz \
    && tar -xf /tmp/ds.tar.gz -C /tmp \
    && mv /tmp/directorysize /usr/local/bin/directorysize \
    && rm -rf /tmp/ds.tar.gz

RUN wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update \
  && apt-get install --no-install-recommends --yes \
    procmon \
  && rm -rf /var/lib/apt/lists/*

COPY sleep.sh /bin/sleep.sh
ENTRYPOINT ["/bin/sleep.sh"]
