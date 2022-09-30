# amd64
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy
# Apple Silicon
#FROM mcr.microsoft.com/dotnet/sdk:6.0.401-bullseye-slim-arm64v8

RUN apt-get update && apt-get -y upgrade

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
	curl \
    libgdiplus \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home vscode

RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v11.1.1/posh-linux-arm64 -O /usr/local/bin/oh-my-posh
RUN chmod +x /usr/local/bin/oh-my-posh

RUN apt-get update;apt-get install openssh-client -y

# ImportExcel prerequsites
RUN apt-get install -y --no-install-recommends libgdiplus libc6-dev

# Switch to non-root user:
WORKDIR /home/vscode
USER vscode

# Not needed when using dotfiles:
# SHELL ["pwsh","-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# RUN mkdir /home/vscode/.config;mkdir /home/vscode/.config/powershell
# RUN Set-Content -Path /home/vscode/.config/powershell/Microsoft.VSCode_profile.ps1 -Value ". /workspaces/contoso/.devcontainer/powershell/profile.ps1"
# RUN Install-Module -Name PSReadLine -Force -AllowPreRelease
# RUN Install-Module PSDepend -Force
# RUN Invoke-PSDepend /workspace/powershell/requirements.psd1 -Force

# Example: https://github.com/janegilring/dotfiles