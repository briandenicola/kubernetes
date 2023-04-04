FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /src

COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o publish/linux --no-restore

FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.0
WORKDIR /app
COPY --from=build-env /src/publish/linux/otel-prometheus .
ENTRYPOINT ["/app/otel-prometheus"]