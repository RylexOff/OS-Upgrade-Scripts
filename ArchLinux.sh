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

if command -v yay &>/dev/null; then
  package_manager="yay"
else
  package_manager="pacman"
fi

if [ "$package_manager" = "yay" ]; then
  if yay -Sy; then
    echo "Package databases synchronized successfully."
  else
    echo "Error synchronizing package databases."
    exit 1
  fi
else
  if sudo pacman -Sy; then
    echo "Package databases synchronized successfully."
  else
    echo "Error synchronizing package databases."
    exit 1
  fi
fi
update_progress

if [ "$package_manager" = "yay" ]; then
  if yay -Syu --noconfirm; then
    echo "All packages upgraded successfully."
  else
    echo "Error upgrading all packages."
    exit 1
  fi
else
  if sudo pacman -Syu --noconfirm; then
    echo "All packages upgraded successfully."
  else
    echo "Error upgrading all packages."
    exit 1
  fi
fi
update_progress

if [ "$package_manager" = "yay" ]; then
  if yay -Sc --noconfirm; then
    echo "Package cache cleaned successfully."
  else
    echo "Error cleaning package cache."
    exit 1
  fi
else
  if sudo pacman -Sc --noconfirm; then
    echo "Package cache cleaned successfully."
  else
    echo "Error cleaning package cache."
    exit 1
  fi
fi
update_progress

if [ "$package_manager" = "yay" ]; then
  if yay -Rns $(yay -Qtdq) --noconfirm; then
    echo "Orphaned packages removed successfully."
  else
    echo "Error removing orphaned packages."
    exit 1
  fi
else
  if sudo pacman -Rns $(pacman -Qtdq) --noconfirm; then
    echo "Orphaned packages removed successfully."
  else
    echo "Error removing orphaned packages."
    exit 1
  fi
fi
update_progress

echo "Update and cleaning completed successfully."
