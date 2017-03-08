puts "Setting up Workstation..."

defaults write com.apple.dock autohide -bool true
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/bundle
brew bundle

# zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm $HOME/.zshrc && ln -s $PWD/zsh/.zshrc $HOME/.zshrc
touch $HOME/.zsh_custom

# git
ln -s $PWD/.gitconfig $HOME/.gitconfig

# vim
ln -s $PWD/vim/.vimrc $HOME/.vimrc
ln -s $PWD/vim $HOME/.vim

# hammerspoon
ln -s $PWD/hammerspoon $HOME/.hammerspoon

# ruby
ruby-install --latest ruby
chruby ruby
ruby -v | awk {'print "chruby " $2'} >> $HOME/.zsh_custom
gem install bundler
gem install tmuxinator

# tmux
ln -s $PWD/tmux/.tmux.conf $HOME/.tmux.conf

# node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
nvm install node

# rust
curl https://sh.rustup.rs -sSf | sh
rustup component add rust-src
rust_toolchain=`rustup toolchain list | awk {'print $1'}`
echo "export RUST_SRC_PATH=\"\$HOME/.multirust/toolchains/$rust_toolchain/lib/rustlib/src/rust/src\"" >> $HOME/.zsh_custom
cargo install rustfmt
cargo install racer

# go
go get -u github.com/nsf/gocode

# neovim
git clone https://github.com/Shougo/dein.vim vim/bundle/dein.vim
mkdir -p $HOME/.config
ln -s $PWD/vim $HOME/.config/nvim
gem install neovim
pip2 install neovim
pip3 install neovim

echo "Workstation setup complete."