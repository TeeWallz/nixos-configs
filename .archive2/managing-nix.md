# Packages

## Search for packages
https://search.nixos.org/packages


# Flakes

## OS
### Apply flake on fresh machine
```bash
# Bootstrap git
nix shell nixpkgs#git

# Install nixos
nixos-install --flake .#hostname
```

### Apply flake on set-up machine
```bash
sudo nixos-rebuild switch --flake .#hostname
```

## Home config/packages
```bash
home-manager switch --flake .#username@hostname
```






















# NIXOS

# Applying configs
## Testing

## Just build
Good for checking for errors
```sh
sudo nixos-rebuild build
```

## Build and switch live system
- Build a config
- Switch running system
- Don't set it to the default boot.
```sh
nixos-rebuild test
```

## Make new non-default profile
```sh
nixos-rebuild switch -p test
```

# Build into a virtual machine and load into qemu
```sh
nixos-rebuild build-vm
./result/bin/run-*-vm
```
 
 The VM does not have any data from your host system, so your existing user accounts and home directories will not be available unless you have set mutableUsers = false. Another way is to temporarily add the following to your configuration:

```sh
users.users.your-user.initialHashedPassword = "test";
```

# Saving default boot profile
## Make for next reboot
- Build a config
- Don't Switch running system
- Set it to the default boot.
```sh
nixos-rebuild boot
```

## Build, set to boot default and switch
```sh
sudo nixos-rebuild switch
```


# Upgrading NixOS

## Apply new channel
```sh
sudo nix-channel --add https://nixos.org/channels/nixos-XX.XX nixos
```

## Upgrade OS
```sh
sudo nixos-rebuild switch --upgrade
```
which is equivalent to **nix-channel --update nixos; nixos-rebuild switch.**


## Automatic Upgrades
```sh
system.autoUpgrade.enable = true;
system.autoUpgrade.allowReboot = true;
```




