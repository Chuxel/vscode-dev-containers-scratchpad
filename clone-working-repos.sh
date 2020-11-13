#!/bin/bash
WORKSPACES="$(cd $(dirname $0)/.. && pwd)"
clone-repo()
{
    cd "${WORKSPACES}"
    if [ ! -d "$1" ]; then
        git clone -c credential.helper=store https://github.com/microsoft/$1 
    else 
        echo "Already cloned $1"
    fi
}

sudo sed -i -E 's/helper =.*//' /etc/gitconfig

clone-repo vscode-dev-containers
clone-repo vscode-remote-containers
