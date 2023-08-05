# Sway Custom Configuration Flake

This flake provides a custom configuration for building [Sway](https://swaywm.org/), a tiling Wayland compositor, along with other related tools such as Waybar, Wob, and Blueman. It integrates with the [Home Manager](https://github.com/nix-community/home-manager) project and is designed for the Nix package manager.

## Description

This flake is designed to manage a user's Sway environment on a system with Nix. It includes customized configurations for Sway, Waybar, Wob, and Blueman, and sets up the necessary session variables and shell aliases.

## Dependencies

- Nixpkgs (NixOS/nixpkgs/nixos-unstable)
- Home Manager (nix-community/home-manager)

## Features

- **Sway**: Tiling Wayland compositor
- **Waybar**: Highly customizable Wayland bar
- **Wob**: An overlay volume/backlight/progress bar for Wayland
- **Blueman**: Manager for Bluetooth devices

## Configuration

The flake includes custom configurations for Sway, Waybar, Wob, and Blueman, which are located in the `dotfiles` directory.

The `PATH` variable is extended to include the binaries of these packages, and a custom shell alias `ll` is defined for convenience.

## Usage

To build and activate this configuration, you can use the following command:

```bash
nix build .#homeConfigurations.myUser.activationPackage --extra-experimental-features nix-command --extra-experimental-features flakes
```

Ensure you have enabled the necessary experimental features for flakes.

## Contributing

If you would like to contribute to this project or report issues, please feel free to open an issue or pull request.
