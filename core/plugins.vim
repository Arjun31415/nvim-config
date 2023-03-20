scriptencoding utf-8

" Plugin specification and lua stuff
lua require('lua-init')

" Use short names for common plugin manager commands to simplify typing.
" To use these shortcuts: first activate command line with `:`, then input the
" short alias, e.g., `pi`, then press <space>, the alias will be expanded to
" the full command automatically.
call utils#Cabbrev('li', 'Lazy install')
call utils#Cabbrev('lud', 'Lazy Update')
call utils#Cabbrev('lc', 'Lazy clean')
call utils#Cabbrev('ls', 'Lazy sync')
set guifont=VictorMono_Nerd_Font:h14
"""""""""""""""""""""""""UltiSnips settings"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use YouCompleteMe
" let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsExpandTrigger="<tab>"

" Do not look for SnipMate snippets
let g:UltiSnipsEnableSnipMate = 0

" Shortcut to jump forward and backward in tabstop positions
let g:UltiSnipsJumpForwardTrigger='<tab>'
" FIXME: Shift + tab might not work check out
"  https://stackoverflow.com/questions/2745428/how-to-capture-shift-tab-in-vim
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

" Configuration for custom snippets directory, see
" https://jdhao.github.io/2019/04/17/neovim_snippet_s1/ for details.
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'my_snippets']

""""""""""""""""""""""""vim-mundo settings"""""""""""""""""""""""
let g:mundo_verbose_graph = 0
let g:mundo_width = 80

nnoremap <silent> <Space>u :MundoToggle<CR>

""""""""""""""""""""""""""""vim-yoink settings"""""""""""""""""""""""""
if g:is_win || g:is_mac
  " ctrl-n and ctrl-p will not work if you add the TextChanged event to vim-auto-save events.
  " nmap <c-n> <plug>(YoinkPostPasteSwapBack)
  " nmap <c-p> <plug>(YoinkPostPasteSwapForward)

  " The following p/P mappings are also needed for ctrl-n and ctrl-p to work
  " nmap p <plug>(YoinkPaste_p)
  " nmap P <plug>(YoinkPaste_P)

  " Cycle the yank stack with the following mappings
  nmap [y <plug>(YoinkRotateBack)
  nmap ]y <plug>(YoinkRotateForward)

  " Do not change the cursor position
  nmap y <plug>(YoinkYankPreserveCursorPosition)
  xmap y <plug>(YoinkYankPreserveCursorPosition)

  " Move cursor to end of paste after multiline paste
  let g:yoinkMoveCursorToEndOfPaste = 0

  " Record yanks in system clipboard
  let g:yoinkSyncSystemClipboardOnFocus = 1
endif

""""""""""""""""""""""""""""better-escape.vim settings"""""""""""""""""""""""""
let g:better_escape_interval = 200

""""""""""""""""""""""""""""vim-xkbswitch settings"""""""""""""""""""""""""
let g:XkbSwitchEnabled = 1

