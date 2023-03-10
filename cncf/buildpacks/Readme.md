⚠️In Progress ⚠️
# Overview

This repository is a demonstration of CLoud Native Build Packs as a replacement for Dockerfile
 
* [Cloud Native Buildpacks](https://buildpacks.io) are an alternative to Dockerfile for building OCI-compliant containers.
    * One major advantage of Buildpacks over Dockerfile is that you can patch one layer without invalidating all other layers. So you can patch an OS bug without requiring a recompile of the app
* [paketo](https://paketo.io/docs/) provides production-ready buildpacks for the most popular languages and frameworks.
* [Bill of Materials](https://paketo.io/docs/concepts/sbom/)

# Install Cli
* [pack](https://github.com/briandenicola/tooling/blob/main/pack.sh) cli 

# Quicksteps
```bash
pack config default-builder paketobuildpacks/builder:base
pack build bjdcsa.azurecr.io/dotnet-sample:v1.0 --path ./src --buildpack paketo-buildpacks/dotnet-core --env BP_DOTNET_PUBLISH_FLAGS="--self-contained=true  --nologo"
docker run -d -p 8080:8080 -e PORT=8080 bjdcsa.azurecr.io/dotnet-sample:v1.0
curl http://localhost:8080/weatherforecast -vvv
```

# Inspect an Image
```bash
* pack inspect-image paketo-demo-app1
Inspecting image: paketo-demo-app1

REMOTE:
(not present)

LOCAL:

Stack: io.buildpacks.stacks.bionic

Base Image:
  Reference: ac36e9dcf1630b44ac600b35d7f1eea59759c4412f6b0d9c86bc91ef2ff53dd3
  Top Layer: sha256:00da7bc7bae660bfa8917465b30f9a069befebd5edf52d4a92f07e465445c759

Run Images:
  index.docker.io/paketobuildpacks/run:base-cnb
  gcr.io/paketo-buildpacks/run:base-cnb

Buildpacks:
  ID                                                  VERSION        HOMEPAGE
  paketo-buildpacks/ca-certificates                   3.5.1          https://github.com/paketo-buildpacks/ca-certificates
  paketo-buildpacks/dotnet-core-sdk                   0.13.1         https://github.com/paketo-buildpacks/dotnet-core-sdk
  paketo-buildpacks/icu                               0.6.2          https://github.com/paketo-buildpacks/icu
  paketo-buildpacks/dotnet-publish                    0.12.1         https://github.com/paketo-buildpacks/dotnet-publish
  paketo-buildpacks/dotnet-core-aspnet-runtime        0.3.2          https://github.com/paketo-buildpacks/dotnet-core-aspnet-runtime
  paketo-buildpacks/dotnet-execute                    0.14.1         https://github.com/paketo-buildpacks/dotnet-execute

Processes:
  TYPE                        SHELL        COMMAND                      ARGS        WORK DIR
  buildpacks (default)                     /workspace/buildpacks                    /workspace
```

# Other Commands
* pack builder inspect cnbs/sample-builder:bionic

# Links
* https://buildpacks.io/docs/concepts/
* https://technology.doximity.com/articles/buildpacks-vs-dockerfiles
* https://buildpacks.io/docs/buildpack-author-guide/create-buildpack/
* https://www.youtube.com/watch?v=ofH9_sE2qy0
* https://buildpacks.io/docs/concepts/components/lifecycle/
