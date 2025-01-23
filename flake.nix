{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    _inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration =
        { pkgs, lib, ... }:
        {
          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "1password-cli"
            ];

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.nixfmt-rfc-style
            pkgs.nil

            pkgs.gh
            pkgs._1password-cli

            pkgs.nodejs
            pkgs.corepack
          ];

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

          security.pam.enableSudoTouchIdAuth = true;

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

          system.defaults.CustomUserPreferences."~/Library/Preferences/ByHost/com.apple.Spotlight.plist" = {
            "MenuItemHidden" = true;
          };

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
        ];
      };
    };
}
