{ config, pkgs, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

in
{
  # General System Configurations
  system.stateVersion = "23.05"; # System version specification
  nixpkgs.config.allowUnfree = true; # Enable non-free packages
  time.timeZone = "Europe/London"; # Set timezone

  # Hardware and Boot Configurations
  imports = [ ./hardware-configuration.nix ]; # Include hardware-specific configurations
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_4; # Specify the Linux kernel package version
  hardware.enableAllFirmware = true;
  
  # User Configurations
  users.users.${userConfig.username} = {
    isNormalUser = true;
    home = userConfig.homeDirectory;
    shell = pkgs.zsh; # Setting Zsh as the default shell
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Adding the user to groups
  };

  # Software and Package Configurations
  programs.zsh.enable = true; # Enable ZSH for the system
  environment.systemPackages = with pkgs; [ # List of packages to be globally installed
    alacritty neovim swayfx firefox-wayland wget docker wob libfido2 gh swappy swaylock-effects
    nodejs python3 python3Packages.pip shellcheck wdisplays git waybar blueman brightnessctl
    home-manager pavucontrol alsa-utils grim bluez dconf tidal-hifi vscode gnome.gnome-boxes 
    shfmt mako slurp wl-clipboard unzip statix nixpkgs-fmt neofetch rofi
  ];
  virtualisation.docker.enable = true; # Enable Docker

  # Sound and Media Configurations
  sound.enable = true; # Enable sound support
  security.rtkit.enable = true; # Enable RTKit for low-latency audio
  services.pipewire = { # Enable PipeWire for audio support
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true; # If you want to enable 32 bit application support
    };
    jack = {
      enable = true; 
    };
    pulse.enable = true; # This enables the PulseAudio compatibility modules
  };

  # Network and Bluetooth Configurations
  networking.networkmanager.enable = true; # Enable NetworkManager for network management
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull; # Use the full Bluez package for Bluetooth support
    powerOnBoot = true; # Power on Bluetooth devices at boot
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true; # Blueman service for managing Bluetooth

  # Graphical and Display Configurations
  systemd.user.services.mako = { # Create a systemd service for Mako notifications
    enable = true;
    description = "Mako notification daemon";
    unitConfig = {
      Type = "simple";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    serviceConfig = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "always";
      Environment = [ "WAYLAND_DISPLAY=wayland-1" ];
    };
    wantedBy = [ "graphical-session.target" ];
  };
  security.pam.services.swaylock = { allowNullPassword = true; }; # Enable PAM for Swaylock
  hardware.opengl = {
    enable = true; # Enable OpenGL support
    driSupport = true; # Enable Direct Rendering Infrastructure support
  };
  xdg.portal = {
    enable = true; # Enable xdg desktop integration
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
}
