#!/usr/bin/env bash

# Checks if packages are installed and installs them if not
check_and_install() {
  for package in "$@"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
      echo "$package is not installed - starting installation"
      if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
      fi
      apt-get -y install --no-install-recommends "$package"
    fi
  done
}

# Adds user to specified groups if they exist
add_user_to_groups() {
  local user="$1"
  local groups="$2"
  
  if [ -z "$groups" ]; then
    return 0
  fi
  
  # Convert comma-separated string to array
  IFS=',' read -ra GROUP_ARRAY <<< "$groups"
  
  for group in "${GROUP_ARRAY[@]}"; do
    # Trim whitespace
    group=$(echo "$group" | xargs)
    
    if [ -n "$group" ]; then
      # Check if group exists
      if getent group "$group" >/dev/null 2>&1; then
        # Check if user is already in the group
        if ! id -nG "$user" | grep -qw "$group"; then
          echo "Adding user $user to group $group"
          usermod -a -G "$group" "$user"
        else
          echo "User $user is already in group $group"
        fi
      else
        echo "Warning: Group $group does not exist, skipping"
      fi
    fi
  done
}

# Cleans APT's cache to keep devcontainer layers small
clean_package_cache() {
  apt-get clean
}
