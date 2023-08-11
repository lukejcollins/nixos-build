{ config, pkgs, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

in {
  # Include hardware-specific configurations
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot settings related to systemd-boot and EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # User configurations based on imported user-specific settings
  users.users.${userConfig.username} = {
    isNormalUser = true;
    home = userConfig.homeDirectory;
    shell = pkgs.zsh; # Setting Zsh as the default shell
    extraGroups = [ "wheel" ]; # Adding the user to the wheel group for sudo privileges
  };

  # Enable ZSH for the system
  programs.zsh.enable = true;

  # Enable sound support
  sound.enable = true;

  # Enable PulseAudio for sound management
  hardware.pulseaudio.enable = true;

  # Bluetooth configurations
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull; # Use the full Bluez package for Bluetooth support
    powerOnBoot = true; # Power on Bluetooth devices at boot
  };

  # Blueman service for managing Bluetooth devices from the GUI
  services.blueman.enable = true;

  # Specify the Linux kernel package version
  boot.kernelPackages = pkgs.linuxPackages_6_4;

  # List of packages to be globally installed on the system
  environment.systemPackages = with pkgs; [
    alacritty
    neovim
    sway
    firefox
    wget
    docker
    wob
    libfido2
    gh
    swappy
    swaylock-effects
    nodejs
    python3
    python3Packages.pip
    shellcheck
    go
    wdisplays
    git
    waybar
    blueman
    github-cli
    light
    rofi
    dunst
    xfce.thunar
    libnotify
    home-manager
    pavucontrol
    alsa-utils
    grim
    bluez
  ];

  # OpenGL configuration settings
  hardware.opengl = {
    enable = true; # Enable OpenGL support
    driSupport = true; # Enable Direct Rendering Infrastructure support
  };

  # System version specification
  system.stateVersion = "23.05";

  # Enable NetworkManager for network management
  networking.networkmanager.enable = true;
}
