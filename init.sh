#!/bin/bash

set -o errexit

# Install dependencies

check_install() {
    local target=$1
    local package=${2:-$1} # If package is not set it should be same as target

    if [ -x "$(command -v $target)" ]; then
        return
    fi

    echo "Installing $package..."
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install --yes $package
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y $package
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [ ! -x "$(command -v brew)" ]; then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install $package
    fi
}

if [ ! -x "$(command -v terraform)" ]; then
    check_install unzip
    check_install wget
    echo "Installing terraform..."
    # Use cross-platform installation script
    curl -LO https://raw.github.com/robertpeteuil/terraform-installer/master/terraform-install.sh
    sh terraform-install.sh -a
    rm terraform-install.sh
fi

#check_install dot graphviz

if [ ! -x "$(command -v awspec)" ]; then
    echo "Installing awspec..."
    if [ -x "$(command -v ruby)" ]; then
        required="2.1.0"
        actual=$(ruby -v | cut -d ' ' -f2)
        desired="$required\n$actual"
        if [ "$desired" != "$(echo -e "$desired" | sort --version-sort)" ]; then
            echo "Updating ruby..."
            if [ -x "$(command -v yum)" ]; then
                sudo yum install -y centos-release-scl
                sudo yum install -y rh-ruby24
                RUBY="scl enable rh-ruby24"
            fi
        fi
    fi
    sudo $RUBY 'gem install awspec'
fi

terraform init -backend-config=terraform.tfvars
