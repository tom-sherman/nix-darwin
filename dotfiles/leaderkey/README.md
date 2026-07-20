[Leaderkey](https://github.com/mikker/LeaderKey) config lives in this directory.

The app requires the config to be called `config.json` but it can live in any directory, you then point the app to that directory in the preferences.

This config isn't symlinked like most of the other dotfiles, just point the app at ~/.config/nix-darwin/dotfiles/leaderkey and it will find the config.json file.
