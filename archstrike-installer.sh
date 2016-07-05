#!/usr/bin/env bash
pacmanconf="/etc/pacman.conf"
main()
{
  echo "Installation script for ArchStrike Penetration Testing and Security Layer - made by xorond"
  echo "This script will help you install ArchStrike on your Arch Linux running computer"
  sleep 3
  echo "> Starting installation process, are you ready? (y/n)"
  read -r choice
  if [[ "$choice" == 'y' ]]; then
      archstrike-install
  else
      echo "Later then!"
      exit 0
  fi
}

archstrike-install()
{
  echo "Now starting the install process.."
  echo "Backing up $pacmanconf to pacman.conf.bak.(date & time)"
  cp $pacmanconf ${pacmanconf}.bak."$(date +%F_%R)"
  sleep 2
  echo "Adding archstrike repositories to pacman.conf"
  echo '[archstrike]' >> $pacmanconf
  echo 'Server = https://mirror.archstrike.org/$arch/$repo' >> $pacmanconf
  sleep 2
  echo "Done, it's mandatory to enable multilib for x86_64 architectures."
  echo "> Is your computer x86_64? (y/n)"
  read -r arch
  if [[ "$arch" == "y" ]]; then
    echo "> Do you have multilib enabled? (y/n)"
    read -r multilib
    if [[ "$multilib" == "n" ]]; then
        echo "Now opening $pacmanconf"
        echo "Please remove the comments (#)  in [multilib] and the following line"
        sleep 5
        nano $pacmanconf
        echo "Done, continuing"
    fi
  fi
  echo "Performing package database updates.."
  sleep 3
  pacman -Syy
  echo "Installing ArchStrike keyring.."
  sleep 3

  from="From: archstrike-installer"
  user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36"
  url="https://archstrike.org/wiki/setup"
  key_id=$(curl -H "$from" -A "$user_agent" -s "$url" | grep -o [^#]pacman-key\ -r\ .*$ | awk '{print $3}')

  pacman-key --init
  dirmngr < /dev/null
  pacman-key -r $key_id
  pacman-key --lsign-key $key_id
  echo "Done, installing required packages.."
  sleep 2
  pacman -S archstrike-keyring
  pacman -S archstrike-mirrorlist
  echo "Done, editing pacman.conf to use the mirrorlist.."
  sleep 2
  sed -i 's|Server = https://mirror.archstrike.org/$arch/$repo|Include = /etc/pacman.d/archstrike-mirrorlist|' $pacmanconf
  echo "> Done. Do you want to add archstrike-testing? (y/n)"
  read -r testing
  if [[ "$testing" == "y" ]]; then
    echo "[archstrike-testing]" >> $pacmanconf
    echo "Include = /etc/pacman.d/archstrike-mirrorlist" >> $pacmanconf
    echo "Added archstrike-testing"
  fi
  echo "Performing database update.."
  pacman -Syy
  echo "You have successfully installed ArchStrike repositories."
  echo "To see all the packages: 'pacman -Sl archstrike'"
  echo "To see all testing packages: 'pacman -Sl archstrike-testing'"
  echo "To see all groups: 'pacman -Sg | grep archstrike'"
  echo "To see all packages in a group: 'pacman -Sgg | grep archstrike-<groupname>'"
  sleep 10
  echo "Do you want to go ahead and install everything from the main repostitory? (y/n)"
  read -r main-install
  if [[ "$main-install" == "y" ]]; then
    echo "Installing all packages from main, this will take a while.."
    pacman -S archstrike --noconfirm
  fi
  echo "How about testing? (y/n)"
  read -r testing-install
  if [[ "$testing-install" == "y" ]]; then
    echo "Installing all packages from testing, this will take a while.."
    pacman -S archstrike-testing --noconfirm
  fi
  echo "Thanks for using ArchStrike!"
  echo "This was a script by xorond https://github.com/xorond"
  echo "More info on our website: https://archstrike.org"
  sleep 10
  exit 0
}
if [[ "$(whoami)" != "root" ]]; then
    echo "$0 can only be run as root, exiting."
    sleep 2
    exit 0
fi
main
exit 0
