ARG VARIANT="8.0-bullseye-slim"
FROM mcr.microsoft.com/vscode/devcontainers/dotnet:${VARIANT}

ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi