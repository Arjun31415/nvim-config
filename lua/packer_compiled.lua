-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/arjun/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/arjun/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/arjun/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/arjun/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/arjun/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["AutoSave.nvim"] = {
    config = { "\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20config.autosave\frequire-\1\0\3\0\3\0\0064\0\0\0007\0\1\0001\1\2\0'\2Ü\5>\0\3\1G\0\1\0\0\rdefer_fn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/AutoSave.nvim",
    url = "https://github.com/Pocco81/AutoSave.nvim"
  },
  LeaderF = {
    commands = { "Leaderf" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/LeaderF",
    url = "https://github.com/Yggdroot/LeaderF"
  },
  ["alpha-nvim"] = {
    config = { "require('config.alpha-nvim')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["asyncrun.vim"] = {
    commands = { "AsyncRun" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/asyncrun.vim",
    url = "https://github.com/skywind3000/asyncrun.vim"
  },
  ["better-escape.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/better-escape.vim",
    url = "https://github.com/jdhao/better-escape.vim"
  },
  ["bufferline.nvim"] = {
    config = { "require('config.bufferline')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["coc.nvim"] = {
    config = { "require('config.coc')" },
    loaded = true,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/start/coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  ["committia.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/committia.vim",
    url = "https://github.com/rhysd/committia.vim"
  },
  delimitMate = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/delimitMate",
    url = "https://github.com/Raimondi/delimitMate"
  },
  ["doom-one.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/doom-one.nvim",
    url = "https://github.com/NTBBloodbath/doom-one.nvim"
  },
  edge = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/edge",
    url = "https://github.com/sainnhe/edge"
  },
  everforest = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/everforest",
    url = "https://github.com/sainnhe/everforest"
  },
  ["gruvbox-material"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/gruvbox-material",
    url = "https://github.com/sainnhe/gruvbox-material"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20config.nvim_hop\frequire-\1\0\3\0\3\0\0064\0\0\0007\0\1\0001\1\2\0'\2Ð\a>\0\3\1G\0\1\0\0\rdefer_fn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["impatient.nvim"] = {
    config = { "require('impatient')" },
    loaded = true,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "require('config.indent-blankline')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["kanagawa.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('config.statusline')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  neoformat = {
    commands = { "Neoformat" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/neoformat",
    url = "https://github.com/sbdchd/neoformat"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\1\0020\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\21config.neoscroll\frequire-\1\0\3\0\3\0\0064\0\0\0007\0\1\0001\1\2\0'\2Ð\a>\0\3\1G\0\1\0\0\rdefer_fn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  nerdtree = {
    loaded = true,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/start/nerdtree",
    url = "https://github.com/preservim/nerdtree"
  },
  ["nightfox.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nord.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nord.nvim",
    url = "https://github.com/shaunsingh/nord.nvim"
  },
  ["nvim-bqf"] = {
    config = { "require('config.bqf')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-gdb"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nvim-gdb",
    url = "https://github.com/sakhnik/nvim-gdb"
  },
  ["nvim-hlslens"] = {
    config = { "require('config.hlslens')" },
    keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23config.nvim-notify\frequire-\1\0\3\0\3\0\0064\0\0\0007\0\1\0001\1\2\0'\2Ð\a>\0\3\1G\0\1\0\0\rdefer_fn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["open-browser.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  sonokai = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/sonokai",
    url = "https://github.com/sainnhe/sonokai"
  },
  tabular = {
    after_files = { "/home/arjun/.local/share/nvim/site/pack/packer/opt/tabular/after/plugin/TabularMaps.vim" },
    commands = { "Tabularize" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["targets.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-symbols.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-symbols.nvim" },
    commands = { "Telescope" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ultisnips = {
    after = { "vim-snippets" },
    after_files = { "/home/arjun/.local/share/nvim/site/pack/packer/opt/ultisnips/after/plugin/UltiSnips_after.vim" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  ["unicode.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/unicode.vim",
    url = "https://github.com/chrisbra/unicode.vim"
  },
  ["vim-asterisk"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-asterisk",
    url = "https://github.com/haya14busa/vim-asterisk"
  },
  ["vim-commentary"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-conflicted"] = {
    commands = { "Conflicted" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-conflicted",
    url = "https://github.com/christoomey/vim-conflicted"
  },
  ["vim-eunuch"] = {
    commands = { "Rename", "Delete" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-flog"] = {
    commands = { "Flog" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-flog",
    url = "https://github.com/rbong/vim-flog"
  },
  ["vim-fugitive"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gruvbox8"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-gruvbox8",
    url = "https://github.com/lifepillar/vim-gruvbox8"
  },
  ["vim-highlighturl"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-highlighturl",
    url = "https://github.com/itchyny/vim-highlighturl"
  },
  ["vim-indent-object"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-indent-object",
    url = "https://github.com/michaeljsmith/vim-indent-object"
  },
  ["vim-json"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-json",
    url = "https://github.com/elzr/vim-json"
  },
  ["vim-markdown"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-markdown",
    url = "https://github.com/plasticboy/vim-markdown"
  },
  ["vim-markdownfootnotes"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-markdownfootnotes",
    url = "https://github.com/vim-pandoc/vim-markdownfootnotes"
  },
  ["vim-matchup"] = {
    after_files = { "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-mundo"] = {
    commands = { "MundoToggle", "MundoShow" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-mundo",
    url = "https://github.com/simnalamburt/vim-mundo"
  },
  ["vim-obsession"] = {
    commands = { "Obsession" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-oscyank"] = {
    commands = { "OSCYank", "OSCYankReg" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-oscyank",
    url = "https://github.com/ojroques/vim-oscyank"
  },
  ["vim-python-pep8-indent"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-python-pep8-indent",
    url = "https://github.com/Vimjas/vim-python-pep8-indent"
  },
  ["vim-pythonsense"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-pythonsense",
    url = "https://github.com/jeetsukumaran/vim-pythonsense"
  },
  ["vim-repeat"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-sandwich"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-sandwich",
    url = "https://github.com/machakann/vim-sandwich"
  },
  ["vim-scriptease"] = {
    commands = { "Scriptnames", "Message", "Verbose" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-scriptease",
    url = "https://github.com/tpope/vim-scriptease"
  },
  ["vim-signify"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-signify",
    url = "https://github.com/mhinz/vim-signify"
  },
  ["vim-snippets"] = {
    load_after = {
      ultisnips = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-swap"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-swap",
    url = "https://github.com/machakann/vim-swap"
  },
  ["vim-toml"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/vim-toml",
    url = "https://github.com/cespare/vim-toml"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\1\0020\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\21config.which-key\frequire-\1\0\3\0\3\0\0064\0\0\0007\0\1\0001\1\2\0'\2Ð\a>\0\3\1G\0\1\0\0\rdefer_fn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["whitespace.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/whitespace.nvim",
    url = "https://github.com/jdhao/whitespace.nvim"
  },
  ["wilder.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/wilder.nvim",
    url = "https://github.com/gelguy/wilder.nvim"
  },
  ["zen-mode.nvim"] = {
    commands = { "ZenMode" },
    config = { "require('config.zen-mode')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/arjun/.local/share/nvim/site/pack/packer/opt/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: committia.vim
time([[Setup for committia.vim]], true)
vim.cmd('packadd committia.vim')
time([[Setup for committia.vim]], false)
-- Setup for: nvim-gdb
time([[Setup for nvim-gdb]], true)
vim.cmd('packadd nvim-gdb')
time([[Setup for nvim-gdb]], false)
-- Setup for: wilder.nvim
time([[Setup for wilder.nvim]], true)
vim.cmd('packadd wilder.nvim')
time([[Setup for wilder.nvim]], false)
-- Config for: impatient.nvim
time([[Config for impatient.nvim]], true)
require('impatient')
time([[Config for impatient.nvim]], false)
-- Config for: coc.nvim
time([[Config for coc.nvim]], true)
require('config.coc')
time([[Config for coc.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file MundoToggle lua require("packer.load")({'vim-mundo'}, { cmd = "MundoToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Tabularize lua require("packer.load")({'tabular'}, { cmd = "Tabularize", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ZenMode lua require("packer.load")({'zen-mode.nvim'}, { cmd = "ZenMode", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Delete lua require("packer.load")({'vim-eunuch'}, { cmd = "Delete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OSCYank lua require("packer.load")({'vim-oscyank'}, { cmd = "OSCYank", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Conflicted lua require("packer.load")({'vim-conflicted'}, { cmd = "Conflicted", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Rename lua require("packer.load")({'vim-eunuch'}, { cmd = "Rename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Message lua require("packer.load")({'vim-scriptease'}, { cmd = "Message", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Leaderf lua require("packer.load")({'LeaderF'}, { cmd = "Leaderf", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Obsession lua require("packer.load")({'vim-obsession'}, { cmd = "Obsession", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neoformat lua require("packer.load")({'neoformat'}, { cmd = "Neoformat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file MundoShow lua require("packer.load")({'vim-mundo'}, { cmd = "MundoShow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Flog lua require("packer.load")({'vim-flog'}, { cmd = "Flog", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file OSCYankReg lua require("packer.load")({'vim-oscyank'}, { cmd = "OSCYankReg", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file AsyncRun lua require("packer.load")({'asyncrun.vim'}, { cmd = "AsyncRun", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Scriptnames lua require("packer.load")({'vim-scriptease'}, { cmd = "Scriptnames", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[nnoremap <silent> N <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "N", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> n <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "n", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> # <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "#", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> * <cmd>lua require("packer.load")({'nvim-hlslens'}, { keys = "*", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-json', 'vim-markdown', 'vim-markdownfootnotes'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType toml ++once lua require("packer.load")({'vim-toml'}, { ft = "toml" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'vim-pythonsense', 'vim-python-pep8-indent'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType json ++once lua require("packer.load")({'vim-json'}, { ft = "json" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au FileType qf ++once lua require("packer.load")({'nvim-bqf'}, { event = "FileType qf" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'AutoSave.nvim', 'alpha-nvim', 'unicode.vim', 'nvim-web-devicons', 'vim-commentary', 'vim-highlighturl', 'lualine.nvim', 'open-browser.vim', 'whitespace.nvim', 'vim-repeat', 'vim-sandwich', 'indent-blankline.nvim', 'bufferline.nvim', 'hop.nvim', 'which-key.nvim', 'vim-asterisk', 'vim-swap', 'targets.vim', 'vim-matchup', 'vim-indent-object', 'neoscroll.nvim', 'lspkind-nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au User InGitRepo ++once lua require("packer.load")({'vim-fugitive'}, { event = "User InGitRepo" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'better-escape.vim', 'delimitMate', 'ultisnips'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'vim-signify', 'nvim-notify'}, { event = "BufEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-json/ftdetect/json.vim]], true)
vim.cmd [[source /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-json/ftdetect/json.vim]]
time([[Sourcing ftdetect script at: /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-json/ftdetect/json.vim]], false)
time([[Sourcing ftdetect script at: /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], true)
vim.cmd [[source /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]]
time([[Sourcing ftdetect script at: /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], false)
time([[Sourcing ftdetect script at: /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-toml/ftdetect/toml.vim]], true)
vim.cmd [[source /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-toml/ftdetect/toml.vim]]
time([[Sourcing ftdetect script at: /home/arjun/.local/share/nvim/site/pack/packer/opt/vim-toml/ftdetect/toml.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
