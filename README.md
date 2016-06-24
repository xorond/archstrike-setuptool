# archstrike-installer
Command line installer for ArchStrike penetration testing layer.


## WARNING

This script **will not install Arch Linux for you**. This is made for making the install process easier for the **ArchStrike repository**.

More info: https://archstrike.org

## Installing & Using

To run the script, get the source file archstrike-installer.sh

You can do so by running

````bash
git clone https://github.com/xorond/archstrike-installer
cd archstrike-installer
```

Then run

`chmod +x archstrike-installer.sh`

to give executable permissions on the script.

To start the install process (you need to be root):

`./archstrike-installer.sh`

If you want, you can also get it from [AUR](https://aur.archlinux.org/packages/archstrike-installer-git/)

Just run your install command for the AUR helper you use (yaourt, packer etc.)

Examples:

`yaourt -S archstrike-installer-git`

`packer -S archstrike-installer-git`

Then simply run

`archstrike-installer`

and the process will start.

## Bugs & Issues 

Bugs, issues etc. can be reported via the github issue tracker.
