# ⚠️In Progress ⚠️

# Overview

This repository is a demonstration of Porter, 
 
* [Porter](https://getporter.org/install/) is CNAB to package your application and an engine to deploy everything required for your application in one command.  
* [CNAB](https://cnab.io/) facilitate the bundling, installing and managing of container-native apps — and their coupled services.

# Quicksteps
## Install Porter
```bash
    export VERSION="v1.0.8"
    curl -L https://cdn.porter.sh/$VERSION/install-linux.sh | bash
    porter mixin install az
    porter mixin install terraform
    porter mixin install exec
    porter mixin install kubernetes

```
## Deploy a simple Application
```bash
    porter build
    porter credentials create creds.json
    porter credentials apply ./creds.json
    porter install -c dev
    porter upgrade
    porter uninstall
```

# Notes
# Backlog
