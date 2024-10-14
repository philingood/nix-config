{
  description = "Hacker`s flake";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.inputs.nix-darwin.follows = "darwin";
    # Declarative, pinned homebrew tap management
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;
    homebrew-services.url = "github:homebrew/homebrew-services";
    homebrew-services.flake = false;
    homebrew-cask-drivers.url = "github:homebrew/homebrew-cask-drivers"; # for flipper zero
    homebrew-cask-drivers.flake = false;
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-stable
    , nixpkgs-stable-darwin
    , nixpkgs-unstable
    , darwin
    , home-manager
    , nixos-hardware
    , nix-homebrew
    , ...
    }: {
      darwinConfigurations =
        let
          username = "hacker";
        in
        {
          attolia = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            specialArgs = {
              inherit sbhosts inputs nixpkgs-stable nixpkgs-stable-darwin nixpkgs-unstable username;
            };
            modules = [
              nix-homebrew.darwinModules.nix-homebrew # Make it so I can pin my homebrew taps and actually roll things back
              {
                nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;

                  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                  enableRosetta = false;

                  # User owning the Homebrew prefix
                  user = username;

                  # Declarative tap management
                  taps = with inputs; {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                    "homebrew/homebrew-bundle" = homebrew-bundle;
                    "homebrew/homebrew-services" = homebrew-services;
                    "homebrew/homebrew-cask-drivers" = homebrew-cask-drivers;
                  };

                  # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                  mutableTaps = false;

                  # should only need this once...
                  autoMigrate = false;
                };
              }
              ./modules/darwin
              home-manager.darwinModules.home-manager
              (mkHome username [
                ./modules/home-manager
                ./modules/home-manager/home-darwin.nix
              ])
            ];
          };
        };
    };
}
