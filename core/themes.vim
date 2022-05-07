" let s:theme_setup_dict = {}

" function! s:theme_setup_dict.one() dict abort
"   set background=dark
"   colorscheme one
" endfunction

" function! s:theme_setup_dict.sonokai() dict abort
"   let g:sonokai_enable_italic = 1
"   let g:sonokai_better_performance = 1
"   " set background=dark
"   colorscheme sonokai
" endfunction

" " Theme to directory name mapping, because theme repo name is not necessarily
" " the same as the theme name itself.
" let s:theme2dir = {
"       \ 'one': 'one.vim',}

" let s:theme = utils#RandElement(keys(s:theme2dir))
" let s:colorscheme_func = printf('s:theme_setup_dict.%s()', s:theme)

" if !has_key(s:theme_setup_dict, s:theme)
"   let s:msg = "Invalid colorscheme function: " . s:colorscheme_func
"   call v:lua.vim.notify(s:msg, 'error', {'title': 'nvim-config'})
"   finish
" endif

" let s:status = utils#add_pack(s:theme2dir[s:theme])
" if !s:status
"   echomsg printf("Theme %s not installed. Run PackerSync to install.", s:theme)
"   finish
" endif

" execute 'call ' . s:colorscheme_func
" if g:logging_level == 'debug'
"   let s:msg1 = "Currently loaded theme: " . s:theme
"   call v:lua.vim.notify(s:msg1, 'info', {'title': 'nvim-config'})
" endif
" set background=dark
" colorscheme one
syntax on
"" Vim
" let g:onedark_config = {
"     \ 'style': 'darker',
" \}
 " colorscheme onedark" Or whatever colorscheme you make
" colorscheme zephyr

