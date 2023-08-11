{ config, pkgs, ... }:

let
  userConfig = import ./user-config.nix;
in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.${userConfig.username} = {
     isNormalUser = true;
     home = userConfig.homeDirectory;
     shell = pkgs.zsh;
     extraGroups = [ "wheel" ];
   };
  
  programs.zsh.enable = true;
  
  sound.enable = true;

  hardware.pulseaudio.enable = true;
 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  hardware.bluetooth.powerOnBoot = true;

  boot.kernelPackages = pkgs.linuxPackages_6_4;

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


  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  system.stateVersion = "23.05";
  networking.networkmanager.enable = true;
}
