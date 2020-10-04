#!/bin/bash
clone-repo()
{
    cd $(dirname $0)/..
    if [ ! -d "$1" ]; then
        git clone -c credential.helper=store https://github.com/microsoft/$1 
    else 
        echo "Already cloned $1"
    fi
}

clone-repo vscode-dev-containers
clone-repo vscode-remote-containers
