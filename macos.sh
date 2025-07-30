#!/bin/zsh

if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew already installed!: $(brew --version | head -n1)"
else
echo "🔧 Installing Homebrew!"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d /opt/homebrew/bin ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d /usr/local/bin ]]; then
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  echo "✅ Homebrew installed!"
fi

brew update && brew upgrade

if [[ ! -d "$HOME/dotfiles" ]]; then
    cp -r dotfiles $HOME
    ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/dotfiles/.p10k.zsh $HOME/.p10k.zsh
    ln -sf $HOME/dotfiles/.config $HOME/.config
    ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/kitty
    ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/nvim
fi