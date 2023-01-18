local utils = require("utils")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local function evalIf(cond, T, F)
  if cond then
    return T
  else
    return F
  end
end
vim.g.mapleader = ","
require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "neovim/nvim-lspconfig",
  "simrat39/rust-tools.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    event = "BufEnter",
  },
  {
    "mfussenegger/nvim-dap",
    event = "VimEnter",
    config = function() require("config.Dap") end,
  },
  {
    "rrethy/vim-hexokinase",
    build = "cd  ~/.local/share/nvim/lazy/vim-hexokinase && make hexokinase",
    event = "VimEnter",
  },
  {
    "andweeb/presence.nvim",
    config = function() require("config.discordPresence") end,
    event = "BufEnter",
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function() require("lsp_lines").setup() end,
  },
  "tamago324/nlsp-settings.nvim", -- language server settings defined in json for jsonls
  -- Refactoring plugins
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    event = "BufEnter",
    config = function() require("config.refactoring") end,
  },
  {
    "filipdutescu/renamer.nvim",
    branch = "master",
    event = "BufEnter",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function() require("config.renamer") end,
  },

  -- nvim-cmp dependencies
  "hrsh7th/cmp-nvim-lsp",
  "onsails/lspkind-nvim",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-cmdline",
  "quangnguyen30192/cmp-nvim-ultisnips",
  "github/copilot.vim",
  "zbirenbaum/copilot-cmp",
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      vim.schedule(function() require("copilot").setup() end)
    end,
    dependencies = { "zbirenbaum/copilot-cmp" },
  },
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = "hrsh7th/nvim-cmp",
    config = function() require("config.nvim-cmp-tabnine") end,
  },
  {
    "hrsh7th/nvim-cmp",
    branch = "main",
    config = function() require("config.nvim-cmp") end,
    event = "BufEnter",
    dependencies = {
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-cmdline",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "tzachar/cmp-tabnine",
      "zbirenbaum/copilot-cmp",
    },
  },
  {
    "lervag/vimtex",
    ft = "tex",
    event = "BufEnter",
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_fold_enable = 0
      vim.g.vimtex_indent_enable = 1
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_latexmk_continuous = 1
    end,
  },

  {
    "stsewd/spotify.nvim",
    event = "BufEnter",
    build = ":UpdateRemotePlugins",
    config = function() require("config.nvim-spotify") end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- event = 'BufEnter',
    build = ":TSUpdate",
    config = function() require("config.treesitter") end,
  },
  { "elkowar/yuck.vim", ft = "yuck" },
  { "fladson/vim-kitty", event = "BufEnter" },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    -- config = function() require('config.nvim-navic') end,
  },
  {
    "zbirenbaum/neodim",
    config = function() require("neodim").setup() end,
  },
  {
    "p00f/nvim-ts-rainbow",
    event = "BufEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "m-demare/hlargs.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function() require("config.hlargs") end,
    event = "BufEnter",
  },
  --'nvim-treesitter/playground'
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  -- Python indent (follows the PEP8 style)
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },

  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },
  "searleser97/cpbooster.vim",
  { "machakann/vim-swap", event = "VimEnter" },

  {
    "ray-x/lsp_signature.nvim",
    config = function() require("config.lsp_signature") end,
  },
  -- Super fast buffer jump
  {
    "phaazon/hop.nvim",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function() require("config.nvim_hop") end, 2000)
    end,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function() require("config.harpoon") end,
  },
  -- Clear highlight search automatically for you
  --"romainl/vim-cool", event = "VimEnter"

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
    config = function() require("config.hlslens") end,
  },

  -- Stay after pressing * and search selected text
  { "haya14busa/vim-asterisk", event = "VimEnter" },
  -- File search, tag search and more
  {
    evalIf(
      vim.g.is_win,
      { "Yggdroot/LeaderF", cmd = "Leaderf" },
      { "Yggdroot/LeaderF", cmd = "Leaderf", build = ":LeaderfInstallCExtension" }
    ),
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  -- search emoji and other symbols
  "nvim-telescope/telescope-symbols.nvim",

  "nvim-telescope/telescope-ui-select.nvim",
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
    config = function() require("config.telescope-nvim") end,
  },

  -- Another similar plugin is command-t
  -- 'wincent/command-t',

  -- A grepping tool
  -- 'mhinz/vim-grepper', cmd = {'Grepper', '<plug>(GrepperOperator)'},
  -- Themes
  -- A list of colorscheme plugin you may want to try. Find what suits you.
  { "folke/tokyonight.nvim", config = function() require("config.tokyonight") end },
  --{ "navarasu/onedark.nvim", config = function() require('config.onedark') end, },
  --{
  -- "olimorris/onedarkpro.nvim",
  -- config = function() require('config.onedarkpro') end,
  --},

  --[[{
      "rose-pine/neovim",
      as = "rose-pine",
      config = function()
        require("rose-pine").setup({ dark_variant = "main" })
        vim.cmd("colorscheme rose-pine")
      end,
    }, ]]
  --{ "sainnhe/edge", config = function() require('config.edge-theme') end, },
  -- Show git change (change, delete, add) signs in vim sign column
  { "mhinz/vim-signify", event = "BufEnter" },
  -- Git lens similar to vscode
  { "APZelos/blamer.nvim", event = "BufEnter" },
  -- Another similar plugin
  -- 'airblade/vim-gitgutter',
  --[[{
            'ldelossa/gh.nvim',
            event = 'InsertEnter',
            dependencies = 'ldelossa/litee.nvim',
            config = function()
                require('litee.lib').setup()
                require('litee.gh').setup()
            end
        }, ]]
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function() require("config.statusline") end,
  },

  -- fancy start screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function() require("config.alpha-nvim") end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VimEnter",
    config = function() require("config.indent-blankline") end,
  },

  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VimEnter" },

  -- notification plugin
  {
    "rcarriga/nvim-notify",
    event = "BufEnter",
    config = function()
      vim.defer_fn(function() require("config.nvim-notify") end, 2000)
    end,
  },
  { "tyru/open-browser.vim", event = "VimEnter" },
  {
    evalIf(utils.executable("ctags"), { "liuchengxu/vista.vim", cmd = "Vista" }, nil),
  },

  -- Snippet engine and snippet template
  "honza/vim-snippets",
  { "SirVer/ultisnips", event = "InsertEnter", dependencies = { "honza/vim-snippets" } },

  {
    "windwp/nvim-autopairs",
    event = "BufEnter",
    config = function() require("config.autopairs") end,
  },

  -- Comment plugin
  { "b3nj5m1n/kommentary", event = "VimEnter" },

  -- Autosave files on certain events
  {
    "Pocco81/auto-save.nvim",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function() require("config.autosave") end, 1500)
    end,
  },

  -- Show undo history visually
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

  -- Manage your yank history
  { evalIf(vim.g.is_win or vim.g.is_mac, { "svermeulen/vim-yoink", event = "VimEnter" }, nil) },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat", event = "VimEnter" },

  -- Show the content of register in preview window
  -- Plug 'junegunn/vim-peekaboo'
  { "jdhao/better-escape.vim", event = { "InsertEnter" } },
  {
    evalIf(
      vim.g.is_mac,
      {
        "lyokha/vim-xkbswitch",
        event = { "InsertEnter" },
      },
      evalIf(vim.g.is_win, {
        "Neur1n/neuims",
        event = { "InsertEnter" },
      }, nil)
    ),
  },

  -- Syntax check and make
  -- 'neomake/neomake',

  -- Auto format tools
  { "sbdchd/neoformat", cmd = { "Neoformat" } },

  -- Git command inside vim
  { "tpope/vim-fugitive", event = "User InGitRepo" },

  -- Better git log display
  { "rbong/vim-flog", dependencies = "tpope/vim-fugitive", cmd = { "Flog" } },

  {
    "christoomey/vim-conflicted",
    dependencies = "tpope/vim-fugitive",
    cmd = { "Conflicted" },
  },

  {
    "kevinhwang91/nvim-bqf",
    event = "FileType qf",
    config = function() require("config.bqf") end,
  },

  {
    "rhysd/committia.vim",
  },

  -- Another markdown plugin
  { "plasticboy/vim-markdown", ft = { "markdown" } },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular", cmd = { "Tabularize" } },

  -- Markdown JSON header highlight plugin
  { "elzr/vim-json", ft = { "json", "markdown" } },

  --{
  -- 'folke/zen-mode.nvim',
  -- cmd = 'ZenMode',
  -- config = function() require('config.zen-mode') end,
  -- },

  { "chrisbra/unicode.vim", event = "VimEnter" },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim", event = "VimEnter" },

  -- Plugin to manipulate character pairs quickly
  -- 'tpope/vim-surround',
  { "machakann/vim-sandwich", event = "VimEnter" },

  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VimEnter" },

  -- Only use these plugin on Windows and Mac and when LaTeX is installed
  { evalIf(vim.g.is_win or vim.g.is_mac and utils.executable("latex"), { "lerag/vimtex", ft = "tex" }, nil) },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  { evalIf(not vim.g.is_win and utils.executable("tmux"), { "tmux-plugins/vim-tmux", ft = { "tmux" } }, nil) },

  -- Modern matchit implementation
  { "andymass/vim-matchup", event = "VimEnter" },

  -- Smoothie motions
  -- 'psliwka/vim-smoothie',
  {
    "karb94/neoscroll.nvim",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function() require("config.neoscroll") end, 2000)
    end,
  },

  {
    "tpope/vim-scriptease",
    cmd = { "Scriptnames", "Message", "Verbose" },
  },

  -- Asynchronous command execution
  --  { "skywind3000/asyncbuild.vim", opt = true, cmd = { "Asyncbuild" } },
  -- Another asynchronous plugin
  -- Plug 'tpope/vim-dispatch'

  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Edit text area in browser using nvim
  --{
  -- "glacambre/firenvim",
  -- build = function() fn["firenvim#install"](0) end,
  -- opt = true,
  -- setup = function vim.cmd('packadd firenvim') end,
  -- },
  -- Session management plugin
  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("config.session-manager") end,
  },
  { evalIf(vim.g.is_linux, { "ojroques/vim-oscyank", cmd = { "OSCYank", "OSCYankReg" } }, nil) },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function() require("config.which-key") end, 2000)
    end,
  },
  {
    "jbyuki/instant.nvim",
    event = "BufEnter",
    config = function() require("config.instant-nvim") end,
  },

  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VimEnter" },
  "kyazdani42/nvim-web-devicons",
  "ryanoasis/vim-devicons",

  --{
  -- "akinsho/bufferline.nvim",
  -- event = "VimEnter",
  -- dependencies = "kyazdani42/nvim-web-devicons",
  -- config = function() require('config.bufferline') end,
  -- },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function() require("config.neo-tree") end,
  },
})
