# Expects Ctrl+Opt+Cmd+Shift+F19 to be registered as a hotkey for Claude Quick Access in Claude Desktop preferences
osascript -e 'tell application "System Events" to key code 80 using {control down, option down, command down, shift down}'
