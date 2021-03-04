FROM mcr.microsoft.com/vscode/devcontainers/repos/microsoft/vscode:dev

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN /tmp/library-scripts/docker-in-docker-debian.sh "true" "node" "true" \
    # && curl -sSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash \
    && bash /tmp/library-scripts/sshd-debian.sh "2222" "node" "false" "skip" \
    && bash /tmp/library-scripts/azcli-debian.sh \
    && bash /tmp/library-scripts/github-debian.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Install oras
ARG ORAS_VERSION=0.10.0
ARG ORAS_SHA256=f621038a46ee445d7cc0deb079e2e3a2419e76b35fb46a0e2a404bda5d9f6b15
RUN curl -LsSO https://github.com/deislabs/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz \
    && echo "${ORAS_SHA256} *oras_${ORAS_VERSION}_linux_amd64.tar.gz" | sha256sum -c - \
    && mkdir -p /tmp/oras-install/ \
    && tar -zxf oras_${ORAS_VERSION}_linux_amd64.tar.gz -C /tmp/oras-install/ \
    && mv /tmp/oras-install/oras /usr/local/bin/ \
    && rm -rf oras_${ORAS_VERSION}_linux_amd64.tar.gz /tmp/oras-install/

# Install VS Code Insiders
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && sed -i -E 's/.*Start Code - OSS.*/    [exec] (VS Code Insiders) { \/usr\/bin\/code-insiders } <>/' /home/node/.fluxbox/menu \
    && curl -sSL https://go.microsoft.com/fwlink/?LinkID=760865 -o /tmp/code-insiders.deb \
    && apt-get -y install /tmp/code-insiders.deb \
    && su node -c "\
        export DONT_PROMPT_WSL_INSTALL=true \
        && /usr/bin/code-insiders --install-extension ms-vscode-remote.remote-containers \
        && /usr/bin/code-insiders --install-extension ms-azuretools.vscode-docker \
        && /usr/bin/code-insiders --install-extension bierner.github-markdown-preview \
        && /usr/bin/code-insiders --install-extension streetsidesoftware.code-spell-checker \
        && /usr/bin/code-insiders --install-extension chrisdias.vscode-opennewinstance \
        && /usr/bin/code-insiders --install-extension mads-hartmann.bash-ide-vscode \
        && /usr/bin/code-insiders --install-extension rogalmic.bash-debug" 2>&1 \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/code-insiders.deb

# Install Chrome
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb \
    && apt-get -y install /tmp/chrome.deb \
    && ALIASES="alias google-chrome='google-chrome --disable-dev-shm-usage'\nalias google-chrome-stable='google-chrome-stable --disable-dev-shm-usage'\nalias x-www-browser='x-www-browser --disable-dev-shm-usage'\nalias gnome-www-browser='gnome-www-browser --disable-dev-shm-usage'" \
    && echo "${ALIASES}" >> /etc/bash.bashrc \
    && if type zsh > /dev/null 2>&1; then echo "${ALIASES}" >> /etc/zsh/zshrc; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/chrome.deb

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh", "/usr/local/share/desktop-init.sh" ]
CMD [ "sleep", "infinity" ]

VOLUME [ "/var/lib/docker" ]
