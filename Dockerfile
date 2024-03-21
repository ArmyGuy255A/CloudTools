# Use a base image with PowerShell pre-installed
FROM mcr.microsoft.com/powershell:latest

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl unzip git sudo nano make ruby ruby-dev build-essential libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libxshmfence1 libasound2 bash-completion apt-transport-https ca-certificates gnupg lsb-release python3 python-pip

# Prettify the bash terminal, Clone nord dircolors repository
RUN git clone https://github.com/arcticicestudio/nord-dircolors.git

# Copy the dircolors file to the home directory
RUN cp nord-dircolors/src/dir_colors ~/.dircolors && \
    echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.bashrc

# Add Docker’s official GPG key
RUN sudo install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's repository
RUN echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker-ce-cli

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

# Install Az PowerShell Module
RUN pwsh -c "Install-Module -Name Az -AllowClobber -Scope AllUsers -Force"

# Install AWS PowerShell Module
RUN pwsh -c "Install-Module -Name AWS.Tools.Installer -AllowClobber -Scope AllUsers -Force" && \
    pwsh -c "Install-AWSToolsModule AWS.Tools.Common, AWS.Tools.EC2, AWS.Tools.S3 -CleanUp -Force"

# Install Azure Stack Hub PowerShell Module
RUN pwsh -c "Install-Module -Name AzureStack -RequiredVersion 2.2.0 -AllowClobber -Scope AllUsers -Force"

# Install AWS Snowball CLI
RUN curl -fsSL -o snowball.tar.gz https://snowball-client.s3.us-west-2.amazonaws.com/latest/snowball-client-linux.tar.gz && \
    tar xzf snowball.tar.gz && \
    rm snowball.tar.gz && \
    mv snow* /usr/local/snowball

# Add the AWS Snowball CLI to the PATH environment variable
ENV PATH="/usr/local/snowball/bin:${PATH}"

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install Kubectx
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Terraform
ARG TERRAFORM_VERSION="1.0.11"
RUN curl -sSLo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    rm -f terraform.zip

# Install Node.js (required for code-server)
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Install code-server
ARG CODE_SERVER_VERSION="3.12.0"
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=${CODE_SERVER_VERSION}

# Install extensions
RUN code-server --install-extension amazonwebservices.aws-toolkit-vscode && \
    code-server --install-extension CoenraadS.bracket-pair-colorizer && \
    code-server --install-extension DavidAnson.vscode-markdownlint && \
    code-server --install-extension dbaeumer.vscode-eslint && \
    code-server --install-extension eamodio.gitlens && \
    code-server --install-extension ecmel.vscode-html-css && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension formulahendry.auto-close-tag && \
    code-server --install-extension formulahendry.auto-rename-tag && \
    code-server --install-extension formulahendry.docker-explorer && \
    code-server --install-extension hashicorp.terraform && \
    code-server --install-extension loganarnett.lambda-snippets && \
    code-server --install-extension ms-azuretools.vscode-azureappservice && \
    code-server --install-extension ms-azuretools.vscode-azureeventgrid && \
    code-server --install-extension ms-azuretools.vscode-azurefunctions && \
    code-server --install-extension ms-azuretools.vscode-azurestorage && \
    code-server --install-extension ms-azuretools.vscode-azureterraform && \
    code-server --install-extension ms-azuretools.vscode-cosmosdb && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension ms-dotnettools.csharp && \
    code-server --install-extension bajdzis.vscode-database && \
    code-server --install-extension mechatroner.rainbow-csv && \
    code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools && \
    code-server --install-extension ms-python.anaconda-extension-pack && \
    code-server --install-extension ms-python.python && \
    code-server --install-extension ms-toolsai.jupyter && \
    code-server --install-extension ms-vscode.azure-account && \
    code-server --install-extension ms-vscode.azurecli && \
    code-server --install-extension ms-vscode.cmake-tools && \
    code-server --install-extension ms-vscode.powershell && \
    code-server --install-extension ms-vscode.vscode-node-azure-pack && \
    code-server --install-extension ms-vscode.vscode-typescript-tslint-plugin && \
    code-server --install-extension ms-vsts.team && \
    code-server --install-extension msjsdiag.vscode-react-native && \
    code-server --install-extension p1c2u.docker-compose && \
    code-server --install-extension redhat.java && \
    code-server --install-extension redhat.vscode-yaml && \
    code-server --install-extension technosophos.vscode-make && \
    code-server --install-extension twxs.cmake && \
    code-server --install-extension vscjava.vscode-java-debug && \
    code-server --install-extension vscjava.vscode-java-dependency && \
    code-server --install-extension vscjava.vscode-java-pack && \
    code-server --install-extension vscjava.vscode-java-test && \
    code-server --install-extension vscjava.vscode-maven && \
    code-server --install-extension vscode-icons-team.vscode-icons && \
    code-server --install-extension xabikos.JavaScriptSnippets && \
    code-server --install-extension zhuangtongfa.material-theme && \
    code-server --install-extension Zignd.html-css-class-completion && \
    code-server --install-extension formulahendry.terminal && \
    code-server --install-extension tyriar.terminal-tabs

# Create the user settings directory
RUN mkdir -p /root/.local/share/code-server/User

# Set the color theme to Dark+
RUN echo '{\n\
    "workbench.colorTheme": "Default Dark+"\n\
}' > /root/.local/share/code-server/User/settings.json


# Install k9s
ARG K9S_VERSION="0.24.15"
RUN curl -LO https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
    tar -xvf k9s_Linux_x86_64.tar.gz && \
    mv k9s /usr/local/bin/ && \
    rm k9s_Linux_x86_64.tar.gz

# Install Helm
ARG HELM_VERSION="3"
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-${HELM_VERSION} && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh


# Enable kubectl bash completion
RUN echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc && \
    echo "source <(kubectl completion bash)" >> ~/.bashrc

# Download and install AWS CLI completion script
RUN curl https://raw.githubusercontent.com/aws/aws-cli/v2.2.46/scripts/aws_completer > /usr/local/bin/aws_completer && \
    chmod +x /usr/local/bin/aws_completer

# Enable AWS CLI completion
RUN echo 'complete -C "/usr/local/bin/aws_completer" aws' >> ~/.bashrc

# Download and install Az CLI completion script
# RUN az --completion-script-bash > /etc/bash_completion.d/az

# Add Az autocompletion to bashrc
# RUN echo "source /etc/bash_completion.d/az" >> ~/.bashrc

# Create aliases
RUN echo "alias k=kubectl" >> ~/.bashrc
RUN echo "alias sbe=snowballEdge" >> ~/.bashrc

# Expose the code-server port
EXPOSE 8080

# Set the working directory
WORKDIR /workspace

# Start PowerShell by default
CMD ["pwsh"]
