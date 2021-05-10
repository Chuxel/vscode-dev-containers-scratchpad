FROM mcr.microsoft.com/vscode/devcontainers/repos/microsoft/vscode:dev

# Add any install commands to install.sh or user-install.sh or and they'll be added to the image 
COPY install.sh library-scripts/*.sh /tmp/scripts/
RUN ls /tmp/scripts/*.sh | xargs -n 1 bash \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/scripts/

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh", "/usr/local/share/desktop-init.sh" ]
CMD [ "sleep", "infinity" ]

VOLUME [ "/var/lib/docker" ]
