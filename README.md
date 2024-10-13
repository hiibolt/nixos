# My NixOS 
This is a proof-of-concept NixOS configuration that uses `impermanence` with `home-manager` and `plasma-manager` to achieve a highly stylized development system with an entirely defined state.

Being impermanent, everything besides choice directories are cleared.

Besides directories that store credentials, everything is wiped except for two specific choices:

* `~/Development`
I develop locally, for now. I have yet to find a suitible cloud development solution. Replit comes (came) close, but unfortunately their pricing is not what it used to be. May the `Hacker` plan rest in peace.

* `~/Games`
I dislike the idea of waiting upwards of an hour for each reboot to redownload my games.

## Imperative Setup
Unfortunately, there are some things which, for sake of security or legality, must be imperative.
### Setting up passwords
It's probably a bad idea to store passwords declaratively publically ^^'

* `sudo mkdir -p /persist/passwords`
* `cd /persist/passwords`
* `mkpasswd`
* `echo "..." > root`
* `echo "..." > hiibolt`
### Unfree AppImages
Cider uses a not-for-distribution AppImage, so it must be downloaded, moved, and renamed into `x/etc/nixos/lib/cider/Cider-X.X.X.AppImage`
### Log into services
Log into:
* GitHub via Librewolf
* GitHub via `gh auth login --insecure-storage`
* Tailscale
* Vesktop
* osu!lazer
### Download Games
Download ZZZ through Lutris
### Reinject Gitfiles to `/etc/nixos`
* `cd /etc/nixos`
* `git clone https://github.com/hiibolt/nix.git`
* `mv nix/.gitignore nix/.git .`
* `rm -rf nix`