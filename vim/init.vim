source ~/dotfiles/vim/partials/settings.vim

let g:mapleader="\<Space>"

source ~/dotfiles/vim/partials/mappings.vim

augroup betterment
  autocmd TermOpen * setlocal nonumber norelativenumber
  autocmd VimEnter * :redraw!
  autocmd VimResized * wincmd =
augroup END

filetype off

source ~/dotfiles/vim/partials/plugins.vim

filetype plugin indent on

if !exists('g:syntax_on')
  syntax enable
endif

source ~/dotfiles/vim/partials/filetype.vim
source ~/dotfiles/vim/partials/functions.vim

colors seoul256
