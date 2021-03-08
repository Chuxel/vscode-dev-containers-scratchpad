#!/bin/bash
WORKSPACES="$(cd $(dirname $0)/.. && pwd)"
clone-repo()
{
    cd "${WORKSPACES}"
    if [ ! -d "$1" ]; then
        git clone https://github.com/microsoft/$1 
    else 
        echo "Already cloned $1"
    fi
}

sudo sed -i -E 's/helper =.*//' /etc/gitconfig
git config --global credential.helper '!f() { sleep 1; echo "username=${GH_USER}"; echo "password=${GH_TOKEN}"; }; f'

clone-repo vscode-remote-containers
clone-repo vscode-dev-containers
mkdir -p "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos"
ln -s "${WORKSPACES}/vscode-dev-containers" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-node
ln -s "${WORKSPACES}/vscode-remote-try-node" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-python
ln -s "${WORKSPACES}/vscode-remote-try-python" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-go
ln -s "${WORKSPACES}/vscode-remote-try-go" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-java
ln -s "${WORKSPACES}/vscode-remote-try-java" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-dotnetcore
ln -s "${WORKSPACES}/vscode-remote-try-dotnetcore" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-rust
ln -s "${WORKSPACES}/vscode-remote-try-rust" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-cpp
ln -s "${WORKSPACES}/vscode-remote-try-cpp" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
clone-repo vscode-remote-try-php
ln -s "${WORKSPACES}/vscode-remote-try-php" "${WORKSPACES}/vscode-remote-containers/test/dev-containers/repos/"
