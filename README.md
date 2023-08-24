[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://nixos.org/) [![Sway](https://img.shields.io/badge/Sway-customised-blue.svg?logo=gumtree)](https://swaywm.org/)

# Sway NixOS Configuration

This repository contains a Nix flake to set up Hyprland with a custom configuration on NixOS.

## Description

A custom tailored NixOS configuration targeting the Hyprland window manager, complemented with a range of packages to offer a robust and efficient environment.

## Prerequisites

1. NixOS with flake support enabled.
2. Ensure you are running on `x86_64-linux` architecture.

## User Configuration

The repository includes a `user-config.nix` file that has been set up with my user details for flake purity. If you intend to use this configuration, you'll need to update this file with your details:

```nix
{
  username = "yourUsername";      # Replace 'yourUsername' with your actual username
  homeDirectory = "/home/yourUsername";  # Adjust the path accordingly
}
```

## Flake Build Commands

To build the flake, you'll need to run the following commands:

```bash
sudo nixos-rebuild switch --flake "$(pwd)#mySystem"
home-manager switch --flake "$(pwd)#myUser" --extra-experimental-features nix-command --extra-experimental-features flakes
```

Once the flake has been built, you can run further builds from the flake repo with the `flake-build` custom alias I have set up.

## Repo Structure

- `flake.nix`: The central configuration defining the system and home-manager setups, including dependencies.
- `configuration.nix`: NixOS system configuration.
- `home.nix`: Contains configurations for the user's environment, including home-manager packages and shell setup.
- `user-config.nix`: User and home path details
= `hyprland-config.nix`: Config for the Hyprland window manager
- `dotfiles/`: Contains various dotfiles that can be linked or copied to user's home.

## Dependencies

- `nixpkgs`: Uses the `nixos-unstable` branch of the official NixOS/nixpkgs repository on GitHub.
- `home-manager`: Sourced from the nix-community's home-manager repository. Note: It follows the same nixpkgs as defined in the flake.

## Contributing

Feel free to raise issues or submit Pull Requests if you find any problems or have suggestions for improvements.
