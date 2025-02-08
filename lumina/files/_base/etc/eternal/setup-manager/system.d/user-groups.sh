#!/usr/bin/env bash

set -euo pipefail

append_group() {
  local group_name="$1"

  # Check if the group exists in /etc/group
  if ! getent group "$group_name" > /dev/null; then
    echo "Appending $group_name to /etc/group"

    # Try to append the group if it exists in system defaults
    if grep -q "^$group_name:" /usr/lib/group 2>/dev/null; then
      grep "^$group_name:" /usr/lib/group >> /etc/group
      echo "$group_name successfully appended."
    else
      echo "Warning: Group $group_name not found in system defaults, skipping." >&2
    fi
  else
    echo "Group $group_name already exists in /etc/group, skipping."
  fi
}

# Get list of users in 'wheel' group safely
wheelarray=()
while IFS=',' read -ra users; do
  for user in "${users[@]}"; do
    wheelarray+=("$user")
  done
done < <(getent group wheel | cut -d ":" -f 4)

groups=(docker nordvpn)

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
