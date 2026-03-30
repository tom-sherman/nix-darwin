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
