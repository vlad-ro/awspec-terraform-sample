#!/bin/bash

# Install dependencies

if [ ! -x "$(which terraform)" ]; then
    echo "Installing terraform..."
    if [ -x "$(which apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install --yes terraform
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [ ! -x "$(which brew)" ]; then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install terraform
    fi
fi

if [ ! -x "$(which dot)" ]; then
    echo "Installing graphviz..."
    brew install graphviz
fi

terraform init
