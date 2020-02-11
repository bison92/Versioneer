FROM node:lts-buster AS node-build-env
# First do yarn things so we can cache them 
WORKDIR /client
COPY client/package.json client/yarn.lock ./
RUN yarn install 
COPY client/. ./
RUN yarn build
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app
# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else (but the client) and build
COPY . ./
RUN rm -rf ./client
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app/client/build
COPY --from=node-build-env /client/build ./
WORKDIR /app
COPY --from=build-env /app/out .
EXPOSE 80
ENTRYPOINT ["dotnet", "Versioneer.ClientHost.dll"]
