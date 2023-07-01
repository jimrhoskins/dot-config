#!/usr/bin/env bash

# Checkout submodules
git submodule init
git submodule update

# Link nvim user configs
ln -s ../../nvim_user nvim/lua/user

# Link zshrc
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
fi
ln -s zshrc ~/.zshrc
