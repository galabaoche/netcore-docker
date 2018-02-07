FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# 拷贝.csproj到工作目录/app，然后执行dotnet restore恢复所有安装的NuGet包。
COPY *.csproj ./
RUN dotnet restore

# 拷贝所有文件到工作目录(/app)，然后执行dotnet publish命令将应用发布到/app/out目录下
COPY . ./
RUN dotnet publish -c Release -o out

# 编译Docker镜像
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/out .
ENV ASPNETCORE_URLS http://0.0.0.0:3721
ENTRYPOINT ["dotnet", "helloworld.dll"]