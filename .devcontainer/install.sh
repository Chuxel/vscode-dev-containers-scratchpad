#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update

install-code() {
    local url=$1
    local is_insiders=$2
    local cmd=/usr/bin/code
    local cfg='$HOME/.config/Code/User/'
    if [ "$is_insiders" = "true" ]; then
        cmd=/usr/bin/code-insiders
        cfg='$HOME/.config/Code - Insiders/User/'
    fi
    
    curl -sSL "$url" -o /tmp/code.deb
    apt-get install -y /tmp/code.deb
    rm -f /tmp/code.deb

    su node -c "\
        export DONT_PROMPT_WSL_INSTALL=true \
        && $cmd --install-extension ms-vscode-remote.remote-containers \
        && $cmd --install-extension ms-azuretools.vscode-docker \
        && $cmd --install-extension streetsidesoftware.code-spell-checker \
        && $cmd --install-extension chrisdias.vscode-opennewinstance \
        && $cmd --install-extension mads-hartmann.bash-ide-vscode \
        && $cmd --install-extension rogalmic.bash-debug \
        && echo \"Adding settings.json to $cfg...\" \
        && mkdir -p \"$cfg\" \
        && echo '{ \"window.titleBarStyle\": \"custom\" }' > \"$cfg/settings.json\"" 2>&1
}

# Install VS Code Insiders
install-code "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" "false"
install-code "https://go.microsoft.com/fwlink/?LinkID=760865" "true"

# Install Chrome
curl -sSL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o /tmp/chrome.deb
apt-get -y install /tmp/chrome.deb
ALIASES="alias google-chrome='google-chrome --disable-dev-shm-usage'\nalias google-chrome-stable='google-chrome-stable --disable-dev-shm-usage'\nalias x-www-browser='x-www-browser --disable-dev-shm-usage'\nalias gnome-www-browser='gnome-www-browser --disable-dev-shm-usage'"
echo "${ALIASES}" >> /etc/bash.bashrc
if type zsh > /dev/null 2>&1; then echo "${ALIASES}" >> /etc/zsh/zshrc; fi
rm -f /tmp/chrome.deb

# Install oras
ORAS_VERSION=0.10.0
ORAS_SHA256=f621038a46ee445d7cc0deb079e2e3a2419e76b35fb46a0e2a404bda5d9f6b15
curl -LsSO "https://github.com/deislabs/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz"
echo "${ORAS_SHA256} *oras_${ORAS_VERSION}_linux_amd64.tar.gz" | sha256sum -c -
mkdir -p /tmp/oras-install/
tar -zxf oras_${ORAS_VERSION}_linux_amd64.tar.gz -C /tmp/oras-install/
mv /tmp/oras-install/oras /usr/local/bin/
rm -rf oras_${ORAS_VERSION}_linux_amd64.tar.gz /tmp/oras-install/

#curl -sSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
