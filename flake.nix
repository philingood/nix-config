{
  description = "Hacker`s flake";
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    ## TODO: not sure if it matters, but probably worth threading -darwin version through on darwin builds
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # defaulting to unstable these days

    flake-compat = {
      # Needed along with default.nix in root to allow nixd lsp to do completions
      # See: https://github.com/nix-community/nixd/tree/main/docs/examples/flake
      url = "github:inclyc/flake-compat";
      flake = false;
    };
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nps.url = "github:OleMussmann/Nix-Package-Search"; # use nps to quick search packages - requires gnugrep though
    nps.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    #nix-homebrew.inputs.brew-src.follows = "brew-src";
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
    }: let 
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./modules/overlays.nix {
            inherit inputs nixpkgs-unstable nixpkgs-stable nixpkgs-stable-darwin;
          })
          overlays
          ;
        config = import ./config.nix;
      };

    mkHome = username: modules: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit inputs username;};
        users."${username}".imports = modules;
      };
    };

   in {
      darwinConfigurations =
        let
          username = "hacker";
        in
        {
          HackerBook = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            specialArgs = {
              inherit inputs nixpkgs-stable nixpkgs-stable-darwin nixpkgs-unstable username;
            };
            modules = [
              nix-homebrew.darwinModules.nix-homebrew # Make it so I can pin my homebrew taps and actually roll things back
              {
                nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;

                  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                  enableRosetta = true;

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
          HackerMac = darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            pkgs = import nixpkgs { system = "x86_64-darwin"; };
            specialArgs = {
              inherit inputs nixpkgs-stable nixpkgs-stable-darwin nixpkgs-unstable username;
            };
            modules = [
              ./modules/darwin/linux-builder.nix
            ];
          };
        };
    };
}
