#!/usr/bin/env bash

set -euox pipefail

cat <<EOF > /etc/yum.repos.d/metasploit-framework.repo
[metasploit]
name=Metasploit
baseurl=http://downloads.metasploit.com/data/releases/metasploit-framework/rpm
gpgcheck=1
gpgkey=https://apt.metasploit.com/metasploit-framework.gpg.key
enabled=1
EOF

# Install OpenJDK
rpm-ostree install java-latest-openjdk

# Install Burp Suite
BURP_VERSION=$(curl -s https://portswigger.net/burp/releases | grep community | sed -nE "s/.*professional-community-(.*)\" class=\".*/\1/p" | head -n  1 | tr -d '\n' | tr '-' '.' | tr -d '\0')
mkdir -p /usr/share/java
curl -JLo /usr/share/java/burpsuite.jar https://portswigger-cdn.net/burp/releases/download?product=community&version=${BURP_VERSION}type=Linux && wait < <(jobs -p)
# Create desktop entry
cat <<EOF > /usr/share/applications/burpsuite.desktop
[Desktop Entry]
Name=burpsuite
Encoding=UTF-8
Exec=sh -c "java -jar /usr/share/java/burpsuite.jar"
Icon=kali-menu.png
StartupNotify=false
Terminal=false
Type=Application
EOF

# Install other tools
rpm-ostree install \
  nmap \
  wireshark \
  metasploit-framework \
  john \
  hashcat \
  hydra \
  ffuf

# Install Trufflehog
curl -Lo /tmp/trufflehog.tar.gz $(curl https://api.github.com/repos/trufflesecurity/trufflehog/releases/latest | jq -r '.assets[] | select(.name| test(".*linux_arm64.tar.gz$")).browser_download_url')
tar -xzf /tmp/trufflehog.tar.gz -C /usr/bin trufflehog

# Clean up
rm -f /etc/yum.repos.d/metasploit-framework.repo
