# NixOS - `nuclearbomb`
Multi-host NixOS configuration for `nuclearbombconsole` (laptop) and `nuclearbombwsl` (WSL).

![image](https://github.com/user-attachments/assets/619f39ba-9237-43a0-8410-93e1924dd682)
![image](https://github.com/user-attachments/assets/2c789cc4-3db1-42d6-9715-0e5656619275)
![image](https://github.com/user-attachments/assets/9316ee93-1018-444c-b386-3bc4a4dbba72)

## Layout
```
devices/   — per-host configuration.nix + hardware-configuration.nix
hardware/  — CPU/GPU modules
lib/       — shared modules (shell, kanata, maintenance, fingerprint, etc.)
users/     — user packages, programs, and shell config
```

## Rebuild
```bash
rb-s   # nixos-rebuild switch
rb-b   # nixos-rebuild boot
```

## Fresh Install
Enter sudo and drop into a shell with the tools you need:
```bash
sudo su
nix-shell -p git
```

Partition and format the target drive (`lsblk` to pick one):
```bash
cd /tmp && git clone https://github.com/hiibolt/nixos.git
parted /dev/<drive> -- mklabel gpt
# ESP, swap, root — see hardware-configuration.nix for the expected layout
nixos-generate-config --no-filesystems --root /mnt
```

Copy config and install:
```bash
rm -rf /mnt/etc/nixos && mv /tmp/nixos /mnt/etc/nixos
nixos-install --root /mnt --flake /mnt/etc/nixos#nuclearbombconsole
reboot
```

## Imperative Setup
After first boot:
- `gh auth login --insecure-storage`
- `tailscale up`
- Log into Vesktop, Spotify, osu!lazer, Librewolf

## Adding a Machine
1. Copy an existing device under `devices/`
2. Run `nixos-generate-config` on the target and drop the result in as `hardware-configuration.nix`
3. Add the host to `flake.nix`
