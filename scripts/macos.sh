#!/bin/zsh

# Brew setup
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

# Brew apps
brew update && brew upgrade
brew install curl grep aria2 ffmpeg git fzf yt-dlp && \
brew install --cask iina

# ani-cli
if ! command -v ani-cli >/dev/null 2>&1; then
  git clone "https://github.com/pystardust/ani-cli.git" && cd ./ani-cli
  cp ./ani-cli "$(brew --prefix)"/bin
  cd .. && rm -rf ./ani-cli
else # update
  cd /tmp && \
  git clone https://github.com/pystardust/ani-cli.git && \
  cp ./ani-cli/ani-cli "$(brew --prefix)"/bin && \
  rm -rf ./ani-cli
fi

# omz
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    printf "omz install"
    sleep 1
    echo "n" | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# omz pluggins
# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# fzf-zsh-plugin
if [[ ! -d "$ZSH_CUSTOM/plugins/fzf-zsh-plugin" ]]; then
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git "$ZSH_CUSTOM/plugins/fzf-zsh-plugin"
fi

# fast-syntax-highlighting
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fzf-zsh-plugin"
fi

# powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# backup .zshrc
printf "Backup .zshrc? [y or n]: "
read -r OPTION
if [[ "$OPTION" == Y || "$OPTION" == y ]]; then 
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# backup .config
printf "Backup .config? [y or n]: "
read -r OPTION
if [[ "$OPTION" == Y || "$OPTION" == y ]]; then 
  cp -r "$HOME/.config" "$HOME/.config.bak"
fi

# dotfiles
if [[ ! -d "$HOME/dotfiles" ]]; then
    cp -rf ../dotfiles/ $HOME
else
    echo "[~] Updating dotfiles..."
    sleep 1
   cp -rf ../dotfiles/ $HOME
    if [[ ! -d "$HOME/.config" ]]; then
        mkdir -p "$HOME/.config"
    fi
fi

# links
ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/.config/kitty $HOME/.config/
ln -sf $HOME/dotfiles/.config/nvim/ $HOME/.config/
ln -sf $HOME/dotfiles/.config/fastfetch/ $HOME/.config/

printf "\nThats it ༼ つ ◕_◕ ༽つ \n"
