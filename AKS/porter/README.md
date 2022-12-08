# ⚠️EXPERIMENTAL ⚠️

# Overview

This repository is a demonstration of AKS with Porter from DevContainers. 
 
* [Porter](https://getporter.org/install/) is orchestration engine to deploy everything required for your application in one command.  
* [DevContainers](https://containers.dev/) build consistent developer environments

# Quicksteps
```
    porter build
    porter credentials create creds.json
    porter credentials apply ./creds.json
    porter install -c dev
    porter upgrade
    porter uninstall
```

# Notes
# Backlog
