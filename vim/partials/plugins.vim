set rtp+=~/dotfiles/vim/bundle/Vundle.vim
call vundle#begin('~/dotfiles/vim/bundle')

Plugin 'VundleVim/Vundle.vim'

" Consider using https://github.com/sheerun/vim-polyglot in the future?

" General

Plugin 'easymotion/vim-easymotion'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-speeddating'
Plugin 'godlygeek/tabular'
Plugin 'godlygeek/csapprox'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'AndrewRadev/switch.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'editorconfig/editorconfig-vim'
" Plugin 'terryma/vim-multiple-cursors'
Plugin 'kana/vim-textobj-user'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'honza/vim-snippets'
Plugin 'skywind3000/asyncrun.vim'

Plugin 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1

Plugin 'hlissner/vim-forrestgump'
let g:forrestgumps = {}

Plugin 'janko-m/vim-test'
let test#strategy = 'dispatch'

Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1

Plugin 'myusuf3/numbers.vim'
let g:numbers_exclude = ['tagbar', '']

Plugin 'Shougo/neosnippet'
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = '~/dotfiles/vim/bundle/vim-snippets/snippets'

Plugin 'neomake/neomake'
autocmd! BufWritePost * Neomake
let g:neomake_ruby_enabled_makers = ['rubocop', 'mri']
let g:neomake_javascript_enabled_makers = ['jscs', 'jshint']
let g:neomake_go_enabled_makers = [] " Disabled in favor of vim-go functionality

Plugin 'tpope/vim-projectionist'
let g:projectionist_heuristics = {}

Plugin 'junegunn/seoul256.vim'
let g:seoul256_background = 233

Plugin 'wincent/terminus'
let g:TerminusNormalCursorShape = 2

" Language specific

Plugin 'cespare/vim-toml'
Plugin 'kylef/apiblueprint.vim'
Plugin 'tpope/vim-markdown'
Plugin 'othree/yajs.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'nono/jquery.vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'

" Executable required

if executable('coffee')
  Plugin 'kchmck/vim-coffee-script'
endif

if executable('ctags')
  Plugin 'majutsushi/tagbar'
  let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
endif

if executable('git')
  Plugin 'gregsexton/gitv'
  Plugin 'tpope/vim-git'
  Plugin 'tpope/vim-fugitive'

  Plugin 'airblade/vim-gitgutter'
  highlight SignColumn term=underline ctermfg=101 ctermbg=232 guifg=#857b6f guibg=#121212
endif

if executable('go')
  Plugin 'fatih/vim-go'
  let g:go_fmt_command = 'goimports'
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_interfaces = 1
  let g:go_highlight_build_constraints = 1

  let g:projectionist_heuristics['*.go'] = {
        \ '*.go': { 'alternate': '{}_test.go', 'type': 'source' },
        \ '*_test.go': { 'alternate': '{}.go', 'type': 'test' }
        \}
endif

if executable('iex')
  Plugin 'elixir-lang/vim-elixir'
endif

if executable('lein')
  Plugin 'tpope/vim-fireplace'
  Plugin 'tpope/vim-classpath'
  Plugin 'guns/vim-clojure-highlight'
endif

if has('lua')
  Plugin 'Shougo/neocomplete.vim'
  let g:neocomplete#enable_at_startup = 1
elseif has('nvim')
  Plugin 'Shougo/deoplete.nvim'
  let g:deoplete#enable_at_startup = 1
else
  Plugin 'ervandew/supertab'
endif

if executable('lua')
  Plugin 'tbastos/vim-lua'
  Plugin 'xolox/vim-misc'

  Plugin 'xolox/vim-lua-ftplugin'
  let g:lua_complete_omni = 1
endif

if executable('php')
  Plugin 'spf13/PIV'
  let g:DisableAutoPHPFolding = 1
endif

if executable('python') || executable('python3')
  Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

  Plugin 'python-mode/python-mode'
  let g:pymode_lint = 0
  let g:pymode_rope = 0
  let g:pymode_folding = 0

  if has('nvim')
    Plugin 'zchee/deoplete-jedi'
  endif
endif

if executable('rails')
  Plugin 'tpope/vim-rake'

  Plugin 'tpope/vim-rails'
  let g:rails_gem_projections = {
        \ "pundit": {
        \   "app/policies/*_policy.rb": {
        \     "command": "policy",
        \     "affinity": "model",
        \     "alternate": "app/models/{}.rb"
        \   }
        \ },
        \ "draper": {
        \   "app/decorators/*_decorator.rb": {
        \     "command": "decorator",
        \     "affinity": "model",
        \     "alternate": "app/models/{}.rb"
        \   }
        \ },
        \ "factory_girl": {
        \   "test/factories/*_factories.rb": {
        \     "command": "factory",
        \     "affinity": "model",
        \     "alternate": "app/models/{}.rb"
        \   }
        \ }}
endif

if executable('ruby')
  Plugin 'tpope/vim-bundler'
  Plugin 'tpope/vim-haml'
  Plugin 'tpope/vim-cucumber'
  Plugin 'sunaku/vim-ruby-minitest'
  Plugin 'junegunn/fzf'

  Plugin 'junegunn/fzf.vim'
  let $FZF_DEFAULT_COMMAND = 'ag -g ""'
  command! -bang -nargs=* GGrep
    \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

  Plugin 'vim-ruby/vim-ruby'
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_rails = 1

  Plugin 'nelstrom/vim-textobj-rubyblock'
  runtime macros/matchit.vim
endif

if executable('rustc')
  Plugin 'racer-rust/vim-racer'
  let g:racer_experimental_completer = 1

  Plugin 'rust-lang/rust.vim'
  let g:rustfmt_autosave = 1

  let g:forrestgumps['rust'] = ['rustc']
endif

if executable('swift')
  Plugin 'keith/swift.vim'
endif

if executable('tmux')
  Plugin 'tpope/vim-tbone'
  Plugin 'christoomey/vim-tmux-navigator'
  Plugin 'tmux-plugins/vim-tmux'
endif

if executable('tsc')
  Plugin 'Quramy/tsuquyomi'
  Plugin 'leafgarland/typescript-vim'
  Plugin 'HerringtonDarkholme/yats.vim'
endif

call vundle#end()
