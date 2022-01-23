highlight clear
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ignorecase              " case insensitive
set mouse=v                 " middle-click paste with
set hlsearch                " highlight search
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set spell                   " enable spell check (may need to download language package)
set spelllang=en
set spellsuggest=best,5

" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
set backspace=indent,eol,start
let g:python3_host_prog = '/usr/bin/python'

call plug#begin()
  " coc for tslintin g, auto complete and prettier and tabnine bery much (bloaty) impurtunt
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

  " themes
  Plug 'dracula/vim'
  Plug 'rakr/vim-one'
  Plug 'ryanoasis/vim-devicons'

  " snippets, for user snippets see coc-snippets
  Plug 'SirVer/ultisnips'

  " CP helper
  Plug 'nvim-lua/plenary.nvim'
  Plug 'p00f/cphelper.nvim'

  " Nerd Tree stuff
  Plug 'scrooloose/nerdtree'
  Plug 'preservim/nerdcommenter'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  " beautiful start page
  Plug 'mhinz/vim-startify'
  Plug 'junegunn/fzf'
  " linter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " Auto formatters
  Plug 'sbdchd/neoformat'
  " git stuff
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'junegunn/gv.vim'
  " Latex preview, latex syntax and compilation
  Plug 'lervag/vimtex'
  " ES2015 code snippets (Optional)
  Plug 'epilande/vim-es2015-snippets'
  " React code snippets
  Plug 'epilande/vim-react-snippets'
  " Discord presence
  Plug 'andweeb/presence.nvim'
  " bracket coloriser
  Plug 'junegunn/rainbow_parentheses.vim'
  " line indent colorizer
  Plug 'Yggdroot/indentLine'
  " Plug 'Arjun31415/aura-theme', {'do':'./installVimTheme.sh'}
  " for auto tag complete
  Plug 'alvan/vim-closetag'
  Plug 'chrisbra/sudoedit.vim'


call plug#end()

source $HOME/.config/nvim/treesitter-syntax-highlighting/config.vim   " treesitter syntax highlighting
source $HOME/.config/nvim/comments/config.vim                         " NERDCommenter config
source $HOME/.config/nvim/latex-config/latex_config.vim               " Latex config
source $HOME/.config/nvim/custom_keybinds.vim                         " Custom keybinds
source $HOME/.config/nvim/theme-config/theme_config.vim               " Theme stuff
source $HOME/.config/nvim/plug-config/signify.vim                     " Git stuff
" source $HOME/.config/nvim/SyntaxAttr.vim
 " coc extensions
let g:coc_global_extensions = [
  \ 'coc-tslint-plugin',
  \ 'coc-tsserver',
  \ 'coc-emmet',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-yank',
  \ 'coc-prettier',
  \ 'coc-tabnine',
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-eslint',
  \ ]
  " if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.


if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
set signcolumn=number

" For prettier
let g:neoformat_try_node_exe = 1
autocmd BufWritePre *.js Neoformat
autocmd BufWritePre,TextChanged,InsertLeave *.js Neoformat
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
let g:neoformat_cpp_clangformat = {
    \ 'exe': 'clang-format',
    \ 'args': ['--style="{IndentWidth: 4, BreakBeforeBraces: Allman} "']
\ }
let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']


" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
"let g:neoformat_run_all_formatters = 1
"let &verbose            = 1 " also increases verbosity of the editor as a whole


augroup fmt
  autocmd!
  autocmd BufWritePre *.cpp undojoin | Neoformat
augroup END


let g:UltiSnipsExpandTrigger="<tab>"
imap <C-l> <Plug>(coc-snippets-expand)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" open new split panes to right and below
set splitright
set splitbelow

let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeIgnore = ['^node_modules$']

autocmd VimEnter * NERDTree | wincmd p
" Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Linting
au BufWritePost <buffer> lua require('lint').try_lint()


function! MyOnBattery()
  if has('macunix')
    return match(system('pmset -g batt'), "Now drawing from 'Battery Power'") != -1
  elseif has('unix')
    return readfile('/sys/class/power_supply/ACAD/online') == ['0']
  endif
  return 0
endfunction

" if MyOnBattery()
"   call neomake#configure#automake('w')
" else
"   call neomake#configure#automake('nw', 1000)
" endif
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
autocmd FileType * RainbowParentheses


" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()
" Stuff for themeing
" adds to statusline
" set laststatus=2
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}

" " a little more informative version of the above
" nmap <Leader>sI :call SyntaxAttr()<CR>

" map <F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>


" source /run/media/arjun/Shared/CODING/WebDev/Theme/AuraTheme/Vim/aura-dark-soft-text-color-theme.vim
" inoremap <buffer> > ></<C-x><C-o><C-y><C-o>%<CR><C-o>O
