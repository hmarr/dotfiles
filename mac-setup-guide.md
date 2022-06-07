# Mac setup guide

1. Install 1Password and sign in.
1. Go to System Preferences → Apple ID and sign in with your Apple ID.
1. Generate a new SSH key and add it to GitHub.
   ```
   ssh-keygen -t ed25519 -C hmarr@<HOSTNAME>
   ```
3. Set the new machine's hostname.
   ```
   bin/set-hostname.sh <HOSTNAME>
   ```
1. Remap the <kbd>caps lock</kbd> key to <kbd>control</kbd> in System Preferences → Keyboard → Modifier Keys.
1. Enable tap to click in System Preferences → Trackpad.
1. Clone this repository.
   ```
   git clone https://github.com/hmarr/dotfiles ~/src/github.com/hmarr/dotfiles
   ```
1. Link the dotfiles, and apply macOS settings.
   ```
   bin/install.sh
   bin/macos-settings.sh
   ```
1. Install Homebrew per the [instructions](https://brew.sh/) on the website.
1. Install command line tools, apps, and fonts with Homebrew.
   ```
   brew bundle --global
   ```
1. Update Alacritty's icon.
   ```
   bin/update-alacritty-icon.sh
   ```
1. Set up PGP key, add the following to `~/.gitconfig.local`, and make sure you can sign commits.
   ```
   [commit]
   	gpgsign = true
   ```
1. Sign in to Chrome, Raycast, Tailscale, Tweetbot, etc.
1. Copy configuration over for Rectangle and Raycast. Configure Amphetamine.
