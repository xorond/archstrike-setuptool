#!/usr/bin/env bash
pacmanconf="/etc/pacman.conf"
main()
{
  echo "Installation script for ArchStrike Penetration Testing and Security Layer - made by xorond"
  echo "This script will help you install ArchStrike on your Arch Linux running computer"
  sleep 3
  echo "> Starting installation process, are you ready? (y/n)"
  read choice
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
  echo "Backing up $pacmanconf to pacman.conf.bak"
  cp $pacmanconf ${pacmanconf}.bak
  sleep 2
  echo "Adding archstrike repositories to pacman.conf"
  echo "[archstrike]" >> $pacmanconf
  echo "Server = https://mirror.archstrike.org/$arch/$repo" >> $pacmanconf
  sleep 2
  echo "Done, it's mandatory to enable multilib for x86_64 architectures."
  echo "> Is your computer x86_64? (y/n)"
  read arch
  if [[ "$arch" == "y" ]]; then
    echo "> Do you have multilib enabled? (y/n)"
    read multilib
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
  pacman-key --init
  dirmngr < /dev/null
  pacman-key -r 7CBC0D53
  pacman-key --lsign-key 7CBC0D53
  echo "Done, installing required packages.."
  sleep 2
  pacman -S archstrike-keyring
  pacman -S archstrike-mirrorlist
  echo "Done, editing pacman.conf to use the mirrorlist.."
  sleep 2
  sed -i 's|Server = https://mirror.archstrike.org/$arch/$repo|Include = /etc/pacman.d/archstrike-mirrorlist|' $pacmanconf
  echo "> Done. Do you want to add archstrike-testing? (y/n)"
  read testing
  if [[ "$testing" == "y" ]]; then
    echo "[archstrike-testing]" >> $pacmanconf
    echo "Include = /etc/pacman.d/archstrike-mirrorlist" >> $pacmanconf
    echo "Added archstrike-testing"
  fi
  echo "Performing last database update.."
  pacman -Syy
  echo "You have successfully installed ArchStrike."
  echo "To see all the packages: 'pacman -Sl archstrike'"
  echo "To see all testing packages: 'pacman -Sl archstrike-testing'"
  echo "To see all groups: 'pacman -Sg | grep archstrike'"
  echo "To see all packages in a group: 'pacman -Sgg | grep archstrike-<groupname>'"
  echo "Thanks for installing ArchStrike!"
  echo "This was a script by xorond https://github.com/xorond"
  echo "More info on our website: https://archstrike.org"
  sleep 10
  exit 0
}
if [[ "$(whoami)" != "root" ]]; then
    echo "$0 can only be run as root, exiting."
    sleep 2
    exit 3
fi
main
exit 0
