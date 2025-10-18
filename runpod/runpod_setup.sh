#!/bin/bash

# 1) Setup linux dependencies
su -c 'apt-get update && apt-get install -y sudo'
sudo apt-get install -y less nano htop ncdu nvtop lsof rsync btop jq

# 2) Setup virtual environment
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv python install 3.11

# 3) Setup dotfiles and ZSH
mkdir git
cd git
git clone https://github.com/wichersn/dotfiles.git
cd dotfiles
./install.sh --zsh --tmux
chsh -s /usr/bin/zsh
./deploy.sh

# 4) Setup github
chmod +x ./runpod/setup_github.sh
./runpod/setup_github.sh "nevan.wichers@gmail.com" "Nevan Wichers"
cd ..

# 5) Copy SSH authorized_keys from workspace (if present)
if [ -f "/workspace/.ssh/authorized_keys" ]; then
mkdir -p "$HOME/.ssh"
cp -f "/workspace/.ssh/authorized_keys" "$HOME/.ssh/authorized_keys"
else
echo "Warning: /workspace/.ssh/authorized_keys not found; skipping copy."
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install --lts
nvm use --lts
nvm alias default node

npm install -g @anthropic-ai/claude-code
