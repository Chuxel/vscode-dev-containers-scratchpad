FROM mcr.microsoft.com/vscode/devcontainers/repos/microsoft/vscode:latest

# Install VS Code Insiders
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && sed -i -E 's/.*Start Code - OSS.*/    [exec] (VS Code Insiders) { \/usr\/bin\/code-insiders } <>/' /home/node/.fluxbox/menu \
    && curl -sSL https://go.microsoft.com/fwlink/?LinkID=760865 -o /tmp/code-insiders.deb \
    && apt-get -y install /tmp/code-insiders.deb \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/code-insiders.deb

# Install credential manager
ENV GCM_MODAL_PROMPT=false
ENV GCM_CREDENTIAL_STORE=plaintext
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -sSL https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.252-beta/gcmcore-linux_amd64.2.0.252.766.deb -o /tmp/gcm.deb \
    && apt-get -y install /tmp/gcm.deb \
    && su node -c "git-credential-manager-core configure" 2>&1 \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/gcm.deb

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "node" \
    && curl -sSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash \
    && bash /tmp/library-scripts/sshd-debian.sh "2222" "node" "false" "skip" \
    && bash /tmp/library-scripts/azcli-debian.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

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


