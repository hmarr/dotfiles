# Quit System Preferences so it doesn't override settings
osascript -e 'tell application "System Preferences" to quit'

# Faster key repeat
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 2

# Disable press and hold for special characters
defaults write -g ApplePressAndHoldEnabled -bool false

# Default to the list view in Finder
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Unhide the ~/Library folder
chflags nohidden ~/Library

# Hide the Dock
defaults write com.apple.dock autohide -bool true

# Make the regular date and time menu bar item small, as I use Dato
defaults write com.apple.menuextra.clock IsAnalog -bool true

# See the changes
killall SystemUIServer
