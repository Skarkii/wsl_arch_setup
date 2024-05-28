#!/bin/bash

echo "WARNING, this will reset your bashrc!"
read -p "Do you want to continue? (y/n): " answer

if [[ "$answer" =~ ^[Nn]$ ]]; then
	exit 0
elif [[ "$answer" =~ ^[Yy]$ ]]; then
	echo ""	
else
	echo "Invalid input. Please enter y or n."
	exit 0
fi

cd ~

# Define the file path
bashrc_file=~/.bashrc
custom_commands_file=~/.custom_commands

# Update all packages to latest version
sudo pacman -Sy && sudo pacman -Su

sudo pacman -S --needed \
  neovim \
  python3 \
  openssh \
  typescript-language-server \
  rust-analyzer \
  clang \
  unzip \
  npm \
  tmux \
  xclip \

# remove the contents of bashrc
truncate -s 0 "$bashrc_file"

echo "#
# ~/.bashrc
#

#
# Generated via shell file from https://github.com/Skarkii/wsl_arch_setup
# Made by Skarkii
#

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# cd commands
alias ..='cd ..'

# ls commands
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'

# grep commands
alias grep='grep --color=auto'

# neovim commands
alias vi='nvim'
alias vim='nvim'

# Windows commands (if running wsl)
alias explorer='explorer.exe'
alias clip='clip.exe'

# Xclip
alias xclip='xclip -sel clip'

PS1='\[\033[00;32m\]\u@\h\[\033[01;37m\]:\[\033[01;34m\]\w\[\033[00m\]$ '

source $custom_commands_file
# END" > $bashrc_file

echo '# Custom Commands
function cmkdir ()
{
    if [ -n "$1" ]; then
        mkdir "$1" && cd "$1"
    else
        echo "Usage: cmkdir <directory_name>"
    fi
}' > $custom_commands_file

source $bashrc_file

unset bashrc_file
unset custom_commands_file

echo 'Make sure to not have the file ~/.ssh/github as it will be replaced'
read -p "Do you want to create github ssh key?(y/n): " answer

if [[ "$answer" =~ ^[Nn]$ ]]; then
    echo ""
elif [[ "$answer" =~ ^[Yy]$ ]]; then
    # Create ssh config file
    mkdir -p ~/.ssh
    touch ~/.ssh/config
    echo 'AddKeysToAgent yes
# Example of adding a key
# IdentityFile ~/.ssh/github
IdentityFile ~/.ssh/github
' > ~/.ssh/config
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/github
echo 'run cat ~/.ssh/github.pub | xclip -sel clip and add the key to https://github.com/settings/ssh/new'
else
	echo "Invalid input. Please enter y or n."
fi

read -p "Do you want to setup neovim (https://github.com/Skarkii/neovim_repo)?(y/n): " answer

if [[ "$answer" =~ ^[Nn]$ ]]; then
    echo ""
elif [[ "$answer" =~ ^[Yy]$ ]]; then
mkdir -p ~/.local/share/nvim/site/pack/packer/start/
git clone --depth 1 https://github.com/wbthomason/packer.nvim/ ~/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p ~/.config/nvim
git clone https://github.com/Skarkii/neovim_repo ~/.config/nvim
else
	echo "Invalid input. Please enter y or n."
fi
unset answer

echo "Restart your terminal to ensure everything gets updated correctly!"
