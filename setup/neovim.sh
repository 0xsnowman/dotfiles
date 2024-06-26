#!/bin/bash

set -x

VIMPATH="$HOME/dotfiles/.config/nvim"

install_standard() {
  ln -s "$VIMPATH" "$HOME/.config/nvim"
}

install_macos() {
  # Neovim Setup
  brew tap neovim/neovim
  brew install neovim --HEAD --build-from-source

  install_standard
}

install_ubuntu() {
  if [[ -z $SPIN ]]; then
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install -y neovim
  fi

  install_standard
}

update_python() {
  pip3 install --upgrade pynvim
}

update() {
  # Client
  brew reinstall neovim --build-from-source

  # Dependencies
  update_python
  gem update neovim
  yarn global add neovim
}

case "$1" in
  install_macos)
    install_macos
  ;;

  install_ubuntu)
    install_ubuntu
  ;;

  install_python)
    install_python
  ;;

  update)
    update
  ;;

  update_python)
    update_python
  ;;

  *)
    install
esac
