FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["SampleCSharpDockerProject/SampleCSharpDockerProject.csproj", "SampleCSharpDockerProject/"]
RUN dotnet restore "SampleCSharpDockerProject/SampleCSharpDockerProject.csproj"
COPY . .
WORKDIR "/src/SampleCSharpDockerProject"
RUN dotnet build "SampleCSharpDockerProject.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SampleCSharpDockerProject.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SampleCSharpDockerProject.dll"]