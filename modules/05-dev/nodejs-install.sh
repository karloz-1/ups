#!/bin/bash

if ! command_exists node; then
    # https://nodejs.org/en/download
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install --lts
    nvm use --lts
fi

