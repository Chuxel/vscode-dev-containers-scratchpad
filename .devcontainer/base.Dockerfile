FROM mcr.microsoft.com/vscode/devcontainers/repos/microsoft/vscode:dev

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY install.sh library-scripts/*.sh /tmp/library-scripts/
RUN /tmp/library-scripts/docker-in-docker-debian.sh "true" "node" "true" \
    && bash /tmp/library-scripts/sshd-debian.sh "2222" "node" "false" "skip" \
    && bash /tmp/library-scripts/azcli-debian.sh \
    && bash /tmp/library-scripts/github-debian.sh \
    && bash /tmp/library-scripts/user-install.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh", "/usr/local/share/desktop-init.sh" ]
CMD [ "sleep", "infinity" ]

VOLUME [ "/var/lib/docker" ]
