local utils = require("utils")
local fn = vim.fn

vim.g.package_home = fn.stdpath("data") .. "/site/pack/packer/"
local packer_install_dir = vim.g.package_home .. "opt/packer.nvim"

local plug_url_format = ""
-- if vim.g.is_linux then
--   plug_url_format = "https://hub.fastgit.org/%s"
-- else
--   plug_url_format = "https://github.com/%s"
-- end
plug_url_format = "https://github.com/%s"

local packer_repo = string.format(plug_url_format, 'wbthomason/packer.nvim')
local install_cmd = string.format("10split |term git clone --depth=1 %s %s",
                                  packer_repo, packer_install_dir)

-- Auto-install packer in case it hasn't been installed.
if fn.glob(packer_install_dir) == "" then
    vim.api.nvim_echo({{"Installing packer.nvim", "Type"}}, true, {})
    vim.cmd(install_cmd)
end

local packer_util = require('packer.util')

require("packer").startup({
    function(use)
        -- it is recommened to put impatient.nvim before any other plugins
        use({'lewis6991/impatient.nvim', config = [[require('impatient')]]})
        use 'wbthomason/packer.nvim'
        use {'nvim-lua/plenary.nvim'}
        use {'neovim/nvim-lspconfig'}
        use {'williamboman/nvim-lsp-installer'}

        use({
            'andweeb/presence.nvim',
            config = [[require('config.discordPresence')]]
        })
        -- Highlight colors inline
        use({
            'norcalli/nvim-colorizer.lua',
            event = "BufEnter",
            config = [[require('config.nvim-colorizer')]]
        })
        use({"tamago324/nlsp-settings.nvim"}) -- language server settings defined in json for jsonls

        use({
            "onsails/lspkind-nvim",
            -- event = "VimEnter",
            config = [[require('config.lspkind')]]
        })
        use {'hrsh7th/cmp-nvim-lsp', event ="VimEnter"}
        use {'hrsh7th/cmp-buffer',event="VimEnter"}
        use {'hrsh7th/cmp-path', event="VimEnter"}
        use {'hrsh7th/cmp-cmdline', event="VimEnter"}
        use {
            'hrsh7th/nvim-cmp',
            branch = "main",
            config = [[require('config.nvim-cmp')]],
            event = "VimEnter"
        }
        use {'quangnguyen30192/cmp-nvim-ultisnips', event="VimEnter"}
        use {"github/copilot.vim"}
        use {
            "zbirenbaum/copilot.lua",
            event = "InsertEnter",
            config = function()
                vim.schedule(function() require("copilot") end)
            end
        }
        use {"zbirenbaum/copilot-cmp", after = {"copilot.lua", "nvim-cmp"}}
        use {
            'tzachar/cmp-tabnine',
            run = './install.sh',
            requires = 'hrsh7th/nvim-cmp',
            config = [[require('config.nvim-cmp-tabnine')]],
            event = "VimEnter"
        }

        use({
            'stsewd/spotify.nvim',
            run = ":UpdateRemotePlugins",
            config = [[require('config.nvim-spotify')]]
        })
        use({
            "nvim-treesitter/nvim-treesitter",
            -- event = 'BufEnter',
            run = ":TSUpdate",
            config = [[require('config.treesitter')]]
        })
        use {
            'p00f/nvim-ts-rainbow',
            event = 'BufEnter',
            requires = "nvim-treesitter/nvim-treesitter"
        }
        use({
            'm-demare/hlargs.nvim',
            requires = {'nvim-treesitter/nvim-treesitter'},
            config = [[require('config.hlargs')]],
            event = 'BufEnter'
        })
        -- use({'nvim-treesitter/playground'})
        --         todo highlighter
        use({
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("todo-comments").setup {
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                }
            end
        })
        -- Python indent (follows the PEP8 style)
        use({"Vimjas/vim-python-pep8-indent", ft = {"python"}})

        -- Python-related text object
        use({"jeetsukumaran/vim-pythonsense", ft = {"python"}})
        use {'searleser97/cpbooster.vim'}
        use({"machakann/vim-swap", event = "VimEnter"})

        use {
            'ray-x/lsp_signature.nvim',
            config = [[require('config.lsp_signature')]]
        }
        -- use {'github/copilot.vim'}
        -- Super fast buffer jump
        use {
            'phaazon/hop.nvim',
            event = "VimEnter",
            config = function()
                vim.defer_fn(function()
                    require('config.nvim_hop')
                end, 2000)
            end
        }

        -- Clear highlight search automatically for you
        -- use({"romainl/vim-cool", event = "VimEnter"})

        -- Show match number and index for searching
        use {
            'kevinhwang91/nvim-hlslens',
            branch = 'main',
            keys = {{'n', '*'}, {'n', '#'}, {'n', 'n'}, {'n', 'N'}},
            config = [[require('config.hlslens')]]
        }

        -- Stay after pressing * and search selected text
        use({"haya14busa/vim-asterisk", event = 'VimEnter'})

        -- File search, tag search and more
        if vim.g.is_win then
            use({"Yggdroot/LeaderF", cmd = "Leaderf"})
        else
            use({
                "Yggdroot/LeaderF",
                cmd = "Leaderf",
                run = ":LeaderfInstallCExtension"
            })
        end

        use {
            'nvim-telescope/telescope.nvim',
            -- cmd = 'Telescope',
            requires = {{'nvim-lua/plenary.nvim'}}
            --            config = [[require('config.telescope-nvim')]]
        }
        use {
            'nvim-telescope/telescope-ui-select.nvim',
            after = 'telescope.nvim',
            config = [[require('config.telescope-nvim')]]
        }
        -- search emoji and other symbols
        use {'nvim-telescope/telescope-symbols.nvim', after = 'telescope.nvim'}

        -- Another similar plugin is command-t
        -- use 'wincent/command-t'

        -- Another grep tool (similar to Sublime Text Ctrl+Shift+F)
        -- use 'dyng/ctrlsf.vim'

        -- A grepping tool
        -- use {'mhinz/vim-grepper', cmd = {'Grepper', '<plug>(GrepperOperator)'}}
        -- Themes
        -- A list of colorscheme plugin you may want to try. Find what suits you.
        -- use({"rakr/vim-one", opt = true})
        -- use({'folke/tokyonight.nvim'})
        -- use({"sainnhe/sonokai", opt = true})
        use({'navarasu/onedark.nvim', config = [[require('config.onedark')]]})
        -- use {'Arjun31415/zephyr-nvim'}
        -- use {'catppuccin/nvim', as = "catppuccin"}

        -- Show git change (change, delete, add) signs in vim sign column
        use({"mhinz/vim-signify", event = 'BufEnter'})
        -- Git lens similar to vscode
        use({"APZelos/blamer.nvim", event = 'BufEnter'})
        -- Another similar plugin
        -- use 'airblade/vim-gitgutter'

        use {
            'nvim-lualine/lualine.nvim',
            event = 'VimEnter',
            config = [[require('config.statusline')]]
        }

        -- fancy start screen
        use {
            'goolord/alpha-nvim',
            event = 'VimEnter',
            config = [[require('config.alpha-nvim')]]
        }

        use({
            "lukas-reineke/indent-blankline.nvim",
            event = 'VimEnter',
            config = [[require('config.indent-blankline')]]
        })

        -- Highlight URLs inside vim
        use({"itchyny/vim-highlighturl", event = "VimEnter"})

        -- notification plugin
        use({
            "rcarriga/nvim-notify",
            event = "BufEnter",
            config = function()
                vim.defer_fn(function()
                    require('config.nvim-notify')
                end, 2000)
            end
        })
        -- use({
        --     'Arjun31415/BuildTask.nvim',
        --     config = [[require('config.build_task')]],
        --     requires = "rcarriga/nvim-notify",
        --     event = "BufEnter"
        -- })

        use({"tyru/open-browser.vim", event = "VimEnter"})

        -- Only install these plugins if ctags are installed on the system
        if utils.executable("ctags") then
            -- show file tags in vim window
            use({"liuchengxu/vista.vim", cmd = "Vista"})
        end

        -- Snippet engine and snippet template
        use({"SirVer/ultisnips", event = 'InsertEnter'})
        use({"honza/vim-snippets", after = 'ultisnips'})

        -- Automatic insertion and deletion of a pair of characters
        use({"Raimondi/delimitMate", event = "InsertEnter"})

        -- Comment plugin
        use({"tpope/vim-commentary", event = "VimEnter"})

        -- Multiple cursor plugin like Sublime Text?
        -- use 'mg979/vim-visual-multi'

        -- Autosave files on certain events
        use({
            "Pocco81/AutoSave.nvim",
            event = "VimEnter",
            config = function()
                vim.defer_fn(function()
                    require('config.autosave')
                end, 1500)
            end
        })

        -- Show undo history visually
        use({"simnalamburt/vim-mundo", cmd = {"MundoToggle", "MundoShow"}})

        -- Manage your yank history
        if vim.g.is_win or vim.g.is_mac then
            use({"svermeulen/vim-yoink", event = "VimEnter"})
        end

        -- Handy unix command inside Vim (Rename, Move etc.)
        use({"tpope/vim-eunuch", cmd = {"Rename", "Delete"}})

        -- Repeat vim motions
        use({"tpope/vim-repeat", event = "VimEnter"})

        -- Show the content of register in preview window
        -- Plug 'junegunn/vim-peekaboo'
        use({"jdhao/better-escape.vim", event = {"InsertEnter"}})

        if vim.g.is_mac then
            use({"lyokha/vim-xkbswitch", event = {"InsertEnter"}})
        elseif vim.g.is_win then
            use({"Neur1n/neuims", event = {"InsertEnter"}})
        end

        -- Syntax check and make
        -- use 'neomake/neomake'

        -- Auto format tools
        use({"sbdchd/neoformat", cmd = {"Neoformat"}})

        -- Git command inside vim
        use({"tpope/vim-fugitive", event = "User InGitRepo"})

        -- Better git log display
        use({"rbong/vim-flog", requires = "tpope/vim-fugitive", cmd = {"Flog"}})

        use({
            "christoomey/vim-conflicted",
            requires = "tpope/vim-fugitive",
            cmd = {"Conflicted"}
        })

        use({
            "kevinhwang91/nvim-bqf",
            event = "FileType qf",
            config = [[require('config.bqf')]]
        })

        use({
            "rhysd/committia.vim",
            opt = true,
            setup = [[vim.cmd('packadd committia.vim')]]
        })

        -- Another markdown plugin
        use({"plasticboy/vim-markdown", ft = {"markdown"}})
        use({'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'})
        -- Faster footnote generation
        use({"vim-pandoc/vim-markdownfootnotes", ft = {"markdown"}})

        -- Vim tabular plugin for manipulate tabular, required by markdown plugins
        use({"godlygeek/tabular", cmd = {"Tabularize"}})

        -- Markdown JSON header highlight plugin
        use({"elzr/vim-json", ft = {"json", "markdown"}})

        -- Markdown previewing (only for Mac and Windows)
        if vim.g.is_win or vim.g.is_mac then
            use({
                "iamcco/markdown-preview.nvim",
                run = function() fn["mkdp#util#install"]() end,
                ft = {"markdown"}
            })
        end

        use({
            'folke/zen-mode.nvim',
            cmd = 'ZenMode',
            config = [[require('config.zen-mode')]]
        })

        if vim.g.is_mac then
            use({"rhysd/vim-grammarous", ft = {"markdown"}})
        end

        use({"chrisbra/unicode.vim", event = "VimEnter"})

        -- Additional powerful text object for vim, this plugin should be studied
        -- carefully to use its full power
        use({"wellle/targets.vim", event = "VimEnter"})

        -- Plugin to manipulate character pairs quickly
        -- use 'tpope/vim-surround'
        use({"machakann/vim-sandwich", event = "VimEnter"})

        -- Add indent object for vim (useful for languages like Python)
        use({"michaeljsmith/vim-indent-object", event = "VimEnter"})

        -- Only use these plugin on Windows and Mac and when LaTeX is installed
        if vim.g.is_win or vim.g.is_mac and utils.executable("latex") then
            use({"lervag/vimtex", ft = {"tex"}})

        end

        -- Since tmux is only available on Linux and Mac, we only enable these plugins
        -- for Linux and Mac
        if utils.executable("tmux") then
            -- .tmux.conf syntax highlighting and setting check
            use({"tmux-plugins/vim-tmux", ft = {"tmux"}})
        end

        -- Modern matchit implementation
        use({"andymass/vim-matchup", event = "VimEnter"})

        -- Smoothie motions
        -- use 'psliwka/vim-smoothie'
        use({
            "karb94/neoscroll.nvim",
            event = "VimEnter",
            config = function()
                vim.defer_fn(function()
                    require('config.neoscroll')
                end, 2000)
            end
        })

        use({
            "tpope/vim-scriptease",
            cmd = {"Scriptnames", "Message", "Verbose"}
        })

        -- Asynchronous command execution
        use({"skywind3000/asyncrun.vim", opt = true, cmd = {"AsyncRun"}})
        -- Another asynchronous plugin
        -- Plug 'tpope/vim-dispatch'

        use({"cespare/vim-toml", ft = {"toml"}, branch = "main"})

        -- Edit text area in browser using nvim
        use({
            "glacambre/firenvim",
            run = function() fn["firenvim#install"](0) end,
            opt = true,
            setup = [[vim.cmd('packadd firenvim')]]
        })

        -- Debugger plugin
        if vim.g.is_win or vim.g.is_linux then
            use({
                "sakhnik/nvim-gdb",
                run = {"bash install.sh"}
                -- opt = true,
                -- setup = [[vim.cmd('packadd nvim-gdb')]]
            })
        end

        -- Session management plugin
        use({"tpope/vim-obsession", cmd = 'Obsession'})

        if vim.g.is_linux then
            use({"ojroques/vim-oscyank", cmd = {'OSCYank', 'OSCYankReg'}})
        end

        -- The missing auto-completion for cmdline!
        use({
            "gelguy/wilder.nvim"
            -- opt = true,
            -- setup = [[vim.cmd('packadd wilder.nvim')]],
            --            config = [[require('config.wilder')]]
        })

        -- showing keybindings
        use {
            "folke/which-key.nvim",
            event = "VimEnter",
            config = function()
                vim.defer_fn(function()
                    require('config.which-key')
                end, 2000)
            end
        }
        use({
            "jbyuki/instant.nvim",
            event = "BufEnter",
            config = [[require('config.instant-nvim')]]
        })

        -- show and trim trailing whitespaces
        use {'jdhao/whitespace.nvim', event = 'VimEnter'}
        use {'kyazdani42/nvim-web-devicons', event = 'VimEnter'}
        use({"ryanoasis/vim-devicons"})
        use({
            "akinsho/bufferline.nvim",
            event = "VimEnter",
            requires = 'kyazdani42/nvim-web-devicons',
            config = [[require('config.bufferline')]]
        })

        use {
            'nvim-neo-tree/neo-tree.nvim',
            branch = "v2.x",
            requires = {
                "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons",
                "MunifTanjim/nui.nvim"
            },
            config = [[require('config.neo-tree')]]
        }

    end,
    config = {
        max_jobs = 16,
        compile_path = packer_util.join_paths(vim.fn.stdpath('config'), 'lua',
                                              'packer_compiled.lua'),
        git = {default_url_format = plug_url_format}
    }
    -- Always load the vim-devicons as the very last one.

})

local status, _ = pcall(require, 'packer_compiled')
if not status then
    vim.notify("Error requiring packer_compiled.lua: run PackerSync to fix!")
end
