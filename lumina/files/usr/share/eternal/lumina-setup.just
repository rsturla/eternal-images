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
  @bash -c "sudo sed -i --follow-symlinks 's/enabled=0/enabled=1/g' /etc/yum.repos.d/google-chrome.repo"
  @rpm-ostree install --idempotent \
    google-chrome-stable \
    1password

setup-vscode:
  @echo "Installing VSCode Extensions..."
  @code --install-extension ms-vscode-remote.vscode-remote-extensionpack

setup-jetbrains:
  #!/usr/bin/env bash
  pushd "$(mktemp -d)"
  echo "Get latest JetBrains Toolbox version"
  # Get the json with latest releases
  curl -sSfL -o releases.json "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
  # Extract information
  BUILD_VERSION=$(jq -r '.TBA[0].build' ./releases.json)
  DOWNLOAD_LINK=$(jq -r '.TBA[0].downloads.linux.link' ./releases.json)
  CHECKSUM_LINK=$(jq -r '.TBA[0].downloads.linux.checksumLink' ./releases.json)
  echo "Installing JetBrains Toolbox ${BUILD_VERSION}"
  curl -sSfL -O "${DOWNLOAD_LINK}"
  curl -sSfL "${CHECKSUM_LINK}" | sha256sum -c
  tar zxf jetbrains-toolbox-"${BUILD_VERSION}".tar.gz
  echo "Launching JetBrains Toolbox"
  ./jetbrains-toolbox-"${BUILD_VERSION}"/jetbrains-toolbox

setup-homebrew:
  @echo 'Installing homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
