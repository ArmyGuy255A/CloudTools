# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Delete the the Microsoft repository GPG keys file
rm packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell

# Install system dependencies
apt-get update && \
    apt-get install -y curl unzip git sudo nano make ruby ruby-dev build-essential libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libxshmfence1 libasound2 bash-completion apt-transport-https ca-certificates gnupg lsb-release python3 python-pip

# Prettify the bash terminal, Clone nord dircolors repository
git clone https://github.com/arcticicestudio/nord-dircolors.git

# Copy the dircolors file to the home directory
cp nord-dircolors/src/dir_colors ~/.dircolors && \
    echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.bashrc

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's repository
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI
apt-get update && \
    apt-get install -y docker-ce-cli

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

# Install Az PowerShell Module
pwsh -c "Install-Module -Name Az -AllowClobber -Scope AllUsers -Force"

# Install AWS PowerShell Module
pwsh -c "Install-Module -Name AWS.Tools.Installer -AllowClobber -Scope AllUsers -Force" && \
    pwsh -c "Install-AWSToolsModule AWS.Tools.Common, AWS.Tools.EC2, AWS.Tools.S3 -CleanUp -Force"

# Install Azure Stack Hub PowerShell Module
pwsh -c "Install-Module -Name AzureStack -RequiredVersion 2.2.0 -AllowClobber -Scope AllUsers -Force"

# Install AWS Snowball CLI
curl -fsSL -o snowball.tar.gz https://snowball-client.s3.us-west-2.amazonaws.com/latest/snowball-client-linux.tar.gz && \
    tar xzf snowball.tar.gz && \
    rm snowball.tar.gz && \
    mv snow* /usr/local/snowball

# Add the AWS Snowball CLI to the PATH environment variable
PATH="/usr/local/snowball/bin:${PATH}"

# Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install Kubectx
git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Terraform
TERRAFORM_VERSION="1.0.11"
curl -sSLo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    rm -f terraform.zip

# Install Node.js (required for code-server)
curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Install k9s
K9S_VERSION="0.24.15"
curl -LO https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
    tar -xvf k9s_Linux_x86_64.tar.gz && \
    mv k9s /usr/local/bin/ && \
    rm k9s_Linux_x86_64.tar.gz

# Install Helm
HELM_VERSION="3"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-${HELM_VERSION} && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh


# Enable kubectl bash completion
echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc && \
    echo "source <(kubectl completion bash)" >> ~/.bashrc

# Download and install AWS CLI completion script
curl https://raw.githubusercontent.com/aws/aws-cli/v2.2.46/scripts/aws_completer > /usr/local/bin/aws_completer && \
    chmod +x /usr/local/bin/aws_completer

# Enable AWS CLI completion
echo 'complete -C "/usr/local/bin/aws_completer" aws' >> ~/.bashrc

# Download and install Az CLI completion script
# az --completion-script-bash > /etc/bash_completion.d/az

# Add Az autocompletion to bashrc
# echo "source /etc/bash_completion.d/az" >> ~/.bashrc

# Create aliases
echo "alias k=kubectl" >> ~/.bashrc
echo "alias sbe=snowballEdge" >> ~/.bashrc

