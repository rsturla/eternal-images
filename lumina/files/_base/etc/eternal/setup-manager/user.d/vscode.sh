#!/usr/bin/env bash

# Define an array of VS Code extensions to be installed
extensions=(
  ms-vscode-remote.vscode-remote-extensionpack
  jetpack-io.devbox
  usernamehw.errorlens
  editorconfig.editorconfig
  github.copilot
  hashicorp.hcl
  hashicorp.terraform
  vscode-icons-team.vscode-icons
)

# Function to install a single extension
install_extension() {
  local extension=$1
  echo "Installing $extension..."
  code --install-extension "$extension"
  if [[ $? -ne 0 ]]; then
    echo "Error installing $extension" >&2
  else
    echo "$extension installed successfully."
  fi
}

# Iterate over the extensions array and install each one
for extension in "${extensions[@]}"; do
  install_extension "$extension"
done

echo "All extensions installation attempted."
