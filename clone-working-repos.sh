#!/bin/bash

# Go to the workspace folder
cd $(dirname $0)/..
git-credential-manager-core configure
git clone https://github.com/microsoft/vscode-dev-containers
git clone https://github.com/microsoft/vscode-remote-containers
