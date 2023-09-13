setup:
  @just --unstable setup-docker
  @just --unstable setup-distrobox
  @just --unstable setup-rpms
  @just --unstable setup-vscode
  @echo "Setup complete!"
  @echo "Please reboot to complete the setup process."

setup-docker:
  @echo "Adding user to docker group..."
  @bash -c "sudo usermod -aG docker $(whoami)"

setup-distrobox:
  @echo "Creating default Distrobox containers"
  @distrobox assemble create --file /etc/distrobox/distrobox.ini

setup-rpms:
  @echo "Installing layered RPMs..."
  @rpm-ostree install --idempotent \
    https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm

setup-vscode:
  @echo "Installing VSCode Extensions..."
  @code --install-extension ms-vscode-remote.vscode-remote-extensionpack
