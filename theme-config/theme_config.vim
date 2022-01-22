"color schemes
if (has("termguicolors"))
   set termguicolors
endif
syntax enable
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
endif
" 4 PM
if strftime("%H") < 11
  set background=light
  colorscheme one 
else
 colorscheme one
 set background=dark
endif
let g:one_allow_italics = 1 
