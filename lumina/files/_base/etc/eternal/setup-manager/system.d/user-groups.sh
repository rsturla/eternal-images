#!/usr/bin/env bash

set -euo pipefail

append_group() {
  local group_name="$1"
  if ! grep -q "^$group_name:" /etc/group; then
    echo "Appending $group_name to /etc/group"
    grep "^$group_name:" /usr/lib/group | tee -a /etc/group > /dev/null
  fi
}

# Get list of users in 'wheel' group safely
wheelarray=()
while IFS=',' read -ra users; do
  for user in "${users[@]}"; do
    wheelarray+=("$user")
  done
done < <(getent group wheel | cut -d ":" -f 4)

groups=(docker)

# Ensure groups exist
for group in "${groups[@]}"; do
  append_group "$group"
done

# Add wheel users to groups
for user in "${wheelarray[@]}"; do
  if [[ -n "$user" ]]; then  # Ensure user is not empty
    for group in "${groups[@]}"; do
      if id -u "$user" &>/dev/null; then
        usermod -aG "$group" "$user"
        echo "Added $user to $group"
      else
        echo "Warning: User $user does not exist, skipping." >&2
      fi
    done
  fi
done
