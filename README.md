[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://nixos.org/) [![Sway](https://img.shields.io/badge/Sway-customised-blue.svg?logo=gumtree)](https://swaywm.org/)

# Sway NixOS Configuration

This repository contains a Nix flake to set up Sway with a custom configuration on NixOS.

## Description

A custom tailored NixOS configuration targeting the Sway window manager, complemented with a range of packages to offer a robust and efficient environment.

## Prerequisites

1. NixOS with flake support enabled.
2. Ensure you are running on `x86_64-linux` architecture.

## Repo Structure

- `flake.nix`: The central configuration defining the system and home-manager setups, including dependencies.
- `user-config.nix`: Contains user-specific configurations like username and home directory.
- `configuration.nix`: NixOS system configuration.
- `home.nix`: Contains configurations for the user's environment, including home-manager packages and shell setup.
- `dotfiles/`: Contains various dotfiles that can be linked or copied to user's home.
- `build.sh`: Script to automate the deployment process.

## Usage

For easy deployment, simply run the provided `build.sh` script:

```bash
./build.sh
```

This script takes care of:

1. Generating the required `generated-files.nix` file.
2. Building and switching to the NixOS system configuration.
3. Switching to the user-specific home-manager configuration.

**Note**: Make sure the `build.sh` script has executable permissions (`chmod +x build.sh`).

## Dependencies

- `nixpkgs`: Uses the `nixos-unstable` branch of the official NixOS/nixpkgs repository on GitHub.
- `home-manager`: Sourced from the nix-community's home-manager repository. Note: It follows the same nixpkgs as defined in the flake.

## Contributing

Feel free to raise issues or submit Pull Requests if you find any problems or have suggestions for improvements.