"""""""""""""""""""""""""""""" neoformat settings """""""""""""""""""""""

let g:neoformat_enabled_python = ['black', 'yapf']
let g:neoformat_cpp_clangformat = {
      \ 'exe': 'clang-format',
      \ 'args': ['--style="{IndentWidth: 4,AlwaysBreakTemplateDeclarations: Yes, BreakBeforeBraces: Allman, NamespaceIndentation: All, UseTab: Always,TabWidth: 4, AllowShortIfStatementsOnASingleLine: AllIfsAndElse } "']
      \ }
let g:neoformat_c_clangformat = {
      \ 'exe': 'clang-format',
        \ 'args': ['--style="{IndentWidth: 4, BreakBeforeBraces: Allman,AllowShortIfStatementsOnASingleLine: AllIfsAndElse,UseTab: Always,TabWidth: 4} "']
      \ }

let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']
"""""""""""""""""""""""""vim-signify settings""""""""""""""""""""""""""""""
" The VCS to use
let g:signify_vcs_list = [ 'git' ]

" Change the sign for certain operations
let g:signify_sign_change = '~'

"""""""""""""""""""""""""vim-fugitive settings""""""""""""""""""""""""""""""
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gpl :Git pull<CR>
" Note that to use bar literally, we need backslash it, see also `:h :bar`.
nnoremap <silent> <leader>gpu :15split \| term git push<CR>

"""""""""""""""""""""""""plasticboy/vim-markdown settings"""""""""""""""""""
" Disable header folding
let g:vim_markdown_folding_disabled = 1

" Whether to use conceal feature in markdown
let g:vim_markdown_conceal = 1

" Disable math tex conceal and syntax highlight
let g:tex_conceal = ''
let g:vim_markdown_math = 0

" Support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

" Let the TOC window autofit so that it doesn't take too much space
let g:vim_markdown_toc_autofit = 1

"""""""""""""""""""""""""markdown-preview settings"""""""""""""""""""
" Only setting this for suitable platforms
" if g:is_win || g:is_mac
  " Do not close the preview tab when switching to other buffers
  let g:mkdp_auto_close = 0

  " Shortcuts to start and stop markdown previewing
  nnoremap <silent> <M-m> :<C-U>MarkdownPreview<CR>
  nnoremap <silent> <M-S-m> :<C-U>MarkdownPreviewStop<CR>
" endif
""""""""""""""""""""""""vim-grammarous settings""""""""""""""""""""""""""""""
if g:is_mac
  let g:grammarous#languagetool_cmd = 'languagetool'
  let g:grammarous#disabled_rules = {
      \ '*' : ['WHITESPACE_RULE', 'EN_QUOTES', 'ARROWS', 'SENTENCE_WHITESPACE',
      \        'WORD_CONTAINS_UNDERSCORE', 'COMMA_PARENTHESIS_WHITESPACE',
      \        'EN_UNPAIRED_BRACKETS', 'UPPERCASE_SENTENCE_START',
      \        'ENGLISH_WORD_REPEAT_BEGINNING_RULE', 'DASH_RULE', 'PLUS_MINUS',
      \        'PUNCTUATION_PARAGRAPH_END', 'MULTIPLICATION_SIGN', 'PRP_CHECKOUT',
      \        'CAN_CHECKOUT', 'SOME_OF_THE', 'DOUBLE_PUNCTUATION', 'HELL',
      \        'CURRENCY', 'POSSESSIVE_APOSTROPHE', 'ENGLISH_WORD_REPEAT_RULE',
      \        'NON_STANDARD_WORD', 'AU', 'DATE_NEW_YEAR'],
      \ }

  augroup grammarous_map
    autocmd!
    autocmd FileType markdown nmap <buffer> <leader>x <Plug>(grammarous-close-info-window)
    autocmd FileType markdown nmap <buffer> <c-n> <Plug>(grammarous-move-to-next-error)
    autocmd FileType markdown nmap <buffer> <c-p> <Plug>(grammarous-move-to-previous-error)
  augroup END
endif

""""""""""""""""""""""""unicode.vim settings""""""""""""""""""""""""""""""
nmap ga <Plug>(UnicodeGA)

""""""""""""""""""""""""""""vim-sandwich settings"""""""""""""""""""""""""""""
" Map s to nop since s in used by vim-sandwich. Use cl instead of s.
nmap s <Nop>
omap s <Nop>

""""""""""""""""""""""""""""vimtex settings"""""""""""""""""""""""""""""
if ( g:is_win || g:is_mac ) && executable('latex')
  " Hacks for inverse serach to work semi-automatically,
  " see https://jdhao.github.io/2021/02/20/inverse_search_setup_neovim_vimtex/.
  function! s:write_server_name() abort
    let nvim_server_file = (has('win32') ? $TEMP : '/tmp') . '/vimtexserver.txt'
    call writefile([v:servername], nvim_server_file)
  endfunction

  augroup vimtex_common
    autocmd!
    autocmd FileType tex call s:write_server_name()
    autocmd FileType tex nmap <buffer> <F9> <plug>(vimtex-compile)
  augroup END

  let g:vimtex_compiler_latexmk = {
        \ 'build_dir' : 'build',
        \ }

  " TOC settings
  let g:vimtex_toc_config = {
        \ 'name' : 'TOC',
        \ 'layers' : ['content', 'todo', 'include'],
        \ 'resize' : 1,
        \ 'split_width' : 30,
        \ 'todo_sorted' : 0,
        \ 'show_help' : 1,
        \ 'show_numbers' : 1,
        \ 'mode' : 2,
        \ }

  " Viewer settings for different platforms
  if g:is_win
    let g:vimtex_view_general_viewer = 'SumatraPDF'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
    let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
  endif

  if g:is_mac
    " let g:vimtex_view_method = "skim"
    let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options = '-r @line @pdf @tex'

    augroup vimtex_mac
      autocmd!
      autocmd User VimtexEventCompileSuccess call UpdateSkim()
    augroup END

    " The following code is adapted from https://gist.github.com/skulumani/7ea00478c63193a832a6d3f2e661a536.
    function! UpdateSkim() abort
      let l:out = b:vimtex.out()
      let l:src_file_path = expand('%:p')
      let l:cmd = [g:vimtex_view_general_viewer, '-r']

      if !empty(system('pgrep Skim'))
        call extend(l:cmd, ['-g'])
      endif

      call jobstart(l:cmd + [line('.'), l:out, l:src_file_path])
    endfunction
  endif
endif

""""""""""""""""""""""""""""vim-startify settings""""""""""""""""""""""""""""
" Do not change working directory when opening files.
let g:startify_change_to_dir = 0
let g:startify_fortune_use_unicode = 1
""""""""""""""""""""""""""""vim-matchup settings"""""""""""""""""""""""""""""
" Improve performance
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_timeout = 100
let g:matchup_matchparen_insert_timeout = 30

" Enhanced matching with matchup plugin
let g:matchup_override_vimtex = 1

" Whether to enable matching inside comment or string
let g:matchup_delim_noskips = 0

" Show offscreen match pair in popup window
let g:matchup_matchparen_offscreen = {'method': 'popup'}


let g:Hexokinase_highlighters = ['backgroundfull']
