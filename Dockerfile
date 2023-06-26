FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy all files and build the project
COPY . ./
RUN dotnet build -c Release --no-restore

# Publish the project
RUN dotnet pack -c Release --no-build -o out

# Push to NuGet, you need to pass your NuGet API Key as a build argument
ARG NUGET_API_KEY
ENV NUGET_API_KEY=${NUGET_API_KEY}

# The source could be a private NuGet feed URL if required
ENV NUGET_SOURCE="https://api.nuget.org/v3/index.json"

RUN dotnet nuget push out/*.nupkg --source "${NUGET_SOURCE}" --api-key "${NUGET_API_KEY}" --skip-duplicate
