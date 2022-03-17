" The encoding displayed.
set encoding=utf-8
set sessionoptions+=globals
let g:config_files = [
      \ 'globals.vim',
      \ 'options.vim',
      \ 'autocommands.vim',
      \ 'mappings.vim',
      \ 'plugins.vim',
      \ 'themes.vim'
      \ ]

for s:fname in g:config_files
  execute printf('source %s/core/%s', stdpath('config'), s:fname)
endfor

" let g:rainbow_conf = {
" \	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
" \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
" \	'guis': [''],
" \	'cterms': [''],
" \	'operators': '_,_',
" \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
" \	'separately': {
" \		'*': {},
" \		'markdown': {
" \			'parentheses_options': 'containedin=markdownCode contained', 
" \		},
" \		'vim': {
" \			'parentheses_options': 'containedin=vimFuncBody', 
" \		},
" \		'css': 0, 
" \	}
" \}
" let g:NERDTreeGitStatusWithFlags = 1
" let g:NERDTreeIgnore = ['^node_modules$']
" function! IsNERDTreeOpen()
"   return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction

" " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" " file, and we're not in vimdiff
" function! SyncTree()
"   if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
"     NERDTreeFind
"     wincmd p
"   endif
" endfunction

" " Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
