#!/bin/bash

# Setup dotfiles and ZSH
mkdir git
cd git
git clone https://github.com/wichersn/dotfiles.git
cd dotfiles
./install.sh --zsh --tmux
./deploy.sh

# Setup github
chmod +x ./runpod/setup_github.sh
./runpod/setup_github.sh "nevan.wichers@gmail.com" "Nevan Wichers"
cd ..