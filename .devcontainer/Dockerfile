FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-12-buster

# Install Lazy Docker
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -sSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install credential manager
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends pass \
    && curl -sSL https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.252-beta/gcmcore-linux_amd64.2.0.252.766.deb -o /tmp/gcm.deb \
    && apt-get -y install /tmp/gcm.deb \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/gcm.deb 

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=node
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock
COPY library-scripts/*.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USERNAME}" \
    && bash /tmp/library-scripts/sshd-debian.sh "2222" "${USERNAME}" "false" "skip" \
    && bash /tmp/library-scripts/desktop-lite-debian.sh "${USERNAME}" "vscode" "true" \
	&& sed -i -E 's/.*Terminal.*/    [exec] (Terminal) { tilix -w ~ -e $(readlink -f \/proc\/$$\/exe) -il } <>\n	[exec] (VS Code) { /usr/bin/code* } <>/' /home/node/.fluxbox/menu \
    && bash /tmp/library-scripts/azcli-debian.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

ENV DBUS_SESSION_BUS_ADDRESS="autolaunch:" \
    DISPLAY=":1" \
    LANG="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8"

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh", "/usr/local/share/desktop-init.sh" ]
CMD [ "sleep", "infinity" ]

# Install Chrome
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb \
    && apt-get -y install /tmp/chrome.deb \
    && ALIASES="alias google-chrome='google-chrome --disable-dev-shm-usage'\nalias google-chrome-stable='google-chrome-stable --disable-dev-shm-usage'\nalias x-www-browser='x-www-browser --disable-dev-shm-usage'\nalias gnome-www-browser='gnome-www-browser --disable-dev-shm-usage'" \
    && echo "${ALIASES}" >> /etc/bash.bashrc \
    && if type zsh > /dev/null 2>&1; then echo "${ALIASES}" >> /etc/zsh/zshrc; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/chrome.deb

# Install VS Code Insiders
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -sSL https://go.microsoft.com/fwlink/?LinkID=760865 -o /tmp/code-insiders.deb \
    && apt-get -y install /tmp/code-insiders.deb \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/code-insiders.deb

