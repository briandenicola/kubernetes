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
  && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN  dpkg -i packages-microsoft-prod.deb
RUN  apt-get update \ 
  && apt-get install procmon

COPY sleep.sh /bin/sleep.sh
ENTRYPOINT ["/bin/sleep.sh"]
