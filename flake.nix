{
  # Description of the flake
  description = "A flake for building Sway with custom configuration";

  # Define inputs
  inputs = {
    # Use the unstable branch of Nixpkgs from GitHub
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Import home-manager
    home-manager.url = "github:nix-community/home-manager";

    # Ensure home-manager uses the same nixpkgs as this flake
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Define the outputs of the flake
  outputs = { self, nixpkgs, home-manager }: {
    # Import user-specific configuration
    userConfig = import ./user-config.nix;

    # NixOS system configuration
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # System architecture

      # List of NixOS configuration modules
      modules = [
        (import ./configuration.nix)
        (import ./hardware-configuration.nix)
      ];
    };

    # Home-manager user configurations
    homeConfigurations.myUser = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Package set for user environment

      # Home-manager modules for user environment
      modules = [ (import ./home.nix) ];
    };
  };
}
