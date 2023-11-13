#!/bin/bash

total_steps=7
current_step=0

function update_progress() {
  current_step=$((current_step + 1))
  percentage=$((current_step * 100 / total_steps))
  echo "Progress: $percentage%"
}

echo "Starting the update..."
update_progress

if sudo apt update; then
  echo "List of packages updated successfully."
else
  echo "Error updating the list of packages."
  exit 1
fi
update_progress

echo "Upgrading installed packages..."
if sudo apt upgrade -y; then
  echo "Installed packages upgraded successfully."
else
  echo "Error upgrading installed packages."
  exit 1
fi
update_progress

echo "Performing a distribution upgrade..."
if sudo apt dist-upgrade -y; then
  echo "Distribution upgrade completed successfully."
else
  echo "Error performing the distribution upgrade."
  exit 1
fi
update_progress

echo "Cleaning residual packages..."
if sudo apt --purge autoremove -y && sudo apt autoclean; then
  echo "Cleaning of residual packages completed successfully."
else
  echo "Error cleaning residual packages."
  exit 1
fi
update_progress

echo "Removing obsolete packages..."
obsolete_packages=$(apt list --installed | grep -o '/.*~o' | sed 's~/.*~~')
if [ -n "$obsolete_packages" ]; then
  if sudo apt purge $obsolete_packages -y; then
    echo "Removal of obsolete packages completed successfully."
  else
    echo "Error removing obsolete packages."
    exit 1
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
