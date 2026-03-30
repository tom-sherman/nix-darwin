# my macos nix config

and dotfiles

## Setup

Edit `local.nix` to set your machine's hostname and username:

```nix
{
  hostname = "your-hostname";  # run `scutil --get LocalHostName` to find this
  username = "Your.Username";
}
```

To apply the configuration:

```sh
sudo darwin-rebuild switch --flake ~/.config/nix-darwin
```

## npm auth tokens

`~/.npmrc` is managed by nix and symlinked from `dotfiles/.npmrc`. Auth tokens are read from
environment variables so they stay out of git and can differ per machine.

Set the following in your shell environment (e.g. `~/.config/fish/conf.d/tokens.fish`):

```fish
set -gx GITHUB_PKG_TOKEN "ghp_xxxxxxxxxxxxxxxxxxxx"
set -gx JSR_TOKEN "jsrt_xxxxxxxxxxxxxxxxxxxx"
```

Update the relevant variable whenever a token expires — no file edits or git commits needed.
