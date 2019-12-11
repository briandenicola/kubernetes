
Writ-Host "Cerating Azure ACR Build Task"

az acr task create -n base-w2k19 -r bjd145 `
    -t windows/bjdbasewindows2019:ltsc2019 `
    -f ACR/Dockerfile.base                 `
    --platform windows                     `
    --context https://github.com/bjd145/Kubernetes.git `
    --commit-trigger-enabled false         `
    --pull-request-trigger-enabled false