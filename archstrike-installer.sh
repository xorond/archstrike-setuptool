#!/usr/bin/env bash
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
  echo "Backing up /etc/pacman.conf to pacman.conf.bak"
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak
  sleep 2
  echo "Adding archstrike repositories to pacman.conf"
  sudo echo "[archstrike]" >> /etc/pacman.conf
  sudo echo "Server = https://mirror.archstrike.org/$arch/$repo" >> /etc/pacman.conf
  sleep 2
  echo "Done, it's mandatory to enable multilib for x86_64 architectures."
  echo "> Is your computer x86_64? (y/n)"
  read arch
  if [[ "$arch" == "y" ]]; then
    echo "Now opening /etc/pacman.conf"
    echo "Please remove the comment lines in [multilib] and the following line"
    sleep 5
    sudo nano /etc/pacman.conf
    echo "Done, continuing"
  fi
  echo "Performing package database updates.."
  sleep 1
  sudo pacman -Syy
  echo "Installing ArchStrike keyring.."
  sleep 1
  sudo pacman-key --init
  sudo dirmngr < /dev/null
  sudo pacman-key -r 7CBC0D51
  sudo pacman-key --lsign-key 7CBC0D51
  echo "Done, installing required packages.."
  sudo pacman -S archstrike-keyring
  sudo pacman -S archstrike-mirrorlist
  echo "Done, editing pacman.conf to use the mirrorlist.."
  sudo sed -i 's|Server = https://mirror.archstrike.org/$arch/$repo|Include = /etc/pacman.d/archstrike-mirrorlist|' /etc/pacman.conf
  echo "> Done. Do you want to add archstrike-testing? (y/n)"
  read testing
  if [[ "$testing" == "y" ]]; then
    sudo echo "[archstrike-testing]" >> /etc/pacman.conf
    sudo echo "Include = /etc/pacman.d/archstrike-mirrorlist" >> /etc/pacman.conf
    echo "Done"
  fi
  echo "Performing last database update.."
  sudo pacman -Syy
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
main
exit 0
