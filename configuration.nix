{ config, pkgs, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

in
{
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
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Adding the user to the wheel group for sudo privileges
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

  # Enable non-free packages
  nixpkgs.config.allowUnfree = true;

  # Set timezone
  time.timeZone = "Europe/London";

  # List of packages to be globally installed on the system
  environment.systemPackages = with pkgs; [
    alacritty
    neovim
    sway
    firefox-wayland
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
    wdisplays
    git
    waybar
    blueman
    github-cli
    brightnessctl
    rofi
    dunst
    xfce.thunar
    libnotify
    home-manager
    pavucontrol
    alsa-utils
    grim
    bluez
    dconf
    tidal-hifi
    vscode
    gnome.gnome-boxes
    shfmt
    mako
    slurp
    wl-clipboard
    unzip
    statix
    nixpkgs-fmt
    neofetch
  ];

  # Enable Docker
  virtualisation.docker.enable = true;

  # Create a systemd service for the Mako notification daemon
  systemd.user.services.mako = {
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
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
      ];
    };

    wantedBy = [ "graphical-session.target" ];
  };

  # Enable PAM for Swaylock
  security.pam.services.swaylock = {
    allowNullPassword = true;
  };

  # OpenGL configuration settings
  hardware.opengl = {
    enable = true; # Enable OpenGL support
    driSupport = true; # Enable Direct Rendering Infrastructure support
  };

  # System version specification
  system.stateVersion = "23.05";

  # Enable NetworkManager for network management
  networking.networkmanager.enable = true;

  # Enable PipeWire
  services.pipewire.enable = true;

  # Enable xdg desktop integration
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
