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
  { "folke/tokyonight.nvim", priority = 1000, lazy = false, opts = require("config.tokyonight") },

  "neovim/nvim-lspconfig",
  "simrat39/rust-tools.nvim",
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPre",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    config = function() require("config.nvim-ufo") end,
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    event = "BufEnter",
  },
  {
    "andweeb/presence.nvim",
    config = function() require("config.discordPresence") end,
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
  "saadparwaiz1/cmp_luasnip",
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
    "nvim-treesitter/nvim-treesitter",
    -- event = 'BufEnter',
    build = ":TSUpdate",
    config = function() require("config.treesitter") end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
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
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function() require("todo-comments").setup({}) end,
  },
  -- Python indent (follows the PEP8 style)
  -- { "Vimjas/vim-python-pep8-indent", ft = { "python" } },

  -- Python-related text object
  --[[ { "jeetsukumaran/vim-pythonsense", ft = { "python" } },
  "searleser97/cpbooster.vim",
  { "machakann/vim-swap", event = "VimEnter" }, ]]

  --[[ {
    "ray-x/lsp_signature.nvim",
    config = function() require("config.lsp_signature") end,
  }, ]]
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
  --[[ {
    evalIf(
      vim.g.is_win,
      { "Yggdroot/LeaderF", cmd = "Leaderf" },
      { "Yggdroot/LeaderF", cmd = "Leaderf", build = ":LeaderfInstallCExtension" }
    ),
  }, ]]

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
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "git",
          "markdown",
          "snippets",
          "text",
          "gitconfig",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
        },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
    config = function(_, opts) require("mini.indentscope").setup(opts) end,
  },

  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VimEnter" },
  {
    "rcarriga/nvim-notify",
    event = "BufEnter",
    init = function() vim.notify = require("notify") end,
  },
  -- WakaTime and wakapi metrics
  {
    "wakatime/vim-wakatime",
  },
  -- better ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    init = function() require("config.noice-nvim") end,
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },
  -- notification plugin
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    evalIf(utils.executable("ctags"), { "liuchengxu/vista.vim", cmd = "Vista" }, nil),
  },

  -- Snippet engine and snippet template
  "honza/vim-snippets",
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function() require("config.luasnip") end,
  },
  {
    "windwp/nvim-autopairs",
    event = "BufEnter",
    config = function() require("config.autopairs") end,
  },

  --[[ {
    "smjonas/snippet-converter.nvim",
    -- SnippetConverter uses semantic versioning. Example: use version = "1.*" to avoid breaking changes on version 1.
    -- Uncomment the next line to follow stable releases only.
    -- tag = "*",
    config = function()
      local template = {
        -- name = "t1", (optionally give your template a name to refer to it in the `ConvertSnippets` command)
        sources = {
          ultisnips = {
            vim.fn.stdpath("config") .. "/my_snippets",
          },
        },
        output = {
          -- Specify the output formats and paths
          snipmate_luasnip = {
            vim.fn.stdpath("config") .. "/luasnip_snippets",
          },
        },
      }

      require("snippet_converter").setup({
        templates = { template },
        -- To change the default settings (see configuration section in the documentation)
        -- settings = {},
      })
    end,
  }, ]]
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
    },
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

  -- Additional powerful text object for vim
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function() require("config.mini-ai").setup() end,
    config = function(_, opts) require("config.mini-ai").config(opts) end,
  },
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

  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Session management plugin
  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("config.session-manager") end,
  },
  { evalIf(vim.g.is_linux, { "ojroques/vim-oscyank", cmd = { "OSCYank", "OSCYankReg" } }, nil) },

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
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function() require("competitest").setup() end,
  },
  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VimEnter" },
  "kyazdani42/nvim-web-devicons",
  "ryanoasis/vim-devicons",

  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    dependencies = { "kyazdani42/nvim-web-devicons", "famiu/bufdelete.nvim" },
    config = function() require("config.bufferline") end,
  },

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
vim.o.termguicolors = true
vim.cmd([[ colorscheme tokyonight]])
