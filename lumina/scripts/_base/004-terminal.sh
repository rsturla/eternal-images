#!/usr/bin/bash

set -euox pipefail

dnf install -y zsh

# Install oh-my-zsh to /usr/share/oh-my-zsh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh

# Install zsh-autosuggestions plugin
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
  /usr/share/oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting plugin
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
  /usr/share/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Remove .git directories to save space
find /usr/share/oh-my-zsh -name '.git' -type d -exec rm -rf {} + 2>/dev/null || true

# Chunkah: group omz + plugins (non-RPM) so they get their own layer
setfattr -n user.component -v "lumina-omz" /usr/share/oh-my-zsh
find /usr/share/oh-my-zsh -mindepth 1 -exec setfattr -n user.component -v "lumina-omz" {} \;
