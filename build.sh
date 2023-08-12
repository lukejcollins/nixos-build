# This script triggers rebuilds for NixOS and home-manager.

# Rebuild NixOS with the current directory as a flake target named 'mySystem'
sudo nixos-rebuild switch --flake "$(pwd)#mySystem"

# Rebuild home-manager with the current directory as a flake target named 'myUser'
# and enabling extra experimental features.
home-manager switch --flake "$(pwd)#myUser" --extra-experimental-features nix-command --extra-experimental-features flakes
