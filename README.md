# NixOS - Stateful HA Proxmox Cluster - `nuclearbomb`
This is a set of proof-of-concept NixOS configurations that uses `impermanence` with `home-manager` and `plasma-manager` to achieve a highly stylized development system with an entirely defined state.

![image](https://github.com/user-attachments/assets/619f39ba-9237-43a0-8410-93e1924dd682)
![image](https://github.com/user-attachments/assets/2c789cc4-3db1-42d6-9715-0e5656619275)
![image](https://github.com/user-attachments/assets/9316ee93-1018-444c-b386-3bc4a4dbba72)

## Impermanence
Being impermanent, everything besides choice directories are cleared at boot!

Besides directories that store credentials or (temporary) configuration, everything is wiped except for two specific choices:

* `~/Development`

I develop locally, for now. I have yet to find a suitible cloud development solution. Replit comes (came) close, but unfortunately their pricing is not what it used to be. May the `Hacker` plan rest in peace.

* `~/Games`

I would be okay with placing Lutris games in the Nix Store somehow, similar to how `osu!laser` is packaged, but it seems like there isn't a Nix-y way to do so yet :(

## Installation and Setup
Enter sudo:
* `sudo su`

Ephemerally download Git (and an editor of your choice):
* `nix-shell -p vim -p git`

Pick the drive you want to install NixOS on (it will be formatted, choose wisely)
* `lsblk`

Import this configuration and run [disko](https://github.com/nix-community/disko) with the drive you selected:
* `cd /tmp; git clone https://github.com/hiibolt/nixos.git`
* `sudo nix –experimental-features “nix-command flakes” run github:nix-community/disko – –mode disko /tmp/nixos/lib/disko/default.nix –arg device ‘“/dev/<your-drive-here>”’`

Generate template files to conveniently build a lot of Nix's fs, then remove configuration files and copy our own in (backing up to `/persist`):
* `sudo nixos-generate-config –no-filesystems –root /mnt`
* `rm -rf /mnt/etc/nixos; sudo mv /tmp/nixos /mnt/etc`
* `mkdir -p /mnt/persist/nixos; cp -r /mnt/etc/nixos /mnt/persist; rm -f /etc/nixos/configuration.nix; cp -r /mnt/etc/nixos/* /etc/nixos`

Before continuing, note the following caveats:
- If you have 16GB or less of RAM, consider switching `TMPDIR` prior to building or you may run into issues. Alternatively, use the `release-minimal` branch.
- This installation will likely conflict with any RAID drive formations. Consider disabling it in BIOS or reworking the `disko` setup.

Install and reboot on sub-32GB RAM:
* `sudo mkdir -p /mnt/persist/hypermeow && TMPDIR=/mnt/persist/hypermeow nixos-install –root /mnt –flake /mnt/etc/nixos#nuclearbombwarhead`
* `sudo rm -rf /mnt/persist/hypermeow/* && reboot`

Install and reboot:
* `nixos-install –root /mnt –flake /mnt/etc/nixos#nuclearbombwarhead`
* `reboot`

Once you've rebooted, clean up, build, and reboot a second time:
* `sudo mv /persist/nixos/* /persist/nixos/.* /etc/nixos && sudo rm -rf /persist/nixos && rb-s && reboot`


## Imperative Setup
There are some things which, for sake of security or legality, must be imperative.
### Log into services
Log into:
* GitHub via Librewolf
* GitHub via `gh auth login --insecure-storage`
* Tailscale
* Vesktop
* osu!lazer
### Download Games
Download ZZZ through Lutris
### Enable VSCode Server
* `systemctl --user enable auto-fix-vscode-server.service`


## Adding Additional Machines
### Graphical Machines
- Clone one of the existing machines with a GUI
- Rename usernames
- Add users
- Add per-machine desktop file to `.../<user>/desktops/<hostname>.nix`
- Add machine to `flake.nix`
### TTY-Only Machines
- Clone one of the existing machines without a GUI
- Rename usernames
- Add users
- Add machine to `flake.nix`
