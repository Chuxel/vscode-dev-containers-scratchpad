#!/bin/bash
clone-repo()
{
    REPO=$1
    cd $(dirname $0)/..
    mkdir -p ${REPO}
    cd ${REPO}
    git config credential.helper store
    git clone https://github.com/microsoft/${REPO} .
}

clone-repo vscode-dev-containers
clone-repo vscode-remote-release
