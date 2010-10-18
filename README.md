## About

** Warning: alpha quality **

[Vundle] is a short cut for [Vim]bundle and is a 67 LOC plugin for managing [Vim] plugins.


## Installation

    curl http://github.com/gmarik/vundle/raw/master/plugin/vundle.vim > ~/.vim/plugin/vundle.vim

## Configuration

Append those lines to your .vimrc

    Bundle "http://github.com/vim-scripts/L9.git"
    Bundle "http://github.com/vim-scripts/FuzzyFinder.git"
    Bundle "http://git.wincent.com/command-t.git"
    Bundle "http://github.com/vim-scripts/rails.vim.git"
    Bundle "http://github.com/vim-scripts/ack.vim.git"
    BundleRequire

BTW using [Vim-Scripts.org](http://vim-scripts.org) we have access to all vim plugins.

## Installing bundled plugins

    vim  -e -c 'BundleInstall' -c 'q'

triggers [Git clone](http://gitref.org/creating/#clone) for each configured repo to <code>~/.vim/bundle/</code>.

## Thanks

* [Pathogen]
* [Bundler]

## TODO:

* improve code (as this is my first [Vim] plugin
* support non [Git] resources aswell

[Vundle]:http://github.com/gmarik/vundle
[Pathogen]:http://github.com/tpope/vim-pathogen/
[Bundler]:http://github.com/wycats/bundler/
[Vim]:http://vim.org
[Git]:http://git-scm.com
