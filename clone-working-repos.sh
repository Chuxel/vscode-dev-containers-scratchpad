#!/bin/bash
clone-repo()
{
    cd $(dirname $0)/..
    git clone -c credential.helper=store https://github.com/microsoft/$1 
}

clone-repo vscode-dev-containers
clone-repo vscode-remote-release
