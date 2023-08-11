{ pkgs, lib, config, ... }:

let
  # Import user-specific configuration
  userConfig = import ./user-config.nix;

  # Import generated file definitions
  generatedFiles = import ./generated-files.nix;

  # Define a Python environment with the specified packages
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim
    flake8
    pylint
    black
  ]);
in
{
  # Enable fontconfig for font management
  fonts.fontconfig.enable = true;

  # Specify packages to be installed for the user
  home.packages = with pkgs; [
    fontconfig
    font-awesome_5
    cantarell-fonts
    noto-fonts
    myPythonEnv
  ];

  # ZSH shell configuration
  programs.zsh = {
    enable = true;  # Enable ZSH as the shell

    # Set aliases for ZSH shell
    shellAliases = {
      vim = "nvim";  # Use 'nvim' when 'vim' is called
    };
  };

  # Set user-specific details from the imported configuration
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # Dconf modifications
  dconf.settings = {
    "org/blueman/general/auto-power-on" = { value = true; };
  };

  # Adjust user's PATH to include the Python environment binaries
  home.sessionVariables = {
    PATH = with pkgs; "${myPythonEnv}/bin:$PATH";
  };

  # Include the generated file definitions
  home.file = generatedFiles;

  # Specify the state version for home-manager
  home.stateVersion = "22.05";
}
