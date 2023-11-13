#!/bin/bash

total_steps=5
current_step=0

function update_progress() {
  current_step=$((current_step + 1))
  percentage=$((current_step * 100 / total_steps))
  echo "Progress: $percentage%"
}

echo "Starting the update..."
update_progress

if command -v zypper &>/dev/null; then
  package_manager="zypper"
else
  echo "Error: zypper package manager not found."
  exit 1
fi

if [ "$package_manager" = "zypper" ]; then
  if sudo zypper refresh; then
    echo "Repositories refreshed successfully."
  else
    echo "Error refreshing repositories."
    exit 1
  fi
fi
update_progress

if [ "$package_manager" = "zypper" ]; then
  if sudo zypper update -y; then
    echo "All packages updated successfully."
  else
    echo "Error updating all packages."
    exit 1
  fi
fi
update_progress

if [ "$package_manager" = "zypper" ]; then
  if sudo zypper clean -a; then
    echo "Package cache cleaned successfully."
  else
    echo "Error cleaning package cache."
    exit 1
  fi
fi
update_progress

if [ "$package_manager" = "zypper" ]; then
  if sudo zypper remove --clean-deps $(sudo zypper packages --unneeded -i) -y; then
    echo "Orphaned packages removed successfully."
  else
    echo "Error removing orphaned packages."
    exit 1
  fi
fi
update_progress

echo "Update and cleaning completed successfully."
