func! vundle#installer#install(bang, ...)
  if !isdirectory(g:bundle_dir) | call mkdir(g:bundle_dir, 'p') | endif
  let bundles = (a:1 == '') ?
        \ s:reload_bundles() :
        \ map(copy(a:000), 'vundle#config#init_bundle(v:val, {})')

  let installed = s:install(a:bang, bundles)
  redraw!
  let help_dirs = vundle#installer#helptags(bundles)
  call vundle#config#require(bundles)

  call s:log('Installed bundles: '.join(len(installed) > 0 ? map(installed, 'v:val.name') : 'none',','))

  if len(help_dirs) > 0
    call s:log('Helptags: done. '.len(help_dirs).' bundles processed')
  endif
endf

func! vundle#installer#helptags(bundles)
  let bundle_dirs = map(copy(a:bundles),'v:val.rtpath()')
  let help_dirs = filter(bundle_dirs, 's:has_doc(v:val)')
  call map(copy(help_dirs), 's:helptags(v:val)')
  return help_dirs
endf

func! vundle#installer#clean(bang)
  let bundle_dirs = map(copy(g:bundles), 'v:val.path()') 
  let all_dirs = split(globpath(g:bundle_dir, '*'), "\n")
  let x_dirs = filter(all_dirs, '0 > index(bundle_dirs, v:val)')
  if (!empty(x_dirs))
    " TODO: improve message
    if (a:bang || input('Are you sure you want to remove '.len(x_dirs).' bundles?') =~? 'y')
      exec '!rm -rf '.join(map(x_dirs, 'shellescape(v:val)'), ' ')
    endif
  end
endf

func! s:reload_bundles()
  " TODO: obtain Bundles without sourcing .vimrc
  silent source $MYVIMRC
  if filereadable($MYGVIMRC)| silent source $MYGVIMRC | endif
  return g:bundles
endf

func! s:has_doc(rtp)
  return (isdirectory(a:rtp.'/doc')
    \ && (!filereadable(a:rtp.'/doc/tags') || filewritable(a:rtp.'/doc/tags')))
endf

func! s:helptags(rtp)
  helptags `=a:rtp.'/doc'`
endf

func! s:sync(bang, bundle) 
  let git_dir = a:bundle.path().'/.git'
  silent exec '!echo "* '.a:bundle.name.'" 2>&1 >>'. g:vundle_log
  if isdirectory(git_dir)
    if !(a:bang) | return 0 | endif
    silent exec '!cd '.a:bundle.path().'; git pull 2>&1 >>'.g:vundle_log
  else
    silent exec '!git clone '.a:bundle.uri.' '.a:bundle.path().' 2>&1 >>'.g:vundle_log
  endif
  return 1
endf

func! s:install(bang, bundles)
  return filter(copy(a:bundles), 's:sync(a:bang, v:val)')
endf

" TODO: make it pause after output in console mode
func! s:log(msg)
  echo a:msg
endf
