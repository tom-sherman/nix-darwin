{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    _inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
    }:
    let
      configuration =
        { pkgs, lib, ... }:
        {
          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "1password-cli"
              "terraform"
            ];

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.nixfmt-rfc-style
            pkgs.nil
            pkgs.nixd

            pkgs.gh
            pkgs._1password-cli
            pkgs.bat
            pkgs.httpie
            pkgs.bundler
            pkgs.bruno
            pkgs.kubectl
            pkgs.cocoapods
            pkgs.flyctl
            pkgs.websocat
            pkgs.pv
            pkgs.terraform
            pkgs.terraform-ls
            pkgs.gnupg
            pkgs.rustup
            pkgs.cmake
            pkgs.vale
            pkgs.google-cloud-sdk
            pkgs.jujutsu
            pkgs.ripgrep

            pkgs.nodejs
            pkgs.corepack
            pkgs.deno
          ];

          system.primaryUser = "tom";
          system.activationScripts.postActivation.enable = true;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          security.pam.services.sudo_local.touchIdAuth = true;

          system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;

          system.defaults.finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXPreferredViewStyle = "clmv";
            ShowPathbar = false;
            ShowStatusBar = false;
            _FXShowPosixPathInTitle = false;
            _FXSortFoldersFirst = true;
          };

          system.defaults.controlcenter = {
            NowPlaying = false;
            Sound = true;
          };

          # system.defaults.CustomUserPreferences."~/Library/Preferences/ByHost/com.apple.Spotlight.plist" = {
          #   "MenuItemHidden" = true;
          # };

          system.defaults.dock = {
            magnification = true;
            tilesize = 46;
            largesize = 64;
          };

          users.users.tom = {
            name = "tom";
            home = "/Users/tom";
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#OVO-JG9F6LK4WY
      darwinConfigurations."OVO-JG9F6LK4WY" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.tom = import ./home.nix;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              autoMigrate = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "tom";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
        ];
      };
    };
}
