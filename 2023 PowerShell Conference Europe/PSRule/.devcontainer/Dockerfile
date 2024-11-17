FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

RUN apt-get update && apt-get -y upgrade

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
	curl \
    && rm -rf /var/lib/apt/lists/*

# Latest Bicep CLI
RUN wget https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64 -O /usr/local/bin/bicep
RUN chmod +x /usr/local/bin/bicep

RUN useradd --create-home vscode

RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v19.24.3/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
RUN chmod +x /usr/local/bin/oh-my-posh

# Switch to non-root user:
WORKDIR /home/vscode
USER vscode