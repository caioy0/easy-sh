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
