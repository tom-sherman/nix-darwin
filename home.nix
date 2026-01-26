{
  config,
  pkgs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/jj/config.toml".source = dotfiles/jj.toml;
    ".config/rift/config.toml".source = dotfiles/rift.toml;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    fish = {
      enable = true;
      shellAliases = {
        # Nix
        build = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin";
        update = "nix flake update --flake ~/.config/nix-darwin";
        gc = "nix-collect-garbage -d";
        cat = "bat --paging=never";
      };

      # Rancher desktop (installed externally)
      shellInit = ''
        set -gx PATH $HOME/.rd/bin $PATH
      '';

      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "hydro";
          src = pkgs.fishPlugins.hydro.src;
        }
      ];
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Tom Sherman";
          email = "tom@sherman.is";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwoiSqgcnFqY+9q8wJTFYEjyoeHgcSUBQk25E8tCmQv";
        };
        core.editor = "code --wait";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;

        commit.gpgsign = true;
        # TODO: Get 1password installed via nix https://nixos.wiki/wiki/1Password
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };

      ignores = [ ".DS_store" ];

      includes =
        map
          (condition: {
            inherit condition;
            contents.user.email = "tom.sherman@civica.com";
            # Needed because GitHub doesn't allow the same key to be used for multiple accounts
            contents.user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9NU4OwpOAbIj4RYKoK4kDnkiSV3HnGCLuef8EAnhT2";
          })
          [
            "hasconfig:remote.*.url:git@github.com:civica/**"
            "hasconfig:remote.*.url:https://github.com/civica/**"
          ];
    };
  };
}
