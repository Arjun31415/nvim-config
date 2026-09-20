local configFunctions = require("config.lsp.handlers")
local lspconfig = vim.lsp.config

configFunctions.setup()

local defaults = {
    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
}

local function server(name, opts)
    lspconfig(name, vim.tbl_deep_extend("force", defaults, opts or {}))
    vim.lsp.enable(name)
end

for _, name in ipairs({ "clangd", "ts_ls", "cmake", "ty" }) do
    server(name)
end

server("lua_ls", {
    settings = { Lua = { workspace = { checkThirdParty = false } } },
})

server("jsonls", require("config.lsp.settings.jsonls"))

server("jdtls", require("config.lsp.settings.jdtls"))

server("tinymist", {
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
    },
})

-- nixd over nil_ls: it completes nix-darwin/home-manager option names when
-- pointed at this flake. macOS only: darwinConfigurations is darwin-specific.
local flake = vim.env.HOME .. "/nix-darwin-config"
if vim.fn.has("mac") == 1 and vim.uv.fs_stat(flake .. "/flake.nix") then
    -- nix-darwin keys darwinConfigurations by hostname; read it at runtime
    -- rather than commit it. Strip the DNS suffix the flake attribute lacks.
    local host = vim.uv.os_gethostname():gsub("%..*$", "")
    server("nixd", {
        settings = {
            nixd = {
                nixpkgs = { expr = ("import (builtins.getFlake %q).inputs.nixpkgs { }"):format(flake) },
                options = {
                    darwin = {
                        expr = ("(builtins.getFlake %q).darwinConfigurations.%s.options"):format(flake, host),
                    },
                    home_manager = {
                        expr = ("(builtins.getFlake %q).darwinConfigurations.%s.options.home-manager.users.type.getSubOptions []"):format(
                            flake,
                            host
                        ),
                    },
                },
                formatting = { command = { "nixfmt" } },
            },
        },
    })
else
    server("nixd")
end

-- basedpyright is configured but not enabled; `ty` handles python above.
lspconfig(
    "basedpyright",
    vim.tbl_deep_extend("force", defaults, {
        before_init = function(_, config)
            config.settings.basedpyright.analysis.stubPath =
                vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "python-type-stubs")
        end,
    })
)

require("config.lsp.settings.rust")
