{
  description = "A flake for building Hyprland with custom configuration";

  # Define Flake inputs
  inputs = {
    # Import the unstable branch of Nixpkgs from GitHub
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Import Home Manager for user-specific configurations
    home-manager.url = "github:nix-community/home-manager";
    # Ensure that Home Manager uses the same Nixpkgs version as this Flake
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Import Hyprland for the Hypr window manager and related configurations
    hyprland.url = "github:hyprwm/hyprland/b662215fad037e41872d5b820a70577752469520";

    # Import hy3: a plugin for the Hypr window manager
    hy3 = {
      url = "github:outfoxxed/hy3/43402f85ff1424aa7bd93d916c82cf781f9074cd";
      # Ensure that hy3 uses the same version of Hyprland as this Flake
      inputs.hyprland.follows = "hyprland";
    };

    # Import nixGL to provide support for OpenGL drivers in the Nix environment
    nixgl.url = "github:guibou/nixGL/main";
  };

  # Define the outputs of the Flake
  outputs = { self, nixpkgs, home-manager, hyprland, hy3, nixgl, ... } @ inputs:
  let
    # Fetch the unmodified version of Nixpkgs
    basePkgs = import nixpkgs {
      system = "x86_64-linux";
    };

    # Fetch Nixpkgs with an added overlay for nixGL
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ nixgl.overlay ];
    };
  in
  {
    # User-specific configurations imported from an external file
    userConfig = import ./user-config.nix;

    # Define NixOS configurations for a specific system
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Pass special arguments to the system configuration
      specialArgs = { inherit inputs; };
      modules = [
        # Import the main configuration module
        (import ./configuration.nix)
        # Import hardware-specific configurations
        (import ./hardware-configuration.nix)
      ];
    };

    # Define Home Manager configurations for a user
    homeConfigurations.myUser = home-manager.lib.homeManagerConfiguration {
      # Use the modified package set with nixGL overlay
      pkgs = pkgs;
      
      modules = [
        # Import the main home configuration module
        (import ./home.nix)
        # Import the Hyprland specific configuration
        (import ./hyprland-config.nix)
        # Integrate default Hyprland Home Manager modules
        hyprland.homeManagerModules.default
        {
          # Configure the Hypr window manager
          wayland.windowManager.hyprland = {
            enable = true;
            # Use the hy3 plugin with Hypr
            plugins = [ hy3.packages.x86_64-linux.hy3 ];
            recommendedEnvironment = true;
            systemdIntegration = true;
            xwayland.enable = true;
          };
          # Add nixGLIntel package for OpenGL support
          home.packages = [
            pkgs.nixgl.nixGLIntel
          ];
        }
      ];
    };
  };
}
