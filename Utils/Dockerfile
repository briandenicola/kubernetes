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
    unzip \ 
    slurm 

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin 

RUN curl -sSL https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz -o /tmp/helm.tar.gz  \
    && tar -zxf /tmp/helm.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin \
    && rm -f /tmp/helm.tar.gz \
    && rm -rf /tmp/linux-amd64

RUN curl -sSL https://aka.ms/downloadazcopy-v10-linux -o /tmp/azcopy.tar.gz \
    && tar -xzf /tmp/azcopy.tar.gz -C /tmp \
    && mv /tmp/azcopy_linux_amd64_*/azcopy /usr/local/bin \
    && rm -rf /tmp/azcopy*

RUN curl -Ls "https://github.com/fluxcd/flux2/releases/download/v0.24.1/flux_0.24.1_linux_amd64.tar.gz" -o /tmp/flux2.tar.gz \
    && tar -xf /tmp/flux2.tar.gz -C /tmp \
    && mv /tmp/flux /usr/local/bin \
    && rm -f /tmp/flux.tar.gz 

RUN curl -LS "https://github.com/briandenicola/directory-size/releases/download/3.5.9/directorysize-linux-x64.tar.gz" -o /tmp/ds.tar.gz \
    && tar -xf /tmp/ds.tar.gz -C /tmp \
    && mv /tmp/publish/DirectorySize /usr/local/bin/directorysize \
    && rm -rf /tmp/ds.tar.gz

RUN wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

RUN curl -LO https://github.com/Azure/kubelogin/releases/download/v0.0.10/kubelogin-linux-amd64.zip \
    && unzip kubelogin-linux-amd64.zip \ 
    && chmod +x ./bin/linux_amd64/kubelogin \
    && mv ./bin/linux_amd64/kubelogin  /usr/local/bin \ 
    && rm -rf ./kubelogin-linux-amx64.zip \
    && rm -rf ./bin/linux_amd64

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update \
  && apt-get install --no-install-recommends --yes \
    procmon \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf packages-microsoft-prod.deb


COPY ca-certificates.crt /etc/ssl/certs/

COPY sleep.sh /bin/sleep.sh
RUN chmod a+x /bin/sleep.sh 

ENTRYPOINT ["/bin/sleep.sh"]
