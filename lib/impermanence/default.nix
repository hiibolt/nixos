{ config, lib, pkgs, inputs, ... }:
{
    # Clear old `btrfs` subvolumes older than 30d recursively
    boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/root_vg/root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
    '';
    
    # Enable persistence
    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
            "/etc/nixos"
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/tailscale"
            "/etc/NetworkManager/system-connections"
            { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
        ];
        files = [
            "/etc/machine-id"
            # { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
        ];
    };
    programs.fuse.userAllowOther = true;

    # Ensure that our tempfiles have the correct file permissions
    systemd.tmpfiles = {
        rules = [ 
        "d /persist/home 0777 root root -" # Fix permissions for `/persist/home`
        "d /persist/home/hiibolt 0700 hiibolt users -" # Fix permissions for `/persist/home/hiibolt`
        ];
    };

    # `chown` `/etc/nixos` for `hiibolt`
    system.activationScripts = {
        chown-nixos-hiibolt.text =
        ''
        chown -R hiibolt /etc/nixos
        '';
    };
    system.userActivationScripts = {
        remove-gtk-files.text = 
        ''
        rm -f ~/.gtkrc-2.0
        rm -f ~/.gtkrc-2.0.meow
        '';
    };
}