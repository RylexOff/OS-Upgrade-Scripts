#!/bin/bash

total_steps=6
current_step=0

function update_progress() {
  current_step=$((current_step + 1))
  percentage=$((current_step * 100 / total_steps))
  echo "Progress: $percentage%"
}

echo "Starting the update..."
update_progress

if command -v dnf &>/dev/null; then
  package_manager="dnf"
else
  if command -v yum &>/dev/null; then
    package_manager="yum"
  else
    echo "Error: Neither dnf nor yum package manager found."
    exit 1
  fi
fi

if [ "$package_manager" = "dnf" ]; then
  if sudo dnf check-update; then
    sudo dnf upgrade -y
    echo "List of packages updated successfully."
  else
    echo "Error updating the list of packages."
    exit 1
  fi
elif [ "$package_manager" = "yum" ]; then
  if sudo yum check-update; then
    sudo yum update -y
    echo "List of packages updated successfully."
  else
    echo "Error updating the list of packages."
    exit 1
  fi
fi
update_progress

echo "Upgrading installed packages..."
if [ "$package_manager" = "dnf" ]; then
  if sudo dnf upgrade -y; then
    echo "Installed packages upgraded successfully."
  else
    echo "Error upgrading installed packages."
    exit 1
  fi
elif [ "$package_manager" = "yum" ]; then
  if sudo yum upgrade -y; then
    echo "Installed packages upgraded successfully."
  else
    echo "Error upgrading installed packages."
    exit 1
  fi
fi
update_progress

echo "Cleaning residual packages..."
if [ "$package_manager" = "dnf" ]; then
  if sudo dnf autoremove -y; then
    echo "Cleaning of residual packages completed successfully."
  else
    echo "Error cleaning residual packages."
    exit 1
  fi
elif [ "$package_manager" = "yum" ]; then
  if sudo package-cleanup --oldkernels --count=1; then
    echo "Cleaning of residual packages completed successfully."
  else
    echo "Error cleaning residual packages."
    exit 1
  fi
fi
update_progress

echo "Removing obsolete packages..."
if [ "$package_manager" = "dnf" ]; then
  obsolete_packages=$(dnf repoquery --installonly --latest-limit 1 -q)
elif [ "$package_manager" = "yum" ]; then
  obsolete_packages=$(rpm -q --qf '%{name}\n' -a)
fi

if [ -n "$obsolete_packages" ]; then
  if [ "$package_manager" = "dnf" ]; then
    if sudo dnf remove $obsolete_packages -y; then
      echo "Removal of obsolete packages completed successfully."
    else
      echo "Error removing obsolete packages."
      exit 1
    fi
  elif [ "$package_manager" = "yum" ]; then
    if sudo yum remove $obsolete_packages -y; then
      echo "Removal of obsolete packages completed successfully."
    else
      echo "Error removing obsolete packages."
      exit 1
    fi
  fi
else
  echo "No obsolete packages to remove."
fi
update_progress

echo "Rebooting the system..."
if sudo reboot; then
  echo "System reboot in progress..."
else
  echo "Error rebooting the system."
  exit 1
fi
update_progress

echo "Update and cleaning completed successfully."
