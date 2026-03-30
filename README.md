# my macos nix config

and dotfiles

## Setup

Copy `local.nix.example` to `local.nix` and fill in your machine's hostname and username:

```sh
cp local.nix.example local.nix
```

Then edit `local.nix` with your values. `local.nix` is gitignored so it stays local to each machine.

To find your hostname, run:

```sh
scutil --get LocalHostName
```

To apply the configuration:

```sh
sudo darwin-rebuild switch --flake ~/.config/nix-darwin --impure
```

The `--impure` flag is required so Nix can read `local.nix` (which is not tracked by git).
