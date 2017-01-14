#!/bin/bash

# TODO: Check whether the inclusion of .dotfiles/bash_profile exists in either
# ~/.bashrc or ~/bashrc and write it otherwise


function ask_should_symlink() {
  while true; do
      read -p "Do you want to symlink $1 to $2 ? " yn
      case $yn in
          [Yy]* ) symlink_safe $1 $2; break;;
          [Nn]* ) return ;;
          * ) echo "Please answer yes or no.";
      esac
  done
}

function symlink_or_ask() {
  if [ -f $2 ]; then
    ask_should_symlink $1 $2
  else
    ln -s $1 $2
  fi
}

function backup_move() {
  SCRIPT_TIME=`date +%Y%m%d%H_%M_%S`
  mv $1 "${1}_${SCRIPT_TIME}"
}

function symlink_safe() {
  if [ -f $2 ]; then
    backup_move $2 && ln -sf $1 $2
  else
    ln -sf $1 $2
  fi
}

symlink_or_ask ~/.dotfiles/shells/bashrc ~/.bash_profile
symlink_or_ask ~/.dotfiles/shells/bashrc ~/.bashrc

# git config
symlink_or_ask ~/.dotfiles/git/gitconfig ~/.gitconfig
symlink_or_ask ~/.dotfiles/git/gitignore_global ~/.gitignore_global

symlink_or_ask ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
symlink_or_ask ~/.dotfiles/shells/zshrc ~/.zshrc
symlink_or_ask ~/.dotfiles/ruby/irbrc ~/.irbrc
symlink_or_ask ~/.dotfiles/vim ~/.vim
symlink_or_ask ~/.dotfiles/vim/vimrc ~/.vimrc
symlink_or_ask ~/.dotfiles/vim/nvimrc ~/.nvimrc
symlink_or_ask ~/.dotfiles/vim/ ~/.nvim
symlink_or_ask ~/.dotfiles/vim/ideavimrc ~/.ideavimrc
symlink_or_ask ~/.dotfiles/vim/gvimrc ~/.gvimrc
symlink_or_ask ~/.dotfiles/ctags ~/.ctags
symlink_or_ask ~/.dotfiles/agignore ~/.agignore
symlink_or_ask ~/.dotfiles/composer ~/.composer

# install vundle
if [ ! -f ~/.dotfiles/vim/Vundle.vim ]; then
  cd ~/.dotfiles/vim && git clone https://github.com/gmarik/Vundle.vim.git
  vim +BundleInstall +BundleClean +BundleClean +quitall
fi
# install pathogen
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -f ~/.oh-my-zsh/antigen.zsh ]; then
  curl https://cdn.rawgit.com/zsh-users/antigen/v1.3.2/bin/antigen.zsh > ~/.oh-my-zsh/antigen.zsh
  source ~/.oh-my-zsh/antigen.zsh
fi

# cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer

cd ~/.dotfiles/composer && composer install
cd -

git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
