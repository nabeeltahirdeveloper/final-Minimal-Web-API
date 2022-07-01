#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base

# RUN apt-get install -y libgdiplus
# RUN apt-get install -y libfontconfig1
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["DocumentEditorCore.csproj", "."]
RUN dotnet restore "./DocumentEditorCore.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DocumentEditorCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DocumentEditorCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DocumentEditorCore.dll"]