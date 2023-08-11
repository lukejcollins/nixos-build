{ pkgs, lib, config, ... }:

let
  userConfig = import ./user-config.nix;
  generatedFiles = import ./generated-files.nix;

  # Define Python environment with required packages
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim
    flake8
    pylint
    black
  ]);

in {
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    fontconfig font-awesome_5 cantarell-fonts noto-fonts myPythonEnv
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
  };

  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.sessionVariables = {
    PATH = with pkgs; "${myPythonEnv}/bin:$PATH";
  };
  
  home.file = generatedFiles;

  home.stateVersion = "22.05";
}
