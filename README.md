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

Put them in `~/.config/tokens.sh` (not in git, `chmod 600` it). It's sourced by fish, zsh and bash, so the tokens are also available to tools that run commands in a non-fish shell, like Claude Code:

```sh
export GITHUB_PKG_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
export JSR_TOKEN="jsrt_xxxxxxxxxxxxxxxxxxxx"
```

Update the relevant variable whenever a token expires — no file edits or git commits needed.
