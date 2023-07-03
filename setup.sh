#!/usr/bin/env bash

# Checkout submodules
git submodule init
git submodule update


# Link zshrc
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
fi
ln -s .config/_home/.zshrc ~/.zshrc
