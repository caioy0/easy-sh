#!/bin/zsh

# xcode prep
if xcode-select -p >/dev/null 2>&1; then
  echo "✅ Xcode Command Line Tools already installed!"
else  
  echo "🔧 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "⚠️  A GUI popup has appeared. Please complete the Xcode installation, then press Enter here to continue..."
  read -r
fi

# Brew setup
if command -v brew >/dev/null 2>&1; then
  echo "✅ Homebrew already installed!: $(brew --version | head -n1)"
else
  echo "🔧 Installing Homebrew!"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Explicitly check for the brew binary to avoid false positives on Intel Macs
  if [[ -f /opt/homebrew/bin/brew ]]; then
    echo "Configuring Homebrew for Apple Silicon..."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    echo "Configuring Homebrew for Intel..."
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  echo "✅ Homebrew installed!"
fi

# Brew apps
brew update && brew upgrade
brew install --cask iina firefox kitty zed font-jetbrains-mono-nerd-font \
  font-hack-nerd-font

# Cargo
if command -v cargo >/dev/null 2>&1; then
  echo "✅ cargo already installed!: $(cargo --version)"
else
  echo "🔧 Installing Rust/Cargo..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# eza
if command -v eza >/dev/null 2>&1; then
  echo "✅ eza already installed!"
else
  echo "🔧 Installing eza via cargo..."
  cargo install eza
fi

# ani-cli
# if ! command -v ani-cli >/dev/null 2>&1; then
#   git clone "https://github.com/pystardust/ani-cli.git" && cd ./ani-cli
#   cp ./ani-cli "$(brew --prefix)"/bin
#   cd .. && rm -rf ./ani-cli
# fi