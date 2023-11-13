#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as an administrator (root) using 'sudo'."
  exit 1
fi

echo "1- Debian/Ubuntu/Kali Linux/Parrot OS Upgrade (apt)"
echo "2- Arch Linux/Manjaro Upgrade (yay/pacman)"
echo "3- Fedora/CentOS Upgrade (dnf/yum)"
echo "4- openSUSE Upgrade (zypper)"
echo "5- auto-detected Upgrade (coming soon)"

read -t 10 -p "Enter the number of the script you want to run (default: 5 after 10 seconds): " choice

choice=${choice:-5}

case $choice in
  1)
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/ArchLinux.sh)"
    ;;
  2)
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/ArchLinux.sh)"
    ;;
  3)
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/CentOS.sh)"
    ;;
  4)
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/OpenSUSE.sh)"
    ;;
  5)
    if apt --version >/dev/null 2>&1; then
      echo "Debian/Ubuntu/Kali Linux/Parrot OS detected."
      sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/DebianUpgrade.sh)"
    elif yay --version >/dev/null 2>&1; then
      echo "Arch Linux/Manjaro detected."
      sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/ArchLinux.sh)"
    elif pacman --version >/dev/null 2>&1; then
      echo "Arch Linux/Manjaro detected."
      sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/ArchLinux.sh)"
    elif dnf --version >/dev/null 2>&1; then
      echo "CentOS/Fedora  detected."
      sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/CentOS.sh)"
    elif yum --version >/dev/null 2>&1; then
      echo "CentOS/Fedora detected."
      sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/CentOS.sh)"
    elif zypper --version >/dev/null 2>&1; then
      echo "openSUSE detected."
      sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/RylexOff/OS-Upgrade-Scripts/main/OpenSUSE.sh)"
    else
      echo "No suitable package manager found."
    fi
    ;;
  *)
    echo "Invalid choice"
    ;;
esac
